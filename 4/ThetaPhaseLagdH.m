function [ILDH,ILVH,ILPL,DHVH,DHPL,VHPL,dthresh,dat_pct] = ThetaPhaseLagdH(subjs,DrIn)
%ThetaPhaseLagdH 2
% [ILDH,ILVH,ILPL,DHVH,DHPL,VHPL,dthresh,dat_pct] = ThetaPhaseLagdH(subjs,DrIn)
%   
% Calculates theta phase lag distribution between pairs of brain regions. 
%   Always subtracting mPFC from HPC phases because HPC initiates theta oscillations.
% Only using time epochs when dHPC theta power is greater than its mean for that trial.
% 
%   OUTPUTS:
%       - [****]    Pairwise theta lag distribution
%           {1,:}   Inter-regional phase difference time series
%           {2,:}   Histogram of inter-regional phase difference time series
%           {3,:}   Index of bin where phase lag peak is located
%           {4,:}   Width at half-max of peak
%       - dthresh   Mean dHPC theta power per recording
%       - dat_pct   Proprtionate lengths of data that met mean dHPC threshold
%
%   CALLED BY:
%       Thesis4_AnalyzeAllVelDat.m
% 
% KJS init: 2020-03-13

%% Setup
edges=-pi:0.01:pi; % defines the bin edges of the phase histogram

% Preallocate output space
    ILDH = cell(size(subjs)); % dHPC - mPFCil
    ILVH = cell(size(subjs)); % vHPC - mPFCil
    ILPL = cell(size(subjs)); % IL - PL
    DHVH = cell(size(subjs)); % DH - VH
    DHPL = cell(size(subjs)); % DH - PL
    VHPL = cell(size(subjs)); % VH - PL
    dthresh = cell(size(subjs)); %mean dHPC theta power per recording
    dh_thetagood = cell(size(subjs)); % time epochs when dHPC theta is greater than its mean for that trial
    dat_pct= cell(size(subjs)); % percent of data that passes the threshold


for si = 1:length(subjs) %loop thru subjects
    drIn = [DrIn subjs{si} filesep]; %subject's data directory

    %% Load in combined data set (timepoints x recordings, per region, cleaned)
    fprintf('Loading data for %s...\n',subjs{si})
    load([drIn subjs{si} '_ThetaFiltfilt.mat'],'*_th') %variables: il_th, pl_th, vh_th, dh_th. size:[12000001 x nrex]
    

    fprintf('Calculating theta phase analysis for %s...\n',subjs{si})
    %% Hilbert transform: Extract phase angle data
    il_ang_d = angle(hilbert(il_th));
    dh_ang_d = angle(hilbert(dh_th));
    vh_ang_d = angle(hilbert(vh_th));
    pl_ang_d = angle(hilbert(pl_th));
    clear il_th pl_th vh_th 
    disp('.')
    
    %% Determine threshold based on mean dHPC theta power
%     dh_pow = dh_th.^2; %amplitude^2
    dh_env = abs(hilbert(dh_th)); %theta power envelope
      clear dh_th  
%     dthresh{si} = mean(dh_pow,1); %mean dHPC theta power per recording
    dthresh{si} = mean(dh_env,1); %mean dHPC theta power per recording
%     dh_thetagood{si} = bsxfun(@gt,dh_pow,dthresh{si}); %logical array: values greater than thresh
    dh_thetagood{si} = bsxfun(@gt,dh_env,dthresh{si}); %logical array: values greater than thresh
      clear dh_pow  dh_env
            
    %% Determine proprtionate lengths of data that met threshold
    t = 1:length(dh_ang_d); % time vector (2kHz sampling rate)
    t = repmat(t,[size(dh_ang_d,2) 1])'; % matrix to align with vh_pow [1200001 x nrex]
    for ri = 1:size(dh_ang_d,2) %loop thru trials
        dat_pct{si,1}(1,ri) = (size(find(dh_ang_d(:,ri).*dh_thetagood{si}(:,ri)),1) / size(t,1))*100; %using dHPC mean: ~36% of data included
    end
    clear t ri
    
    %% Apply threshold
    % Doing it this way preserves [1200001 x nrex] matrix shape, but will require a non-zero index when accessing values later
    il_ang_d = il_ang_d.*dh_thetagood{si};
    pl_ang_d = pl_ang_d.*dh_thetagood{si};
    dh_ang_d = dh_ang_d.*dh_thetagood{si};
    vh_ang_d = vh_ang_d.*dh_thetagood{si};
    clear dh_thetagood

    isNZ = ~(dh_ang_d==0); %index of non-zero values (passed threshold)

    %% Calculate inter-area phase lags
