%% Thesis5_FilterByVelocity.m
% 
%   Filter BL arena LFP data based on linear velocity ranges:
%       - 0-5 cm/s ("slow")
%       - 5-15 cm/s ("medium")
%       - 15+ cm/s ("fast")
% 
%   Uses data:
%       - IL,PL,DHIP,VHIP, Rxlist (AllDat, reduced channels, all BL recordings. Output by Thesis3_RemoveBadChannels.m)
%       - Vrex (Output by VelDist.m, called by Thesis1_*.m)
% 
%   Steps:
%       1. Fetch input data: Vrex, IL, PL, DHIP, VHIP (all BL recordings)
%       2. Find time indices of velocity ranges
%       3. Plot & save subject's BL velocity distribution
%       4. Align LFP data to time indices (per trial)
%       5. Save velocity-filtered data (per trial)
%       6. Save velocity-filtered data (all BL arena trials, per subj): 'subjID_ReducedDataPerSpeed.mat'
%       7. Calculate time spent in each velocity range
% 
%   Calls on:
%       - GetDataDuration.m
% 
% KJS init 2020-02-12

%% SETUP
subjs = {'A201' 'A202' 'A301' 'A602' 'E105' 'E106' 'E107' 'E108' 'E201'}; % Subject ID listing. A*=male  E*=female    ***USER MUST HARD-CODE THESE VARIABLES FOR EACH NEW EXPERIMENTAL SET****

% Add file directories & script paths
if license == "731138" 
    root_drIn = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\'; %input data directory. Generates: raw_drIn, drIn
    figdrOut = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\figs\VT\BL\'; %figure output directory head
    if ~exist('GetDataDuration.m','file'); addpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\m\code'); end
else
    root_drIn = [uigetdir(pwd,'Select root input directory holding data: Reduced EEG, BL arena') filesep];
    figdrOut = [uigetdir(pwd,'Select directory for figure output storage') filesep];
    if ~exist('GetDataDuration.m','file'); addpath(uigetdir(pwd,'Add path containing GetDataDuration.m')); end
end   

