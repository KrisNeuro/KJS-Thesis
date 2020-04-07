%% Thesis1_ImportPreprocess.m
% 
%   Steps:
%     1. Import & Pre-process data (pre-cleaning), per trial
%     2. Get total distance traveled (for this subject, per arena type)
%     3. Get distribution of subj's mvmt. velocities for all recordings per arena type
%     4. Get cumulative distribution of movement linear velocity for all subjects
% 
% KJS init 2020-02-11, edits 2020-02-12, 2020-02-17, 2020-04-07

%% SETUP  ***USER MUST HARD-CODE THESE VARIABLES FOR EACH NEW EXPERIMENTAL SET****
subjs = {'A201' 'A202' 'A301' 'A602' 'E105' 'E106' 'E107' 'E108' 'E201'}; % Subject ID listing. A*=male  E*=female    ***USER MUST HARD-CODE THESE VARIABLES FOR EACH NEW EXPERIMENTAL SET****
arenas = {'BL' 'EPM'}; % recording arenas

% Set data and figure I/O directories
% Inputs
disp('Select raw data root input directory (NLX format)') %to be appended later into variable 'raw_drIn'
    ra_drIn = [uigetdir(pwd, 'Select raw data root input directory (NLX format)') filesep]; 
    fprintf('ra_drIn: %s\n',ra_drIn)
disp('Select VT data root input directory, subfolders contain VT1_PrcFields_OrdCor_SmoothedNoBins') %to be appended later into variable 'raw_drIn'
    vt_drin = [uigetdir(pwd, 'Select VT data root input directory') filesep];
    fprintf('vt_drin: %s\n',vt_drin)

% Outputs
disp('Select 16-channel precleaned data output directory')
    rt_drIn = [uigetdir(pwd, 'Select 16-channel precleaned data output directory') filesep];
    fprintf('rt_drIn: %s\n',rt_drIn)
disp('Select root figure output directory') % root figure output directory. (subfolders will be auto-generated)
    fig_drOut = [uigetdir(root_drIn, 'Select root figure output directory') filesep]; 
    fprintf('fig_drOut: %s\n',fig_drOut)
%disp('Select VT data root output directory (for .mat format)') 
%    vd_drOut = [uigetdir(root_drIn, 'Select VT data root output directory (for .mat format)') filesep];
%    fprintf('vd_drOut: %s\n',vd_drOut)


