%% Thesis4_AnalyzeAllVelDat.m
% 
%   Analyze LFP data from familiar arena ('BL') including all movement velocity ranges:
%       - Theta phase lag analysis: Filtered by mean dHPC power threshold
%       - Band power cross-correlations (theta, gamma, delta): To be Z-scored
% 
% 
%   Steps:
%       1. ThetaFiltfilt 
%       2. Theta Phase Lag analysis
%       3. Format data for bootstrapping: Theta phase lag, width @ half-max
%       4. Band power cross-correlations (theta, gamma, delta) 
%       5. Format data for bootstrapping: Band power cross-corr (R^2)
%       6. Z-score R^2 data (theta, gamma, delta)
% 
%   Calls on:
%       - ThetaPhaseLagdH2.m
%       - Format4Bootstrap_thetaphaselagdH.m
%       - BandPowerCrossCorr.m
%       - regoutliers.m   (https://www.mathworks.com/matlabcentral/fileexchange/37212-regression-outliers)
%       - mtcsg.m         (from A.Adhikari)
%       - Format4Bootstrap_Rsq2.m
%       - ZscoreRsq_boot2.m
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
        if strcmp(subjs{si}(1),'A') %male
            load([drIn subjs{si} '_ReducedData.mat'],'IL','PL','DHIP','VHIP','Rxlist') % load in data: all trials
        else %female                  
            load([drIn subjs{si} '_ReducedData.mat'],'IL','PL','DHIP','VHIP','Rxlist','idx') % load in data: all trials
        end

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


%% 2. Theta Phase Lag analysis 
 % See: ThetaPhaseLagdH2.m
disp('Beginning Theta phase lag analysis: threshold by dHPC theta power')
for ai = 1:length(arenas)
    rt = arenas{ai};
    drIn = [root_drIn rt filesep];
    [ILDH,ILVH,ILPL,DHVH,DHPL,VHPL,dthresh,dat_pct] = ThetaPhaseLagdH2(subjs,drIn);
    
    % Save the data  (large file - contains all subjs)
    disp('Saving theta phase lag data...')
    fn = ['ThetaPhaseLags2-' rt '-AllSpeeds-dHthresh.mat'];
    save([drIn fn],'dat_pct','DHPL','DHVH','dthresh','ILDH','ILPL','ILVH','root_drIn','subjs','VHPL','-v7.3')
    disp('Saved!')
    clear dthresh rt drIn IL* DH* VH* dat_pct fn
end
clear ai


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
clear ILDH ILVH ILPL DHVH DHPL VHPL
 
% Save the data: Male and Female data
fn = 'ThetaPhaseLag2-dHthresh-BL_boot.mat';
save([root_drIn 'BL' filesep fn],'F*','M*','-v7.3')
disp('Data saved: Theta phaselag, bootstrap format')
clear fn F* M*
            
            
%% 4. Band power cross-correlations (theta, gamma, delta) 
 % See: BandPowerCrossCorr.m

% Automatically loops thru subjects and arenas, and auto-saves data in: root_drIn/rt/subjID
plotOp = 0; %Set to 1 if you want to generate plots for each scatter, w/ and w/o outliers ** (an auto-saving mechanism has NOT yet been written into BandPowerCrossCorr.m)
disp('Calculating band power cross-correlations: theta, gamma, & delta')
BandPowerCrossCorr(subjs,root_drIn,arenas,plotOp);
clear plotOp


%% 5. Format data for bootstrapping: Band power xcorr, R^2_orig, MvF
 % See: Format4Bootstrap_Rsq2.m
 
drIn = [root_drIn 'BL' filesep]; %BL arena recordings only
bandz = {'Theta' 'Gamma' 'Delta'}; %frequency bands of interest

for bi = 1:length(bandz) %loop Theta, Gamma, Delta bands
    fprintf('Bootstrap formatting R^2 %s band..\n',bandz{bi})

    [M_ILDH,M_ILVH,M_ILPL,M_DHVH,M_DHPL,M_VHPL,F_ILDH,F_ILVH,F_ILPL,F_DHVH,F_DHPL,F_VHPL,...
    F_ILDH_D,F_ILVH_D,F_ILPL_D,F_DHVH_D,F_DHPL_D,F_VHPL_D,F_ILDH_P,F_ILVH_P,F_ILPL_P,F_DHVH_P,F_DHPL_P,F_VHPL_P,...
    F_ILDH_E,F_ILVH_E,F_ILPL_E,F_DHVH_E,F_DHPL_E,F_VHPL_E,F_ILDH_M,F_ILVH_M,F_ILPL_M,F_DHVH_M,F_DHPL_M,F_VHPL_M]...
    = Format4Bootstrap_Rsq2(subjs,drIn,bandz{bi}); %#ok<*ASGLU>

    % Save R^2 data: MvF
    fn = [bandz{bi} 'Rsq-BL_boot.mat'];
    save([drIn fn],'F*','M*','-v7.3')
    fprintf('%s R^2 data saved.\n',bandz{bi})
    clear fn M_* F_*
end
clear bi drIn
disp('Format4Bootstrap_Rsq2.m is complete.')


%% 6. Zscore R^2 data (theta, gamma, delta)
 % See: ZscoreRsq_boot2.m 
 
for bi = 1:length(bandz) %loop Theta, Gamma, Delta bands
    fprintf('Z-scoring R^2 %s band..\n',bandz{bi})
    
    % Load in R^2 data
    fn = [bandz{bi} 'Rsq-BL_boot.mat']; %file name to load
    load([[root_drIn 'BL' filesep fn],'M_*','F_ILDH','F_ILVH','F_ILPL','F_DHVH','F_DHPL','F_VHPL')
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
