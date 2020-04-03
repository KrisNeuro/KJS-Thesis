%% Thesis3_RemoveBadChannels.m
% 
%   This script *should* run standalone. 
%   No functions called.
% 
% KJS init 2020-02-12

%% SETUP
subjs = {'A201' 'A202' 'A301' 'A602' 'E105' 'E106' 'E107' 'E108' 'E201'}; % Subject ID listing. A*=male  E*=female
arenas = {'BL' 'EPM'}; % recording arenas
list = {'CSC01' 'CSC02' 'CSC03' 'CSC04' 'CSC05' 'CSC06' 'CSC07' 'CSC08' 'CSC09' 'CSC10' 'CSC11' 'CSC12' 'CSC13' 'CSC14' 'CSC15' 'CSC16'}; %list of NLX CSC channel identities

% Subject-specific index of channels to remove from all recordings
% *** FOR EACH SUBJECT, USER MUST HARD-CODE THE INDICES BELOW AFTER ANALYZING OUTPUTS FROM Thesis2_FindBadChannels.m ***
%       1=REMOVE  0=KEEP
OutIdxs = cell(length(subjs),1); %preallocate holding place
for si = 1:length(subjs) %loop thru subjects
    
% START: USER HARD-CODE PORTION
    switch subjs{si}
        case 'A201'
            OutIdxs{1} = [0 0 0 0 1 0 1 1 1 1 0 0 0 0 0 0];
        case 'A202'
            OutIdxs{2} = [0 0 0 0 0 0 1 1 1 1 0 0 0 1 0 0];
        case 'A301'
            OutIdxs{3} = [0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0];
        case 'A602'
            OutIdxs{4} = [0 0 1 1 0 0 1 1 1 1 1 1 0 0 0 0];
        case 'E105'
            OutIdxs{5} = [1 0 1 0 1 1 1 1 1 1 1 1 1 0 0 1];
        case 'E106'
            OutIdxs{6} = [0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0];
        case 'E107'
            OutIdxs{7} = [0 1 0 0 0 1 1 1 1 1 1 0 0 0 0 1];
        case 'E108'
            OutIdxs{8} = [0 0 0 0 0 1 1 1 1 1 0 1 0 0 0 1];
        case 'E201'
            OutIdxs{9} = [0 1 0 0 0 0 1 1 1 1 1 0 0 1 0 1];
% END: USER HARD-CODE PORTION

    end %switch
end

% Set file paths
if license == "731138"
    root_drIn = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\RawEEG\'; % root input data directory (precleaned 16ch data)
    root_drOut = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\ReducedEEG\'; % root output data directory
else
    root_drIn = [uigetdir(pwd,'Select RawEEG data directory') filesep];
    root_drOut = [uigetdir(pwd,'Select ReducedEEG data directory') filesep];
end

%% Loop thru subjects

