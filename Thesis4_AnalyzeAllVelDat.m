%% Thesis4_AnalyzeAllVelDat.m
% 
%   Analyze LFP data from familiar arena ('BL') including all movement velocity ranges:
%       - Theta phase lag analysis: Filtered by mean dHPC power threshold
%       - Band power cross-correlations (theta, gamma, delta): To be Z-scored
% 
%   Steps:
%       1. Filter for theta band (ThetaFiltfilt)
%       2. Theta Phase Lag analysis
%       3. Format data for bootstrapping: Theta phase lag, width @ half-max
%       4. Band power cross-correlations (theta, gamma, delta) 
%       5. Format data for bootstrapping: Band power cross-corr (R^2)
%       6. Z-score R^2 data (theta, gamma, delta)
%
% 	*Requires MATLAB Signal Processing Toolbox be installed*
% 
%   Calls functions (listed alphabetically):
% 	- BandPowerCrossCorr.m
% 	- Format4Bootstrap_Rsq.m
% 	- Format4Bootstrap_thetaphaselagdH.m
% 	- mtcsg.m (from A.Adhikari)
% 	- regoutliers.m   (https://www.mathworks.com/matlabcentral/fileexchange/37212-regression-outliers)
% 	- ThetaPhaseLagdH.m
% 	- ZscoreRsq_boot.m
% 
% KJS init 2020-02-12, edit 2020-02-13, 2020-02-14


%% SETUP
subjs = {'A201' 'A202' 'A301' 'A602' 'E105' 'E106' 'E107' 'E108' 'E201'}; % Subject ID listing. A*=male  E*=female 
arenas = {'BL' 'EPM'}; % recording arenas

% Set data directories & ensure scripts are added to file path
root_drIn = [uigetdir(pwd,'Select root ReducedEEG data directory') filesep];
%root_drIn = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\ReducedEEG\' ;


%% 1. ThetaFiltfilt 
%  Filter LFP data for theta band (4-12 Hz) (all movement velocities included)

% Build Theta filter (4-12 Hz)
Fs = 2000; %sampling frequency (Hz)
Fn = Fs/2;             % Nyquist Frequency
Wp = [4  12]/Fn;         % Theta Passband
Ws = [2.5 13.5]/(Fs/2);  %Theta StopBand
Rp = 3;                 %ripple pass
Rs = 40;                %ripple stop
[n,Wn] = buttord(Wp,Ws,Rp,Rs); %Butterworth filter order selection.
[z, p, k] = butter(n,Wn,'bandpass'); %Butterworth digital and analog filter design
[sos,g] = zp2sos(z,p,k); %Zero-pole-gain to second-order sections model conversion
clear Fn W* z p k R* n

for si = 1:length(subjs) %loop thru subjects
    for ai = 1:length(arenas) %loop thru recording arenas (BL, EPM)
        rt = arenas{ai}; 
        drIn = [root_drIn rt filesep subjs{si} filesep]; %subject's data directory
        
        % Load in subject's ReducedData
        fprintf('Loading %s data for %s...\n',rt,subjs{si})
        load([drIn subjs{si} '_ReducedData.mat'],'IL','PL','DHIP','VHIP','Rxlist') % load in data: all trials

        % Reshape LFP data
        nrex = length(Rxlist); % number of trials
        npts = size(IL,1); %number of timepoints
        il = reshape(IL,nrex*npts,1); clear IL
        pl = reshape(PL,nrex*npts,1); clear PL
        dh = reshape(DHIP,nrex*npts,1); clear DHIP
        vh = reshape(VHIP,nrex*npts,1); clear VHIP    

        % Add 1s padding to start and end of time series to remove ringer & Filter for theta
        disp('Filtering for theta...')
         il_th = filtfilt(sos,g,[zeros(Fs,1); il; zeros(Fs,1)]);  
         il_th = il_th(Fs+1 : end-Fs); %remove padding
        disp('.')
         dh_th = filtfilt(sos,g,[zeros(Fs,1); dh; zeros(Fs,1)]); 
         dh_th = dh_th(Fs+1 : end-Fs); 
        disp('.')
         vh_th = filtfilt(sos,g,[zeros(Fs,1); vh; zeros(Fs,1)]); 
         vh_th = vh_th(Fs+1 : end-Fs); 
        disp('.')
         pl_th = filtfilt(sos,g,[zeros(Fs,1); pl; zeros(Fs,1)]);  
         pl_th = pl_th(Fs+1 : end-Fs); 

        % Reshape theta data back into trials (recordings)
        il_th = reshape(il_th,npts,nrex);
        pl_th = reshape(pl_th,npts,nrex);
        dh_th = reshape(dh_th,npts,nrex);
        vh_th = reshape(vh_th,npts,nrex);
        clear npts nrex

        % Save data - single-subject, all trials for this arena
        fprintf('Saving thetafiltfilt data for %s...\n',subjs{si})
        if strcmp(subjs{si}(1),'A') %male
            save([drIn subjs{si} '_ThetaFiltfilt.mat'],'*_th','il','dh','vh','pl','Rxlist','drIn','Fs','-v7.3')
        else %female
            save([drIn subjs{si} '_ThetaFiltfilt.mat'],'*_th','il','dh','vh','pl','Rxlist','drIn','Fs','idx','-v7.3')
        end
        disp('ThetaFiltfilt saved!')
        clear rt dh il pl vh Rxlist *_th  % Reset workspace
    end %arenas
    clear ai idx
end %subjects
clear si g sos drIn Fs 
disp('Theta filtfilt complete!')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Theta Phase Lag analysis 
 % See: ThetaPhaseLagdH.m
disp('Beginning Theta phase lag analysis: threshold by dHPC theta power')
for ai = 1:length(arenas)
    rt = arenas{ai};
    drIn = [root_drIn rt filesep];
    [ILDH,ILVH,ILPL,DHVH,DHPL,VHPL,dthresh,dat_pct] = ThetaPhaseLagdH(subjs,drIn);
    
    % Save the data  (large file - contains all subjs)
    disp('Saving theta phase lag data...')
    fn = ['ThetaPhaseLags-' rt '-AllSpeeds-dHthresh.mat'];
    save([drIn fn],'dat_pct','DHPL','DHVH','dthresh','ILDH','ILPL','ILVH','root_drIn','subjs','VHPL','-v7.3')
    disp('Saved!')
    clear dthresh rt drIn IL* DH* VH* dat_pct fn
end
clear ai


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. Format BL data for bootstrapping: Theta phase lag, width @ half-max
 % See: Format4Bootstrap_thetaphaselagdH.m
disp('Loading theta phase lag data..')
fn = 'ThetaPhaseLags2-BL-AllSpeeds-dHthresh.mat'; %file name to load (generated above in #2.)
load([root_drIn 'BL' filesep fn],'ILDH','ILVH','ILPL','DHVH','DHPL','VHPL')
clear fn

disp('Formatting theta phase lag data for bootstrapping')
[M_ILDH,M_ILVH,M_ILPL,M_DHVH,M_DHPL,M_VHPL,F_ILDH,F_ILVH,F_ILPL,F_DHVH,F_DHPL,F_VHPL,...
F_ILDH_D,F_ILVH_D,F_ILPL_D,F_DHVH_D,F_DHPL_D,F_VHPL_D,F_ILDH_P,F_ILVH_P,F_ILPL_P,F_DHVH_P,F_DHPL_P,F_VHPL_P,...
F_ILDH_E,F_ILVH_E,F_ILPL_E,F_DHVH_E,F_DHPL_E,F_VHPL_E,F_ILDH_M,F_ILVH_M,F_ILPL_M,F_DHVH_M,F_DHPL_M,F_VHPL_M] ...
    = Format4Bootstrap_thetaphaselagdH(subjs,root_drIn,ILDH,ILVH,ILPL,DHVH,DHPL,VHPL);
disp('Format4Bootstrap_ThetaPhaseLag complete.')

 
% Save the data: Male and Female data
fn = 'ThetaPhaseLag-dHthresh-BL_boot.mat';
save([root_drIn 'BL' filesep fn],'F*','M*','-v7.3')
disp('Data saved: Theta phaselag, bootstrap format')
clear fn F* M*


%% 3.1 Concatenate all trials - Theta Phase lags by connection
ildh = []; ilvh = []; ilpl = []; dhvh = []; dhpl = []; vhpl = []; % Preallocate output space
for i = 1:length(subjs)
    ildh = [ildh; cell2mat([ILDH{1,i}(1,:)]')];
    ilvh = [ilvh; cell2mat([ILVH{1,i}(1,:)]')];
    ilpl = [ilpl; cell2mat([ILPL{1,i}(1,:)]')];
    dhvh = [dhvh; cell2mat([DHVH{1,i}(1,:)]')];
    dhpl = [dhpl; cell2mat([DHPL{1,i}(1,:)]')];
    vhpl = [vhpl; cell2mat([VHPL{1,i}(1,:)]')];
end
clear i ILDH ILVH ILPL DHVH DHPL VHPL

% Save the data
fn = 'ThetaPhaseLags-dHthresh-BL-AllTrialsConcat.mat';
save([root_drIn 'BL' filesep fn],'ildh','ilvh','ilpl','dhvh','dhpl','vhpl','subjs')
disp('Concatenated theta phase lag time series saved.')


%% 3.4 Generate phase lag histogram distributions (all trials by connection)
%...
clear ildh ilvh ilpl dhvh dhpl vhpl
    
    % Save the data
%     fn = 'ThetaPhaseLags-dHthresh-BL-AllTrialsConcat-hist.mat';
%     save([root_drIn fn],'edges','numbins','*_hist','*_hafmaxidx','*_widthhafmax','width*','x','-v7.3')

%% 3.5 Find width @ 1/2 max on concatenated data
% fn = 'ThetaPhaseLags-dHthresh-BL-AllTrialsConcat-hist.mat';
% load([root_drIn fn],'*_hist','x')
% load([root_drIn 'ThetaPhaseLags-dHthresh-BL-AllTrialsConcat.mat']) %check directory accuracy
% ildh_phase_diff_hist=hist(ildh,edges);
% halph_max_ildh=(max(ildh_phase_diff_hist))/2; %identifies half of the peak height of the histogram
% [~,hafmaxidx] = (max(ildh_phase_diff_hist)); %i
% width_at_halph_max_ildh=find(ildh_phase_diff_hist>halph_max_ildh); %finds indices of the bins which have height higher than the peak_height/2
% width_at_halph_max_ildh=length(width_at_halph_max_ildh); %coun
% ildh_widthhafmax = width_at_halph_max_ildh*mean(diff(edges));
% ilvh_phase_diff_hist=hist(ilvh,edges);
% % width at half of maximum peak
% halph_max_ilvh=(max(ilvh_phase_diff_hist))/2;
% [~,hafmaxidx] = (max(ilvh_phase_diff_hist));
% ilvh_hafmaxidx = hafmaxidx;
% width_at_halph_max_ilvh=find(ilvh_phase_diff_hist>halph_max_ilvh);
% width_at_halph_max_ilvh=length(width_at_halph_max_ilvh);
% ilvh_widthhafmax = width_at_halph_max_ilvh*mean(diff(edges));
% dhpl_phase_diff_hist=hist(dhpl,edges);
% halph_max_dhpl=(max(dhpl_phase_diff_hist))/2;
% [~,dhpl_hafmaxidx] = (max(dhpl_phase_diff_hist));
% [~,hafmaxidx] = (max(dhpl_phase_diff_hist));
% width_at_halph_max_dhpl=find(dhpl_phase_diff_hist>halph_max_dhpl);
% width_at_halph_max_dhpl=length(width_at_halph_max_dhpl);
% dhpl_widthhafmax = width_at_halph_max_dhpl*mean(diff(edges)); 
% vhpl_phase_diff_hist=hist(vhpl,edges);
% halph_max_vhpl=(max(vhpl_phase_diff_hist))/2;
% [~,hafmaxidx] = (max(vhpl_phase_diff_hist));
% vhpl_hafmaxidx = hafmaxidx
% width_at_halph_max_vhpl=find(vhpl_phase_diff_hist>halph_max_vhpl);
% width_at_halph_max_vhpl=length(width_at_halph_max_vhpl);
% vhpl_widthhafmax = width_at_halph_max_vhpl*mean(diff(edges)); 
% [~,ildh_hafmaxidx] = (max(ildh_phase_diff_hist));
% clear dhpl ildh vhpl ilvh

    % Save the data
    % fn = 'ThetaPhaseLags-dHthresh-BL-AllTrialsConcat-hist.mat';
    % save([root_drIn 'BL' filesep fn],'edges','dhpl*','ildh*','ilvh*','vhpl*','numbins','width_*','x','-v7.3')
    % clear ildh* ilvh* ilpl* dhvh* dhpl* vhpl* fn

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. Band power cross-correlations (theta, gamma, delta) 
 % See: BandPowerCrossCorr.m

% Automatically loops thru subjects and arenas, and auto-saves data in: root_drIn/rt/subjID
plotOp = 0; %Set to 1 if you want to generate plots for each scatter, w/ and w/o outliers ** (an auto-saving mechanism has NOT yet been written into BandPowerCrossCorr.m)
disp('Calculating band power cross-correlations: theta, gamma, & delta')
BandPowerCrossCorr(subjs,root_drIn,arenas,plotOp);
clear plotOp


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. Format data for bootstrapping: Band power xcorr, R^2_orig, MvF
 % See: Format4Bootstrap_Rsq.m
 
drIn = [root_drIn 'BL' filesep]; %BL arena recordings only
bandz = {'Theta' 'Gamma' 'Delta'}; %frequency bands of interest

% Load index for hormone states across trials
%    idx format:
%     (:,1) = Diestrus
%     (:,2) = Proestrus
%     (:,3) = Estrus
%     (:,4) = Metestrus
load([drIn 'FemaleIDX.mat'],'IDX');

for bi = 1:length(bandz) %loop Theta, Gamma, Delta bands
    fprintf('Bootstrap formatting R^2 %s band..\n',bandz{bi})

    [M_ILDH,M_ILVH,M_ILPL,M_DHVH,M_DHPL,M_VHPL,F_ILDH,F_ILVH,F_ILPL,F_DHVH,F_DHPL,F_VHPL,...
    F_ILDH_D,F_ILVH_D,F_ILPL_D,F_DHVH_D,F_DHPL_D,F_VHPL_D,F_ILDH_P,F_ILVH_P,F_ILPL_P,F_DHVH_P,F_DHPL_P,F_VHPL_P,...
    F_ILDH_E,F_ILVH_E,F_ILPL_E,F_DHVH_E,F_DHPL_E,F_VHPL_E,F_ILDH_M,F_ILVH_M,F_ILPL_M,F_DHVH_M,F_DHPL_M,F_VHPL_M]...
    = Format4Bootstrap_Rsq(subjs,drIn,IDX,bandz{bi}); %#ok<*ASGLU>

    % Save R^2 data: MvF
    fn = [bandz{bi} 'Rsq-BL_boot.mat'];
    save([drIn fn],'F*','M*','-v7.3')
    fprintf('%s R^2 data saved.\n',bandz{bi})
    clear fn M_* F_*
end
clear bi bandz drIn IDX 
disp('Format4Bootstrap_Rsq.m is complete.')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6. Zscore R^2 data (theta, gamma, delta)
 % See: ZscoreRsq_boot2.m 
 
for bi = 1:length(bandz) %loop Theta, Gamma, Delta bands
    fprintf('Z-scoring R^2 %s band..\n',bandz{bi})
    
    % Load in R^2 data
    fn = [bandz{bi} 'Rsq-BL_boot.mat']; %file name to load
    load([root_drIn 'BL' filesep fn],'M_*','F_ILDH','F_ILVH','F_ILPL','F_DHVH','F_DHPL','F_VHPL')
    clear fn
    
    % Z-score
    [M_ILDH_z, M_ILVH_z, M_ILPL_z, M_DHVH_z, M_DHPL_z, M_VHPL_z, ...
    F_ILDH_z, F_ILVH_z, F_ILPL_z, F_DHVH_z, F_DHPL_z, F_VHPL_z,Z_all] = ...
    ZscoreRsq_boot2(M_ILDH, M_ILVH, M_ILPL, M_DHVH, M_DHPL, M_VHPL, ...
    F_ILDH, F_ILVH, F_ILPL, F_DHVH, F_DHPL, F_VHPL);
    
    % Save Z-transformed data
    FN = [bandz{bi} 'Rsq_z-BL_boot.mat']; %file name to save
    save([root_drIn 'BL' filesep FN],'F*','M*','Z_all')
    fprintf('Bootstrap z-scored %s Rsq data saved!\n',bandz{bi})
    clear FN M_* F_* Z_all
    
end
clear bandz bi
    
disp('Thesis4_AnalyzeAllVelDat.m is complete.')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end of script