%% 1. Import & Preprocess data
for si = 1:length(subjs)
    subjID = subjs{si}; %subject ID
    fprintf('Analyzing data for %s...\n\n',subjID)
    
    % Raw NLX data directory for this subject
    if strcmp(subjID(1),'A') %male
        raw_drIn = [ra_drIn 'M' filesep subjID filesep]; 
    else %female
        raw_drIn = [ra_drIn 'F' filesep subjID filesep]; 
    end

    for ai = 1:length(arenas) %BL, EPM
        rt = arenas{ai};
        
        % Set data directories for this arena
        root_drIn = [rt_drIn rt filesep]; % for 16-chan pre-cleaned AllDat
            %root_drIn = ['K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\RawEEG\' rt filesep];
        vt_drIn = [vt_drin rt '\NLX' filesep]; % contains: subj\sessID\'VT1_PrcFields_OrdCor_SmoothedNoBins.nvt'
            %vt_drIn = ['K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\VT\' rt '\NLX' filesep];
        vd_drOut = [vt_drin rt '\MAT' filesep]; % for VT-related data outputs
            %vd_drOut = ['K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\VT\' rt '\MAT\']; 
        
        % Fetch list of trials
        files = dir(raw_drIn);
        [Rxlist] = {files(contains({files(:).name},rt)).name}'; % List of recording sessions for this arena
        clear files
    
        % Exclude any non-experimental trials (Reference vs. SubjGND testing in BLlist) 
        if any(contains(Rxlist,"_Rex1")) 
            Rxlist = Rxlist(~contains(Rxlist,"_Rex1"));
        end

        % LOOP THRU RECORDINGS
        for ri = 1:length(Rxlist)
            % Check that data input/output folders exist
            drInvid = [vt_drIn subjID filesep Rxlist{ri} filesep]; %VT input
            if ~exist(drInvid, 'dir')
                mkdir(drInvid)
                copyfile([raw_drIn Rxlist{ri} filesep 'VT1.nvt'], [drInvid '\VT1.nvt']);
            end
            if ~exist([root_drIn subjID filesep],'dir') % Output directory for cleaned 16-channel data
                mkdir([root_drIn subjID])
            end

            %% Import CSC (EEG/LFP) files
            cd([raw_drIn Rxlist{ri}])
            [EEG,thetadata,AllDat,Fs]= ImportCSC2(pwd); %this way works

            %% LFP Power Spectra (full data/all velocities considered, 16ch)
            [fourierCoefs,frex,Pxx,f,powspecfig,powspecfig2] = PowSpec(AllDat,Fs);

                % Save PowSpec figures
                fd = [fig_drOut 'PowSpec_AllChannels' filesep rt filesep subjID filesep]; %directory for figure
                fighan1 = [subjID '_' Rxlist{ri} '_PowSpec-AllChan'];
                saveas(powspecfig, [fd fighan1 '.png'])
                saveas(powspecfig, [fd fighan1 '.fig'])
                close(powspecfig)

                fighan2 = [subjID '_' Rxlist{ri} '_PowSpec-AllChanWelch'];
                saveas(powspecfig2, [fd fighan2 '.png'])
                saveas(powspecfig2, [fd fighan2 '.fig'])
                close(powspecfig2)
                clear fighan* powspecf* fd

            %% Hilbert transform on thetadata: Get phase angle time series (16ch)
            [thetadata,prefAngle] = HilbKJS(thetadata);

            %% Import, adjust, upsample VT data (video tracker), & Calculate linear velocity
              % Uses file: 'VT1_PrcFields_OrdCor_SmoothedNoBins.nvt', which has been manually copied and processed
            eegtsec = EEG.t*10^-4; %convert LFP timestamps to second units
            if strcmp(rt,'BL')
                [pos,ExpKeys] = ImportVTBL(drInvid,eegtsec,Fs);
            else %EPM
                [pos,ExpKeys] = ImportVTEPM(drInvid,Rxlist{ri},subjID,eegtsec,Fs);      % *** NEEDS HELP ***** & EPMPosConKJS.m *****
            end

            %% Save single-recording dataset: Precleaned 16 channels + VT
            fprintf('Saving data: Recording %i of %i for %s...\n',ri,length(Rxlist),subjID)
            fd = [root_drIn subjID filesep]; %subject's output directory
                if ~exist(fd,'dir); mkdir(fd); end %make dir if necessary
            fn = [subjID '_' Rxlist{ri} '_AllDat.mat']; %file name
            save([fd fn],'AllDat','drInvid','EEG','eegtsec','ExpKeys','f','fourierCoefs','frex','Fs','pos','prefAngle','Pxx','rt','Rxlist','subjID','thetadata','-v7.3')
            disp('Data saved!')

            % Reset workspace for next recording
            clear AllDat drInvid EEG eegtsec ExpKeys f fourierCoefs frex Fs itpc pos prefAngle Pxx thetadata fn fd
        end %trials
        clear ri
        
        %% 2. Calculate total distance traveled for this subject in this recording type
        % See: TotalDistanceTraveled.m
        fprintf('Calculating total distance traveled for %s\n\n',subjID)
        files = strcat([root_drIn subjID filesep subjID '_'], Rxlist,'_AllDat'); %append file path in front of session titles
        [d,h,dh] = TotalDistanceTraveled(subjID,files); % %calculate distance traveled over recordings & plot
        clear files

        % Save figure
        fd = [fig_drOut 'VT\' rt '\' subjID '\Velocity\']; % Set figure output directory for this subject
            if ~exist(fd,'dir'); mkdir(fd); end  % Create dir if it doesn't exist
        saveas(dh,[fd subjID '_TotalDistanceTraveled.png'])
        saveas(dh,[fd subjID '_TotalDistanceTraveled.fig'])
        close(dh)
        clear dh fd
        
        % Save data separately: d and h
        if ~exist([vd_drOut subjID],'dir') % Make output data directory if it doesn't exist
            mkdir([vd_drOut subjID]); end
        fn = [subjID '_' rt '_TotalDistanceTraveled.mat']; %file name
        save([vd_drOut subjID filesep fn],'d','h','Rxlist','-v7.3')
        fprintf('Total distance traveled for %s: saved.\n',subjID)
        clear d h fn

        
        %% 3. Get distribution of subj's mvmt. velocities for all recordings (per arena)
        % See: VelDist.m
        fprintf('Calculating linear movement velocity distribution for %s %s...\n',subjID,rt)
        [Vrex,Vall,h1] = VelDist(subjID,rt,Rxlist,root_drIn);
        
        % Save figure 
        disp('Saving figure...')
        fd = [fig_drOut 'VT\' rt filesep subjID '\Velocity\']; %figure output directory
            if ~exist(fd,'dir'); mkdir(fd); end %create directory if needed
        saveas(h1,[fd subjID '_' rt '_VelDist.png'])
        saveas(h1,[fd subjID '_' rt '_VelDist.fig']) 
        disp('Saved.')
        close(h1); clear h1 fd

        % Save data separately: Vrex
        disp('Saving linear movement velocity distribution...')
        fn = [subjID '_' rt '_VelDist.mat']; %with 2kHz upsampled VT
        save([vd_drOut subjID filesep fn],'Vrex','Vall','subjID','Rxlist','-v7.3')
        disp('Velocity distribution data saved.')
        clear fn Vall Vrex
    
        % Reset workspace for next subject
        fprintf('%s data import & pre-processing complete!\n\n',subjID)
        clear Rxlist rt root_drIn vd_drOut vt_drIn
    end %arenas   
    clear ai subjID raw_drIn
end %subjects
clear ra_drIn si vt_drIn

%% 4. Get cumulative distribution of movement linear velocity for all subjects: BL arena only
vd_drOut = [vt_drin rt '\MAT' filesep]; 
[X,Y,H1] = VelCumDist(subjs,vd_drOut); %#ok<ASGLU>

% Save figure as .tif
disp('Saving velocity figure and cumulative distribution data...')
fn = [fig_drOut 'VT\BL\Familiar_VelocityCumDist-upsampled']; % figure output directory + file name
export_fig(fn,'-tif',H1)
close(H1)
clear H1 fn

% Save data separately: X and Y
save([vd_drOut 'Familiar_VelocityCumuDist.mat'],'X','Y','subjs','rt','-v7.3')     % done on 2020-01-21 (manually, not using VelCumDist fxn)
disp('Saved.')
clear X Y vd_drOut

disp('Thesis1_ImportPreprocess.m is complete.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%end of script
