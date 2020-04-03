%% Thesis2_FindBadChannels.m
% 
%   BL recordings only (aka: Familiar Arena)
% 
%   Steps:
%       1. Mean power spectra per channel (16)
%       2. YiQi's PLV Analysis
%        2.1  Coherencyc analysis (Chronux toolbox)
%        2.2  Hilbert Transform/PLV
%        2.3  Calculate & plot mean PLV across channels
% 
%   Calls on:
%       - ChanScreen.m
%       - MeanPowSpecFig.m
%       - coherencyc.m (from Chronux toolbox: http://chronux.org/)
%       - barPLV.m
% 
% KJS init 2020-02-11, edit 2020-02-12

%% SETUP
subjs = {'A201' 'A202' 'A301' 'A602' 'E105' 'E106' 'E107' 'E108' 'E201'}; % Subject ID listing. A*=male  E*=female    ***USER MUST HARD-CODE THESE VARIABLES FOR EACH NEW EXPERIMENTAL SET****
Nch = 16; % number of channels in headstage

% Parameters for coherencyc.m (Chronux)
params.trialave=0; %0=do not average over trials
params.Fs = 2000; %LFP sampling rate (Hz)
% params.tapers = [30 59]; %[TW K]
params.tapers = [45 89]; %[TW K]
params.err = [2 0.05]; %2 error bars, 0.05 pvalue
params.fpass=[0.5 100]; %bandpass
params.pad = 0; %padding factor for FFT. 0=pad to the next highest power of 2 of length(N)

% Produce and autosave figures?
figopt = input('Produce and save dataviz figures? (y/n): ','s');
if strcmp(figopt,'y')
    figopt = true;
else
    figopt = false;
end

% Set data and figure directories & paths containing script
if license =="731138"
    root_drIn = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\RawEEG\'; % root input data directory (precleaned 16ch data)
    root_drOut = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\ReducedEEG\'; % root output data directory
    fig_drOut = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\figs\'; % figure/dataviz outputs
    cp_root = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\DATA-Backup\PreAnalysis\';
    % Make sure paths to code are recognized
    if ~exist('ChanScreen.m','file') || ~exist('MeanPowSpecFig.m','file')
        addpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\m\code\'); end
    if ~exist('coherencyc.m','file')
        addpath(genpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\toolboxes\chronux\spectral_analysis\')); end
    if ~exist('barPLV.m','file')
        addpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\m\code\YiQi'); end
    
else
    root_drIn = [uigetdir(pwd,'Select RawEEG data directory') filesep];
    root_drOut = [uigetdir(pwd,'Select ReducedEEG data directory') filesep];
    fig_drOut = [uigetdir(pwd, 'Select root figure output directory') filesep];
    cp_root = [uigetdir(pwd, 'Select root CP data output directory') filesep];
    % Make sure paths to code are recognized
    if ~exist('ChanScreen.m','file')|| ~exist('MeanPowSpecFig.m','file')
        addpath(uigetdir(pwd,'Select file path containing ChanScreen.m & MeanPowSpecFig.m')); end
    if ~exist('coherencyc.m','file')
        addpath(uigetdir(pwd,'Select file path containing Chronux spectral analysis  (Chronux/spectral_analysis/')); end
    if ~exist('barPLV.m','file')
        addpath(uigetdir(pwd,'Select file path containing YiQi PLV scripts')); end
end

%% Loop thru subjects
for si = 1:length(subjs) 
    disp(subjs{si})
    drIn = [root_drIn 'BL' filesep subjs{si} filesep]; %subject's data dir (16ch precleaned data, AllDat)
    CPdrOut = [cp_root subjs{si} '\CP\']; %subject's CP analysis data dir
      if ~exist(CPdrOut,'dir'); mkdir(CPdrOut); end  %make directory if necessary

    % Get list of recordings of this type (Rxlist)
    files = dir(drIn);
    [Rxlist] = {files(contains({files(:).name},'BL')).name}';
    clear files
      % Remove first recording if necessary (Reference vs. SubjGND test in BL) 
      if any(contains(Rxlist,"_Rex1")) 
         Rxlist = Rxlist(~contains(Rxlist,"_Rex1"));
      end
    files = strcat(drIn, Rxlist); % appends file path in front of Rxlist (can load files while anywhere)
    
    %% 1. Generate mean Power spectra per channel (16)
    % + OPTIONAL figures: Dataviz screen for bad channels
    if figopt
        % Figure screen for bad channels
        for i = 1:length(files)
            F = ChanScreen(files,i); 
              % Save figure (1 per recording)
              fd = [fig_drOut 'Channels2ExcludePreview\' subjs{si} filesep];
              if ~exist(fd,'dir'); mkdir(fd); end  %make output figure directory if necessary
              saveas(F,[fd Rxlist{i}(1:end-11) '.png'])
            close(F); clear F fd
        end
        clear i
            
        % Mean Power spectra per channel, collapsed by time
        [h1,PX,mPxx] = MeanPowSpecFig(files); %#ok<ASGLU>

          % Save figure h1: Mean Pxx per channel (16) 0-100 Hz
           fd = [fig_drOut 'PowSpec_AllChannels\' rt filesep subjs{si} filesep];
           if ~exist(fd,'dir'); mkdir(fd); end  %make output figure directory if necessary
           fighan = [subjs{si} '_' 'MeanPowSpec-AllChan-100Hz'];
           saveas(h1,[fd fighan '.png'])
          clear fighan
                
        % Set xlim on h1 to [0 40] Hz and re-save figures
        h1;
        for ci = 1:size(mPxx,2)
            subplot(4,4,ci)
            set(gca,'xlim',[0 40])
        end
        % (fd is the same as above)
        fighan = [subjs{si} '_' 'MeanPowSpec-AllChan-40Hz'];
        saveas(h1,[fd fighan '.png'])
        close(h1)
        clear h1 fighan fd ci
            
    else % Do not make figures, but still calculate & save mean Pxx per channel

        [~,PX,mPxx] = MeanPowSpecFig(files); %#ok<ASGLU>
        close

    end %figopt   
        
    % Save averaged dataset
    pdrOut = [root_drOut 'BL' filesep subjs{si} filesep];
    if ~exist(pdrOut,'dir'); mkdir(fd); end  %make output figure directory if necessary
    fn = [subjs{si} '_MeanPxxPerChan.mat'];
    save([pdrOut fn],'PX','mPxx','files','-v7.3')
    disp('Mean Pxx per channel data is saved!')
    clear fn pdrOut PX mPxx 
    
    %% 2. YiQi's PLV Analysis
    % Uses phase-locking value (PLV) from 0.5-100 Hz to determine outlier channels per brain region.   
    for ri = 1:length(files) %loop thru trials
        sessID = Rxlist{ri}(1:end-11);
        fprintf('Processing file %i of %i: %s\n',ri,length(files),Rxlist{ri})
        load(files{ri},'AllDat');
            
      %% 2.1 Coherence analysis
      
        % Preallocate space
        coherence = cell(Nch,Nch);
        phi = coherence; 
        S12 = coherence; 
        S1 = cell(Nch,1); 
        f = cell(1,1); 
        confC = coherence; 
        phistd = coherence; 
        CohErr = coherence;
            
        for iS = 1:(Nch-1) %loop thru channels ("S1")
            iS2 = iS+1; %"S2" compare with iS
            % On first comparison, get frequency vector 'f'
            tic;
            fprintf('Calculating coherence for Ch. %i vs %i \n', iS, iS2);
            [coherence{iS,iS2},phi{iS,iS2},S12{iS,iS2},S1{iS},...
                ~,f,confC{iS,iS2},phistd{iS,iS2},...
                CohErr{iS,iS2}]=coherencyc(AllDat(:,iS),AllDat(:,iS2),params);  
            toc
            for iS2 = iS+2:Nch % loop thru channels (S2)
                tic;
                fprintf('Calculating coherence for Ch. %i vs %i \n', iS, iS2);
                if iS==1 && iS2 == 16 % get autospectra for channel 16
                    [coherence{iS,iS2},phi{iS,iS2},S12{iS,iS2},~,S1{iS2},~,...
                    confC{iS,iS2},phistd{iS,iS2},CohErr{iS,iS2}] = ...
                    coherencyc(AllDat(:,iS),AllDat(:,iS2),params);  
                else
                    [coherence{iS,iS2},phi{iS,iS2},S12{iS,iS2},~,~,~,...
                    confC{iS,iS2},phistd{iS,iS2},CohErr{iS,iS2}] = ...
                    coherencyc(AllDat(:,iS),AllDat(:,iS2),params);  
                end
                toc % these loops take 1-2 mins each (on machine MEDMJDHMKD)
            end
        end %channels
        clear iS iS2

      %% 2.2 Hilbert Transform/PLV
        AllDat = AllDat + hilbert(AllDat);
        Dat_angle = angle(AllDat);
        clear AllDat
        All = 1:Nch;
        PLV = zeros(size(All,2));
        for j = 1:length(All)
            for k = 1:length(All)
                ang = Dat_angle(:,j)-Dat_angle(:,k);
                PLV(j,k) = norm(sum(exp(1i*ang))/length(ang));
            end
        end
        clear j k Dat_angle All ang
            
        % Save coherence + PLV data 
        fname = [sessID '_coherencyc.mat']; %file name
        fprintf('Saving coherence data: %s\n',sessID)
        save([CPdrOut fname],'coherence','phi','S1','S12','confC','phistd','CohErr','f','PLV','-v7.3')
        disp('CP data saved!')
        fprintf('CP data saved: file %i of %i: %s\n',ri,length(files),sessID)
        clear coherence phi S12 confC phistd CohErr PLV f S1 sessID
    end %trials
    clear ri files
       
  %% 2.3 Calculate and plot mean PLV across channels
  
    files = dir(CPdrOut); % List of *_coherencyc.mat files to process (files generated above)
    files= strcat(CPdrOut,{files(contains({files(:).name},'_coherencyc.mat')).name}'); %PLV files, with file path

    % Compile PLV for all recordings
    disp('Calculating PLV...')
    plv = zeros(Nch,Nch,length(files));
    for ri = 1:length(files)
        load(files{ri},'PLV')
        plv(:,:,ri) = PLV;
        clear PLV
    end
    N = size(plv);
    PLVmean = permute(mean(permute(plv,[1,3,2]),2),[1,3,2]);
    plv(:,:,N(3)+1) = PLVmean;
    sessID = '0000-00-00_BL';
    save([CPdrOut subjs{si} '_' sessID '_PLV.mat'],'plv','sessID','files','-v7.3');
    disp('PLV mean dataset is saved!')

    % Plot: barPLV
    F = figure('Name','Phase locking value','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
    barPLV({plv(:,:,N(3)+1)},subjs{si});

        % Save figure
        if ~exist([CPdrOut 'Graph'],'dir')
            mkdir([CPdrOut 'Graph'])
        end
        saveas(F,[CPdrOut 'Graph' filesep subjs{si} '_BL_PLV.jpg']);
        saveas(F,[CPdrOut 'Graph' filesep subjs{si} '_BL_PLV.fig']);
        close(F); 
        
    % Reset workspace
    clear F CPdrOut drIn files Rxlist plv N
    
end %subjects
clear si
disp('Thesis2_FindBadChannels.m is complete.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end of script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% User instructions:

%   For each subject, visually inspect final figure output from the above
% code block. Compare it to the headboard pinout, which designates which
% channels will be assigned to which CSC identities. 
% This information can be combined with visual inspection of the dataviz
% figures output by 'ChanScreen.m' to determine which channels (if any)
% should be removed from this subject's dataset.
% 
%   Then, proceed to 'Thesis3_RemoveBadChannels.m', and hard-code variable
% 'outidx' for this subject. 1=REMOVE  0=KEEP

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optional scripts that could be incorporated here:
%   - DataViz_IndividualChannelPower.m