%% Loop thru subjects
for si = 1:length(subjs) %loop thru subjects
    raw_drIn = [root_drIn 'RawEEG\BL' filesep subjs{si} filesep]; %raw LFP input data directory
    drIn = [root_drIn 'ReducedEEG\BL\' subjs{si} filesep]; %LFP input data directory for this subject (reduced channels)
    
    % Create velocity range output folders if they don't exist
    dirslow = [drIn '0to5'];
    if ~exist(dirslow,'dir')
        mkdir(dirslow);
        fprintf('0to5 output directory made for %s\n',subjs{si})
    end
    
    dirmed = [drIn '5to15'];
    if ~exist(dirmed,'dir')
        mkdir(dirmed);
        fprintf('5to15 output directory made for %s\n',subjs{si})
    end
    
    dirfast = [drIn '15plus'];
    if ~exist(dirfast,'dir')
        mkdir(dirfast);
        fprintf('15plus output directory made for %s\n',subjs{si})
    end
    
    %% 1. Fetch input data
    
    % Fetch BL LFP data
    fprintf('Loading all BL data for %s...\n',subjs{si})
    load([drIn subjs{si} '_ReducedData.mat'],'DHIP','IL','PL','VHIP','Rxlist') %load all BL LFP data for this subject
    
    % Fetch LinearVelocity for BL recordings (Vrex)
    fprintf('Loading LinearVelocity for %s BL...\n',subjs{si})
    fn = [subjs{si} '_BL_VelDist.mat']; %file name containing Vrex
    load([root_drIn 'VT\BL\MAT\' subjs{si} filesep fn],'Vrex') %(1,:)=time  (2,:)=LinearVelocity
    clear fn
    
    
    %% 2. Find time indices of velocity ranges
    
   % Preallocate space
    slowidx = cell(1,length(Rxlist));
    slowtime = slowidx;
    medidx = cell(1,length(Rxlist));
    medtime = medidx;
    fastidx = cell(1,length(Rxlist));
    fasttime = fastidx;
    vidx = cell(1,length(Rxlist));
    change = vidx;
    
    for ri = 1:length(Rxlist) %loop thru recordings
        %Time indices in VT where velocity is within each range
        slowidx{1,ri} = find(Vrex{1,ri}(2,:) <= 5); %0-5 cm/s
        slowtime{1,ri} = Vrex{1,ri}(1,slowidx{1,ri}); %video times
        
        medidx{1,ri} = find(Vrex{1,ri}(2,:) > 5 & Vrex{ri}(2,:)<= 15); %5-15 cm/s
        medtime{1,ri} = Vrex{1,ri}(1,medidx{1,ri});
        
        fastidx{1,ri} = find(Vrex{1,ri}(2,:) > 15); %15+ cm/s
        fasttime{1,ri} = Vrex{1,ri}(1,fastidx{1,ri});
        
        % Find times when speed range changes
        vidx{1,ri}(slowidx{1,ri}) = 1;
        vidx{1,ri}(medidx{1,ri}) = 2;
        vidx{1,ri}(fastidx{1,ri}) = 3;
        change{1,ri} = find(abs(diff(vidx{1,ri})~=0)); %find potential transition points
    end
    clear ri    
    
    %% 3. Plot subject's BL velocity distribution
    figure(si)
    set(gcf,'Position',[112 136 1126 662])
    subplot(231)
        histogram(Vrex{1,1}(2,slowidx{1}))
        hold on
        for fi = 2:length(Rxlist)
            histogram(Vrex{1,fi}(2,slowidx{fi}))
        end
        title('0-5 cm/s')
        axis square
        box off
        xlabel('cm/s')
        ylabel('counts')
        xlim([-0.5 5.5])
    subplot(232)
        histogram(Vrex{1,1}(2,medidx{1}))
        hold on
        for fi = 2:length(Rxlist)
            histogram(Vrex{1,fi}(2,medidx{fi}))
        end
        title('5-15 cm/s')
        axis square
        box off
        xlabel('cm/s')
        ylabel('counts')
        xlim([4.5 15.5])
    subplot(233)
        histogram(Vrex{1,1}(2,fastidx{1}))
        hold on
        for fi = 2:length(Rxlist)
            histogram(Vrex{1,fi}(2,fastidx{fi}))
        end
        title('15+ cm/s')
        axis square
        box off
        xlabel('cm/s')
        ylabel('counts')
        xlim([14.5 21.5])
    subplot(212)
        h1 = histogram(Vrex{1,1}(2,:));
        h1.Normalization = 'probability';
        hold on
        for fi = 2:length(Rxlist)
            h(fi) = histogram(Vrex{1,fi}(2,:)); %#ok<SAGROW>
            h(fi).Normalization = 'probability'; %#ok<SAGROW>
        end
        xlabel('Velocity (cm/s)')
        ylabel('Probability')
        title([subjs{si} ' BL velocity distribution'])
        box off
        vline(5,'r:')
        vline(15,'r:')
      
            % Save figure: Velocity distribution (BL arena)
            fd = [figdrOut subjs{si} filesep 'Velocity' filesep]; %figure output directory
            if ~exist(fd,'dir'); mkdir(fd); end %make directory if needed
    %         saveas(gcf,[fd subjs{si} '_BLVelocityParsed.fig'])
            saveas(gcf,[fd subjs{si} '_BLVelocityParsed.tif'])
            fprintf('Velocity distribution figure saved for %s\n',subjs{si})
            close(gcf)
            clear h h1 fd fi
    
    %% 4. Align LFP data to time indices
    
    % Preallocate output space
        slowIL = zeros(size(IL));
        slowPL = slowIL;
        slowDHIP = slowIL;
        slowVHIP = slowIL;
        medIL = slowIL;
        medPL = slowIL;
        medDHIP = slowIL;
        medVHIP = slowIL;
        fastIL = slowIL;
        fastPL = slowIL;
        fastDHIP = slowIL;
        fastVHIP = slowIL;
    
        fprintf('Aligning data:\n')
    for ri = 1:length(Rxlist) %loop thru recordings
        fprintf('%i of %i\n',ri,length(Rxlist))
        load([raw_drIn Rxlist{ri}],'eegtsec') %load LFP time vector (in second units) for this recording
        eegtsec2 = eegtsec - eegtsec(1); %start eegtsec at 0, like the velocity time vector
        ctime = Vrex{1,ri}(1,change{1,ri}); %times when velocity range changes (sec after 0) for this recording
        [~, idx] = min(abs(eegtsec2-ctime)); %indices in eegtsec (or eegtsec2) where velocity range changes
        
        % Align vidx value (1=slow, 2=med, 3=fast) with eegtsec(idx) 
        ct = 1; %start place counter      
        for ii = 1:length(idx) %loop thru transition points
            vi = vidx{1,ri}(change{1,ri}(ii)-1); %get velocity range index (1,2,3) for one data point prior to change
            switch vi
                case 1
                    slowIL(ct:idx(ii),ri) = IL(ct:idx(ii),ri);
                    slowPL(ct:idx(ii),ri) = PL(ct:idx(ii),ri);
                    slowDHIP(ct:idx(ii),ri) = DHIP(ct:idx(ii),ri);
                    slowVHIP(ct:idx(ii),ri) = VHIP(ct:idx(ii),ri);
                case 2
                    medIL(ct:idx(ii),ri) = IL(ct:idx(ii),ri);
                    medPL(ct:idx(ii),ri) = PL(ct:idx(ii),ri);
                    medDHIP(ct:idx(ii),ri) = DHIP(ct:idx(ii),ri);
                    medVHIP(ct:idx(ii),ri) = VHIP(ct:idx(ii),ri);
                case 3
                    fastIL(ct:idx(ii),ri) = IL(ct:idx(ii),ri);
                    fastPL(ct:idx(ii),ri) = PL(ct:idx(ii),ri);
                    fastDHIP(ct:idx(ii),ri) = DHIP(ct:idx(ii),ri);
                    fastVHIP(ct:idx(ii),ri) = VHIP(ct:idx(ii),ri);
            end
        ct = idx(ii)+1;
        end %loop thru transition points
        clear ct vi ii idx
        
        %% 5. Save velocity-filtered data for this trial
        
        % 0-5 cm/s
        il = slowIL(:,ri); %#ok<*NASGU>
        pl = slowPL(:,ri);
        dhip = slowDHIP(:,ri);
        vhip = slowVHIP(:,ri);
        save([dirslow filesep Rxlist{ri}],'Rxlist','il','pl','dhip','vhip','eegtsec','eegtsec2','drIn','ctime')
        clear il pl dhip vhip
        
        %5-15 cm/s
        il = medIL(:,ri);
        pl = medPL(:,ri);
        dhip = medDHIP(:,ri);
        vhip = medVHIP(:,ri);
        save([dirmed filesep Rxlist{ri}],'Rxlist','il','pl','dhip','vhip','eegtsec','eegtsec2','drIn','ctime')
        clear il pl dhip vhip
        
        %15+ cm/s
        il = fastIL(:,ri);
        pl = fastPL(:,ri);
        dhip = fastDHIP(:,ri);
        vhip = fastVHIP(:,ri);
        save([dirfast filesep Rxlist{ri}],'Rxlist','il','pl','dhip','vhip','eegtsec','eegtsec2','drIn','ctime')
        clear il pl dhip vhip
        clear eegtse* ctime
        
    end %loop thru recordings
    clear ri IL PL DHIP VHIP
    
     %% 6. Save velocity-filtered data: All BL arena recordings for this subject
    fprintf('Saving data for %s...\n',subjs{si})
    fn = [subjs{si} '_ReducedDataPerSpeed.mat']; %file name to save
    save([drIn fn],'Rxlist','change','fastDHIP','fastidx','fastIL','fastPL','fasttime','fastVHIP',...
        'medDHIP','medidx','medIL','medPL','medtime','medVHIP',...
        'slowDHIP','slowidx','slowIL','slowPL','slowtime','slowVHIP','vidx','drIn','-v7.3')
    fprintf('Velocity-filtered data saved for %s!\n',subjs{si})
    clear fn

    % Reset workspace for next subject    
    clear Rxlist Vrex vidx change fast* med* slow* dir* drIn raw_drIn
end %loop thru subjects 
clear si
disp('Velocity filtering complete!')

%% 7. Calculate time spent in each velocity range
 % SEE: GetDataDuration.m
 
disp('Calculating duration spent in velocity ranges...')
[slowTime,medTime,fastTime,pctslowtime,pctmedtime,pctfasttime] = GetDataDuration(subjs,root_drIn);

    % Save data
    disp('Saving pct time data...')
    drOut = [root_drIn 'VT\BL\MAT\']; %output directory
    fn = 'Familiar_VelocityRangeDurations.mat'; %file name to save
    save([drOut fn],'subjs','slowTime','medTime','fastTime','pctslowtime','pctmedtime','pctfasttime','-v7.3')
    disp('Saved!')
    clear fn drOut *Time pct*

disp('Thesis5_FilterByVelocity.m is complete.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end of script