%     Column 1: inter-regional phase difference time series
%     Column 2: histogram of inter-regional phase difference time series
%     Column 3: Index of bin where phase lag peak is located
%     Column 4: Width at half-max of peak

    for ri = 1:size(il_ang_d,2) %loop thru trials
        fprintf('%i of %i..\n',ri,size(il_ang_d,2))
    
        %% 1. dHPC-IL
        ildh_phase_diff=dh_ang_d(isNZ(:,ri),ri)-il_ang_d(isNZ(:,ri),ri); %calculates difference between phases of il and dhpc. The values range from -2*pi to +2*pi
        fpl=find(ildh_phase_diff>pi);%identifies phase differences larger than pi and subtracts pi from them.
        ildh_phase_diff(fpl)=ildh_phase_diff(fpl)-pi; %wraparound for differences larger than pi
        gpl=find(ildh_phase_diff<-pi);%does the same thing, but for phase differences smaller than -pi
        ildh_phase_diff(gpl)=ildh_phase_diff(gpl)+pi; %now il_dhip_phase_diff has only values in between -pi and +pi
        ildh_phase_diff_hist=hist(ildh_phase_diff,edges); %histogram distribution of differences
        ILDH{1,si}{1,ri} = ildh_phase_diff; % ** inter-regional phase difference time series **
        ILDH{1,si}{2,ri} = ildh_phase_diff_hist; % ** histogram of inter-regional phase difference time series **
    
        % width at half of maximum peak 
        halph_max_ildh=(max(ildh_phase_diff_hist))/2; %identifies half of the peak height of the histogram
        [~,hafmaxidx] = (max(ildh_phase_diff_hist)); %index of the bins where the peak is located
        ILDH{1,si}{3,ri} = hafmaxidx; % ** Index of bin where phase lag peak is located **
        width_at_halph_max_ildh=find(ildh_phase_diff_hist>halph_max_ildh); %finds indices of the bins which have height higher than the peak_height/2
        width_at_halph_max_ildh=length(width_at_halph_max_ildh); %counts the number of bins that have height higher than peak_height/2
        ILDH{1,si}{4,ri} = width_at_halph_max_ildh*mean(diff(edges)); % ** Width at half-max of peak **

        clear ildh_* gpl fpl width_at_halph_max_ildh hafmaxidx halph_max_ildh
        
        %% 2. vHPC-IL
        ilvh_phase_diff=vh_ang_d(isNZ(:,ri),ri)-il_ang_d(isNZ(:,ri),ri); 
        fpl=find(ilvh_phase_diff>pi);
        ilvh_phase_diff(fpl)=ilvh_phase_diff(fpl)-pi; 
        gpl=find(ilvh_phase_diff<-pi);
        ilvh_phase_diff(gpl)=ilvh_phase_diff(gpl)+pi;
        ilvh_phase_diff_hist=hist(ilvh_phase_diff,edges);
        ILVH{1,si}{1,ri} = ilvh_phase_diff; % ** inter-regional phase difference time series **
        ILVH{1,si}{2,ri} = ilvh_phase_diff_hist; % ** histogram of inter-regional phase difference time series **
    
        % width at half of maximum peak 
        halph_max_ilvh=(max(ilvh_phase_diff_hist))/2; 
        [~,hafmaxidx] = (max(ilvh_phase_diff_hist)); 
        ILVH{1,si}{3,ri} = hafmaxidx; % ** Index of bin where phase lag peak is located **
        width_at_halph_max_ilvh=find(ilvh_phase_diff_hist>halph_max_ilvh); 
        width_at_halph_max_ilvh=length(width_at_halph_max_ilvh);
        ILVH{1,si}{4,ri} = width_at_halph_max_ilvh*mean(diff(edges)); % ** Width at half-max of peak **

        clear ilvh_* gpl fpl width_at_halph_max_ilvh hafmaxidx halph_max_ilvh
        
        %% 3. IL-PL
        ilpl_phase_diff=il_ang_d(isNZ(:,ri),ri)-pl_ang_d(isNZ(:,ri),ri); 
        fpl=find(ilpl_phase_diff>pi);
        ilpl_phase_diff(fpl)=ilpl_phase_diff(fpl)-pi; 
        gpl=find(ilpl_phase_diff<-pi);
        ilpl_phase_diff(gpl)=ilpl_phase_diff(gpl)+pi; 
        ilpl_phase_diff_hist=hist(ilpl_phase_diff,edges); 
        ILPL{1,si}{1,ri} = ilpl_phase_diff; % ** inter-regional phase difference time series **
        ILPL{1,si}{2,ri} = ilpl_phase_diff_hist; % ** histogram of inter-regional phase difference time series **
    
        % width at half of maximum peak 
        halph_max_ilpl=(max(ilpl_phase_diff_hist))/2; 
        [~,hafmaxidx] = (max(ilpl_phase_diff_hist)); 
        ILPL{1,si}{3,ri} = hafmaxidx; % ** Index of bin where phase lag peak is located **
        width_at_halph_max_ilpl=find(ilpl_phase_diff_hist>halph_max_ilpl); 
        width_at_halph_max_ilpl=length(width_at_halph_max_ilpl);
        ILPL{1,si}{4,ri} = width_at_halph_max_ilpl*mean(diff(edges)); % ** Width at half-max of peak **

        clear ilpl_* gpl fpl width_at_halph_max_ilpl hafmaxidx halph_max_ilpl
        
        %% 4. DH-VH
        % Theta is believed to travel "ventrally" down the septotemporal axis
        dhvh_phase_diff=dh_ang_d(isNZ(:,ri),ri)-vh_ang_d(isNZ(:,ri),ri); 
        fpl=find(dhvh_phase_diff>pi);
        dhvh_phase_diff(fpl)=dhvh_phase_diff(fpl)-pi; 
        gpl=find(dhvh_phase_diff<-pi);
        dhvh_phase_diff(gpl)=dhvh_phase_diff(gpl)+pi; 
        dhvh_phase_diff_hist=hist(dhvh_phase_diff,edges); 
        DHVH{1,si}{1,ri} = dhvh_phase_diff; % ** inter-regional phase difference time series **
        DHVH{1,si}{2,ri} = dhvh_phase_diff_hist; % ** histogram of inter-regional phase difference time series **
    
        % width at half of maximum peak 
        halph_max_dhvh=(max(dhvh_phase_diff_hist))/2; 
        [~,hafmaxidx] = (max(dhvh_phase_diff_hist)); 
        DHVH{1,si}{3,ri} = hafmaxidx; % ** Index of bin where phase lag peak is located **
        width_at_halph_max_dhvh=find(dhvh_phase_diff_hist>halph_max_dhvh); 
        width_at_halph_max_dhvh=length(width_at_halph_max_dhvh);
        DHVH{1,si}{4,ri} = width_at_halph_max_dhvh*mean(diff(edges)); % ** Width at half-max of peak **

        clear dhvh_* gpl fpl width_at_halph_max_dhvh hafmaxidx halph_max_dhvh
        
        %% 5. DH-PL
        dhpl_phase_diff=dh_ang_d(isNZ(:,ri),ri)-pl_ang_d(isNZ(:,ri),ri); 
        fpl=find(dhpl_phase_diff>pi);
        dhpl_phase_diff(fpl)=dhpl_phase_diff(fpl)-pi; 
        gpl=find(dhpl_phase_diff<-pi);
        dhpl_phase_diff(gpl)=dhpl_phase_diff(gpl)+pi; 
        dhpl_phase_diff_hist=hist(dhpl_phase_diff,edges); 
        DHPL{1,si}{1,ri} = dhpl_phase_diff; % ** inter-regional phase difference time series **
        DHPL{1,si}{2,ri} = dhpl_phase_diff_hist; % ** histogram of inter-regional phase difference time series **
    
        % width at half of maximum peak 
        halph_max_dhpl=(max(dhpl_phase_diff_hist))/2; 
        [~,hafmaxidx] = (max(dhpl_phase_diff_hist)); 
        DHPL{1,si}{3,ri} = hafmaxidx; % ** Index of bin where phase lag peak is located **
        width_at_halph_max_dhpl=find(dhpl_phase_diff_hist>halph_max_dhpl); 
        width_at_halph_max_dhpl=length(width_at_halph_max_dhpl);
        DHPL{1,si}{4,ri} = width_at_halph_max_dhpl*mean(diff(edges)); % ** Width at half-max of peak **

        clear dhpl_* gpl fpl width_at_halph_max_dhpl hafmaxidx halph_max_dhpl
        
        %% 6. VH-PL
        vhpl_phase_diff=vh_ang_d(isNZ(:,ri),ri)-pl_ang_d(isNZ(:,ri),ri); 
        fpl=find(vhpl_phase_diff>pi);
        vhpl_phase_diff(fpl)=vhpl_phase_diff(fpl)-pi; 
        gpl=find(vhpl_phase_diff<-pi);
        vhpl_phase_diff(gpl)=vhpl_phase_diff(gpl)+pi; 
        vhpl_phase_diff_hist=hist(vhpl_phase_diff,edges); 
        VHPL{1,si}{1,ri} = vhpl_phase_diff; % ** inter-regional phase difference time series **
        VHPL{1,si}{2,ri} = vhpl_phase_diff_hist; % ** histogram of inter-regional phase difference time series **
    
        % width at half of maximum peak 
        halph_max_vhpl=(max(vhpl_phase_diff_hist))/2; 
        [~,hafmaxidx] = (max(vhpl_phase_diff_hist)); 
        VHPL{1,si}{3,ri} = hafmaxidx; % ** Index of bin where phase lag peak is located **
        width_at_halph_max_vhpl=find(vhpl_phase_diff_hist>halph_max_vhpl); 
        width_at_halph_max_vhpl=length(width_at_halph_max_vhpl);
        VHPL{1,si}{4,ri} = width_at_halph_max_vhpl*mean(diff(edges)); % ** Width at half-max of peak **

        clear vhpl_* gpl fpl width_at_halph_max_vhpl hafmaxidx halph_max_vhpl
    end %trials
    
    % Reset workspace for next subject
    clear *_ang isNZ ri *_ang_d drIn
end %subjects





end %function