for si = 1:length(subjs)
    fprintf('Calculating regional signals for %s...\n',subjs{si})
    
    % Index channels to keep within each brain region
      % ** This portion depends on experiment-specific headboard pinout! **
    outidx = OutIdxs{si,1}; %logical index of channels to exclude for this subject
    ilidx =   logical([1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0]);  %channels in mPFC-IL
    ilchan = ~outidx(ilidx);
    dhipidx = logical([0 0 1 1 1 1 1 1 0 0 0 0 0 0 0 0]);  %channels in dHPC
    dhipchan = ~outidx(dhipidx);
    vhipidx = logical([0 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0]);  %channels in vHPC
    vhipchan = ~outidx(vhipidx);
    plidx =   logical([0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1]);  %channels in mPFC-PL
    plchan = ~outidx(plidx);
    
    for ai = 1:length(arenas) % Familiar arena, EPM
        rt = arenas{ai}; %'BL' or 'EPM'
        fprintf('Working on %s trials.\n',rt)
        drIn = [root_drIn rt filesep subjs{si} filesep]; %subject's input data dir (16-channel LFPs)
        drOut = [root_drOut rt filesep subjs{si} filesep]; %subject's output data dir (4 regional LFPs)
        
        % Fetch Rxlist 
        files = dir(drIn);
        [Rxlist] = {files(contains({files(:).name},rt)).name}'; % List of recording sessions - OK
        clear files
            % Remove non-experiemental trials if necessary (Reference vs. SubjGND test in BL arena) 
            if contains(Rxlist{1},'_Rex1')
                Rxlist = Rxlist(2:end);
            end
            
        % If female subject, create index of hormone state per trial
        if strcmp(subjs{si}(1),'E') && strcmp(rt,'BL')
            Didx = contains(Rxlist,'_D');
            Pidx = contains(Rxlist,'_P');
            Eidx = contains(Rxlist,'_E');
            idx = [Didx Pidx Eidx];
            if any(contains(Rxlist,'M'))
                Midx = contains(Rxlist,'_M');
                idx = [idx Midx]; %#ok<AGROW>
            end
            idx = double(idx);
            clear Didx Pidx Eidx Midx
        end

        % Preallocate output space
        IL = zeros(1200001,length(Rxlist));
        PL = zeros(1200001,length(Rxlist));
        DHIP = zeros(1200001,length(Rxlist));
        VHIP = zeros(1200001,length(Rxlist));
        theta = struct('IL',[],'DHIP',[],'VHIP',[],'PL',[]);

        %% Loop thru trials: Combine channels 
        
        disp('Creating mean regional signals...')
        for ri = 1:length(Rxlist)
            fprintf('Trial %i of %i: %s\n',ri,length(Rxlist),Rxlist{ri}(1:end-11))
            load([drIn Rxlist{ri}],'AllDat','thetadata')
            disp('.')
            
            % Combine good channels in each region, per timepoint
            il = AllDat(:,ilidx);
            il = mean(il(:,ilchan),2);
            [IL(:,ri)] = il; clear il
            
            dhip = AllDat(:,dhipidx);
            dhip = mean(dhip(:,dhipchan),2);
            [DHIP(:,ri)] = dhip; clear dhip
            
            vhip = AllDat(:,vhipidx);
            vhip = mean(vhip(:,vhipchan),2);
            [VHIP(:,ri)] = vhip; clear vhip
            
            pl = AllDat(:,plidx);
            pl = mean(pl(:,plchan),2);
            [PL(:,ri)] = pl; clear pl AllDat
            disp('.')

            %% Apply "good-channel" indices to thetadata
            
            % Preallocate output space
            th_AllDat = zeros(1200001,length(list));
            th_angles = zeros(1200001,length(list)); 
            
            % Get data out from struct
            for thi = 1:length(list) %loop thru channel substructs
                th_AllDat(:,thi) = getfield(thetadata.(list{thi}),'s'); %#ok<*GFLD> %voltage time series
                th_angles(:,thi) = getfield(thetadata.(list{thi}),'ang'); %theta angles over time (from Hilbert transform)
            end
            clear thi

            % Combine good channels in each region, per timepoint (thetadata.CSC##.s)
            th_il = th_AllDat(:,ilidx);
            th_il = mean(th_il(:,ilchan),2);
            [theta.IL.s(:,ri)] = th_il;
            
            th_dhip = th_AllDat(:,dhipidx);
            th_dhip = mean(th_dhip(:,dhipchan),2);
            [theta.DHIP.s(:,ri)] = th_dhip;
            
            th_vhip = th_AllDat(:,vhipidx);
            th_vhip = mean(th_vhip(:,vhipchan),2);
            [theta.VHIP.s(:,ri)] = th_vhip;
            
            th_pl = th_AllDat(:,plidx);
            th_pl = mean(th_pl(:,plchan),2);
            [theta.PL.s(:,ri)] = th_pl;
            clear th_AllDat
            disp('.')
            
            % Combine good channels in each region, per timepoint (thetadata.CSC##.ang)
            thang_il = th_angles(:,ilidx);
            thang_il  = mean(thang_il(:,ilchan),2);
            [theta.IL.ang(:,ri)] = thang_il;
            
            thang_dhip = th_angles(:,dhipidx);
            thang_dhip  = mean(thang_dhip (:,dhipchan),2);
            [theta.DHIP.ang(:,ri)] = thang_dhip;
            
            thang_vhip = th_angles(:,vhipidx);
            thang_vhip = mean(thang_vhip(:,vhipchan),2);
            [theta.VHIP.ang(:,ri)] = thang_vhip;
            
            thang_pl = th_angles(:,plidx);
            thang_pl  = mean(thang_pl (:,plchan),2);
            [theta.PL.ang(:,ri)] = thang_pl;
            clear th_angles thetadata th_* thang_*  
        end %trials
        clear ri
    
        %% SAVE large data set: All recordings of this type for this subject, all velocities
        fprintf('Saving large data set: %s %s...\n',subjs{si},arenas{ai})
        fn = [subjs{si} '_ReducedData.mat']; %file name (OR _ReducedData2.m)
        if strcmp(subjs{si}(1),'E')  && strcmp(rt,'BL') %female BL
            save([drOut fn],'IL','PL','DHIP','VHIP','theta','Rxlist','drIn','drOut','idx','*idx','*chan','-v7.3')
        else %male, or female EPM (no idx)
            save([drOut fn],'IL','PL','DHIP','VHIP','theta','Rxlist','drIn','drOut','*idx','*chan','-v7.3')
        end
        disp('Saved!')
       
        % Reset workspace
        clear IL PL DHIP VHIP theta fn Rxlist drIn drOut idx
    end %arenas
    clear ai rt *idx *chan 
end %subjects
clear si
disp('Thesis3_RemoveBadChannels.m is complete.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end of script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% OPTIONAL: Analyze all-velocity datasets here
% 1. Theta phase lag analysis (+dHPC mean power threshold)
% 2. BandPowerCrossCorr_AllVelocity.m (*Need to add Z-scoring portion*)
% 3. ?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%