%Format4Bootstrap_coherency
% [f,params,M_ILDH,M_ILVH,M_ILPL,M_DHVH,M_DHPL,M_VHPL,F_ILDH,F_ILVH,F_ILPL,F_DHVH,F_DHPL,F_VHPL] = Format4Bootstrap_coherency(subjs,root_drIn,M_IL,M_DH,M_VH,M_PL,F_IL,F_DH,F_VH,F_PL)
% 
%   Calls on Chronux toolbox: coherencyc
% 
%  Familiar arena (BL) data, only epochs of movement between 5-15 cm/s
%   MALE DATA:
%       M{1} = data(ntrials,ntimestamps)  Male subject 1
%       M{2} = data(27,XXXX)  Male subject 2 (example: 27 trials, Coherence data with length(f)=XXXX)
% 
%   FEMALE DATA:    
%       Same as above, but 2nd dimension of cell array indexes estrous stage:
%         {:,1}=Diestrus (D)
%         {:,2}=Proestrus (P)
%         {:,3}=Estrus (E)
%         {:,4}=Metestrus (M)  **Metestrus included for MvF comparisons, Ignored for female hormone comparisons**
% 
%   Fetches data generated by:
%       Thesis6_Format4Bootstrap_5to15 / Format4Bootstrap_LFP.m      'LFP-BL-5to15_boot.mat.mat'
% 
%   Called by:
%       Thesis6_Format4Bootstrap_5to15.m
% 
% KJS init: 2020-01-10
% KJS edit: 2020-01-14: Flexibility for coherencyc outputs of varying sizes - needs different padding amounts 
% KJS edit: 2020-02-21, 2020-02-24: Format as function to be called by Thesis6_Format4Bootstrap_5to15.m

function [f,params,M_ILDH,M_ILVH,M_ILPL,M_DHVH,M_DHPL,M_VHPL,F_ILDH,F_ILVH,F_ILPL,F_DHVH,F_DHPL,F_VHPL] = Format4Bootstrap_coherency(subjs,root_drIn,M_IL,M_DH,M_VH,M_PL,F_IL,F_DH,F_VH,F_PL)
%% Setup

% Subject ID listing: Separate the sexes. A*=male  E*=female
Msubjs = subjs(contains(subjs,'A')); % males
Fsubjs = subjs(contains(subjs,'E')); % females
% 
% % Select root input data directory (containing subject subfolders)
% % if strcmp(getenv('computername'),'MEDMJ02QURL') % KJS desktop computer
% if strcmp(getenv('computername'),'MEDMJDHMKD') % Kabbaj lab desktop computer
%     root_drIn = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\ReducedEEG\BL\';
%     drOut = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\ReducedEEG\BL\5to15\';
%     addpath(genpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\toolboxes\chronux'))
% else
%     root_drIn = uigetdir(pwd,'Select directory containing ReducedEEG, BL arena, subject subfolders.');
%         if ~strcmp(root_drIn(end),filesep)
%             root_drIn = [root_drIn filesep];
%         end
%     drOut = uigetdir(pwd,'Select directory where output data will save.');
%         if ~strcmp(drOut(end),filesep)
%             drOut = [drOut filesep];
%         end
%     if ~exist('coherencyc.m','file')
%             addpath(genpath(uigetdir(pwd,'Select file path containing Chronux toolbox'))); end
% end

% Chronux/coherencyc parameters
params.tapers = [30 59]; %[TW K]
% params.tapers = [45 89]; %[TW K]
% params.tapers = [3 5];
params.pad = 0; %padding factor for FFT. -1=no pad, 0=pad to the next highest power of 2 of (length(N)),etc
params.Fs = 2000; %sampling rate (Hz)
params.fpass=[0.5 100]; %frequency bandpass (Hz)
params.err = 0; %error calculation
% params.err = [2 0.05]; %jackknife error calculation across animals
params.trialave=0; %do not average over trials


%% Shape data: Coherence, BL arena, 5-15 cm/s velocity
%% Males

% Preallocate output space
% M_il = cell(length(Msubjs),1);
% M_dh = cell(length(Msubjs),1);
% M_vh = cell(length(Msubjs),1);
% M_pl = cell(length(Msubjs),1);
M_ILDH = cell(length(Msubjs),1);  % mPFCil-dHPC
M_ILVH = cell(length(Msubjs),1);  % mPFCil-vHPC
M_ILPL = cell(length(Msubjs),1);  % mPFCil-mPFCpl
M_DHVH = cell(length(Msubjs),1);  % dHPC-vHPC
M_DHPL = cell(length(Msubjs),1);  % dHPC-mPFCpl
M_VHPL = cell(length(Msubjs),1);  % vHPC-mPFCpl


% Use this portion if collapsing by trials is desired:
    % % Concatenate data per brain region to calculate Jackknife error over subjs
    % for si = 1:length(Msubjs)
    %     M_il{si,1} = horzcat(M_IL{si,1}{:});
    %     M_dh{si,1} = horzcat(M_DH{si,1}{:});
    %     M_vh{si,1} = horzcat(M_VH{si,1}{:});
    %     M_pl{si,1} = horzcat(M_PL{si,1}{:});
    % end
    % clear si
    % 
    % % Reshape for coherencyc. Desired: samples x 1 concatenated trial
    % if size(M_il,1)<size(M_il,2)
    %     M_il = M_il';
    %     M_dh = M_dh';
    %     M_vh = M_vh';
    %     M_pl = M_pl';
    % end
    % Call something like this: [M_ILDH{si,1},~,~,~,~,f] = coherencyc(M_il{si}',M_dh{si}',params);

%% Calculate coherencyc: Males
for si = 1:length(Msubjs) %loop thru male subjects
    tic;
    subjID = Msubjs{si}; %subject name
    fprintf('Processing coherencyc for %s...\n',subjID) 
    for ri = 1:length(M_IL{si,1}) %loop trials
        fprintf('Trial %i of %i\n',ri,length(M_IL{si,1}))
        if si==1 && ri==1
            [M_ILDH{si,1}{ri},~,~,~,~,f] = coherencyc(M_IL{si,1}{ri,1}',M_DH{si,1}{ri,1}',params); %also output frequency vector
        else
            [M_ILDH{si,1}{ri}] = coherencyc(M_IL{si,1}{ri,1}',M_DH{si,1}{ri,1}',params);
        end
            disp('.')
        [M_ILVH{si,1}{ri}] = coherencyc(M_IL{si}{ri,1}',M_VH{si}{ri,1}',params);
            disp('..')
        [M_ILPL{si,1}{ri}] = coherencyc(M_IL{si}{ri,1}',M_PL{si}{ri,1}',params);
            disp('...')
        [M_DHVH{si,1}{ri}] = coherencyc(M_DH{si}{ri,1}',M_VH{si}{ri,1}',params);
            disp('....')
        [M_DHPL{si,1}{ri}] = coherencyc(M_DH{si}{ri,1}',M_PL{si}{ri,1}',params);
            disp('.....')
        [M_VHPL{si,1}{ri}] = coherencyc(M_VH{si}{ri,1}',M_PL{si}{ri,1}',params);
    end
    toc
end
clear si subjID M_IL M_DH M_VH M_PL Msubjs

    % Save male data alone
    disp('Saving male coherencyc data...')
    fn = 'coherencyc-M-BL-5to15_boot.mat'; 
    save([root_drIn '5to15' filesep fn],'M_*','f','params','-v7.3')
    disp('Male coherencyc data is saved.')
    clear fn


%% Calculate coherencyc: Females (with 4 hormone states)

% Preallocate output space
F_ILDH = cell(length(Fsubjs),4);  % mPFCil-dHPC
F_ILVH = cell(length(Fsubjs),4);  % mPFCil-vHPC
F_ILPL = cell(length(Fsubjs),4);  % mPFCil-mPFCpl
F_DHVH = cell(length(Fsubjs),4);  % dHPC-vHPC
F_DHPL = cell(length(Fsubjs),4);  % dHPC-mPFCpl
F_VHPL = cell(length(Fsubjs),4);  % vHPC-mPFCpl

for si = 1:length(Fsubjs)
    tic;
    subjID = Fsubjs{si};
    fprintf('Processing coherencyc for %s\n',subjID)
    for hidx = 1:4 %loop hormone states
        switch hidx
            case 1; hs='Diestrus';
            case 2; hs='Proestrus';
            case 3; hs='Estrus';
            case 4; hs='Metestrus';
        end
        for ri = 1:length(F_IL{si,hidx}) %loop trials
            fprintf('%s trial %i of %i\n',hs,ri,length(F_IL{si,hidx}))
            if si==1 && ri==1
                [F_ILDH{si,hidx}{ri},~,~,~,~,f] = coherencyc(F_IL{si,hidx}{ri,1}',F_DH{si,hidx}{ri,1}',params);
            else
                [F_ILDH{si,hidx}{ri}] = coherencyc(F_IL{si,hidx}{ri,1}',F_DH{si,hidx}{ri,1}',params); 
            end
            disp('.')
            [F_ILVH{si,hidx}{ri}] = coherencyc(F_IL{si,hidx}{ri,1}',F_VH{si,hidx}{ri,1}',params);
            disp('..')
            [F_ILPL{si,hidx}{ri}] = coherencyc(F_IL{si,hidx}{ri,1}',F_PL{si,hidx}{ri,1}',params);
            disp('...')
            [F_DHVH{si,hidx}{ri}] = coherencyc(F_DH{si,hidx}{ri,1}',F_VH{si,hidx}{ri,1}',params);
            disp('....')
            [F_DHPL{si,hidx}{ri}] = coherencyc(F_DH{si,hidx}{ri,1}',F_PL{si,hidx}{ri,1}',params);
            disp('.....')
            [F_VHPL{si,hidx}{ri}] = coherencyc(F_VH{si,hidx}{ri,1}',F_PL{si,hidx}{ri,1}',params);
        end %trials
        clear hs ri
    end %hormones
    toc
    clear hidx
end 
clear si subjID F_IL F_DH F_VH F_PL

    % Save female data alone
    disp('Saving female coherencyc data...')
    fn = 'coherencyc-F-BL-5to15_boot.mat'; 
    save([root_drIn '5to15' filesep fn],'F_*','f','params','subjs','-v7.3')
    disp('Female coherencyc data is saved.')
    clear fn

end %function


%%
% MISC SCRIPT USED IN PREVIOUS VERSIONS %%%%%%%%%%%%%%

%     % Load data and time indices for 5-15 cm/s movement, all trials
%     fn = [subjID '_ReducedDataPerSpeed.mat']; % file name to load
%     load([root_drIn subjID filesep fn],'medidx','medIL','medPL','medDHIP','medVHIP','*list')
%     clear fn

%     % Index trials by hormone state
%     if exist('BLlist','var')
%         list = BLlist; clear BLlist;
%     else %Rxlist
%         list = Rxlist; clear Rxlist;
%     end
%     Didx = contains(list,'_D');
%     Pidx = contains(list,'_P');
%     Eidx = contains(list,'_E');
%     if any(contains(list,'M'))
%         Midx = contains(list,'_M');
%     else
%         Midx = false(length(list),1);
%     end
%     idx = double([Didx Pidx Eidx Midx]);
%     clear Didx Pidx Eidx Midx    
%     
%     % Loop thru trials
%     for ti = 1:size(idx,1) 
%         fprintf('Trial %i of %i\n',ti,size(medidx,2))
%         hidx = find(idx(ti,:)==1); %index for which hormone state to output   
%         tic;
%         if ti==1 %trial 1, also output 'f' (frequency vector)
%             [X,~,~,~,~,f] = coherencyc(medIL(medidx{1,ti}(:),ti),medDHIP(medidx{1,ti}(:),ti),params);
%             if length(X)>13042 && length(X)<52166
%                 [F_ILDH{si,hidx}(ti,:)] = X;
%                 clear X
%             elseif length(X)<13044
%                 clear X
%                 params.pad=1;
%                 [F_ILDH{si,hidx}(ti,:),~,~,~,~,f] = coherencyc(medIL(medidx{1,ti}(:),ti),medDHIP(medidx{1,ti}(:),ti),params);
%             else
%                 fprintf('params.pad = %i\n',params.pad)
%                 fprintf('Length(X) = %i\n',length(X))
%                 error('There is a problem with coherencyc')       
%             end %data length check
%         else %not trial 1
%             X = coherencyc(medIL(medidx{1,ti}(:),ti),medDHIP(medidx{1,ti}(:),ti),params);
%             if length(X)>13042 && length(X)<52166 %ok
%                 [F_ILDH{si,hidx}(ti,:)] = X;
%                 clear X
%             elseif length(X)<13044 %needs padding for FFT
%                 clear X
%                 params.pad=1;
%                 [F_ILDH{si,hidx}(ti,:)] = coherencyc(medIL(medidx{1,ti}(:),ti),medDHIP(medidx{1,ti}(:),ti),params);
%             else
%                 fprintf('params.pad = %i\n',params.pad)
%                 fprintf('Length(X) = %i\n',length(X))
%                 error('There is a problem with coherencyc')       
%             end %data length check
%         end %trial check
%         [F_ILVH{si,hidx}(ti,:)] = coherencyc(medIL(medidx{1,ti}(:),ti),medVHIP(medidx{1,ti}(:),ti),params);
%         [F_ILPL{si,hidx}(ti,:)] = coherencyc(medIL(medidx{1,ti}(:),ti),medPL(medidx{1,ti}(:),ti),params);
%         [F_DHVH{si,hidx}(ti,:)] = coherencyc(medDHIP(medidx{1,ti}(:),ti),medVHIP(medidx{1,ti}(:),ti),params);
%         [F_DHPL{si,hidx}(ti,:)] = coherencyc(medDHIP(medidx{1,ti}(:),ti),medPL(medidx{1,ti}(:),ti),params);
%         [F_VHPL{si,hidx}(ti,:)] = coherencyc(medVHIP(medidx{1,ti}(:),ti),medPL(medidx{1,ti}(:),ti),params);
%         toc
%     
%         % Reset for next trial
%         clear hidx 
%         params.pad=0;        
%         
%     end %trials. these loops take ~100 sec/ea
%     clear ti med* subjID hidx tii
% 
%     % Remove empty cells
%     for i = 1:4 %loop thru columns/hormone states
%         idx = find(F_ILDH{si,i}(:,1)==0); %index of empty rows to remove
%         F_ILDH{si,i}(idx,:) = [];
%         F_ILVH{si,i}(idx,:) = [];
%         F_ILPL{si,i}(idx,:) = [];
%         F_DHVH{si,i}(idx,:) = [];
%         F_DHPL{si,i}(idx,:) = [];
%         F_VHPL{si,i}(idx,:) = [];
%         clear idx
%     end
%     clear i list

%     [M_ILVH{si,1}] = coherencyc(medIL(medidx{1,ti}(:),ti),medVHIP(medidx{1,ti}(:),ti),params);
%     [M_ILPL{si,1}] = coherencyc(medIL(medidx{1,ti}(:),ti),medPL(medidx{1,ti}(:),ti),params);
%     [M_DHVH{si,1}] = coherencyc(medDHIP(medidx{1,ti}(:),ti),medVHIP(medidx{1,ti}(:),ti),params);
%     [M_DHPL{si,1}] = coherencyc(medDHIP(medidx{1,ti}(:),ti),medPL(medidx{1,ti}(:),ti),params);
%     [M_VHPL{si,1}] = coherencyc(medVHIP(medidx{1,ti}(:),ti),medPL(medidx{1,ti}(:),ti),params);

% 
%     % Load data and time indices for 5-15 cm/s movement, all trials
%     fn = [subjID '_ReducedDataPerSpeed.mat']; % file name to load
%     load([root_drIn subjID filesep fn],'medidx','medIL','medPL','medDHIP','medVHIP')
%     clear fn
    
%     % Loop thru trials
%     for ti = 1:size(medidx,2) 
%         fprintf('Trial %i of %i\n',ti,size(medidx,2))
%         tic;
%         if ti==1 %trial 1, also output 'f' (frequency vector)
%             [X,~,~,~,~,f] = coherencyc(medIL(medidx{1,ti}(:),ti),medDHIP(medidx{1,ti}(:),ti),params);
%             if length(X)>13042 && length(X)<52166 %good
%                 [M_ILDH{si,1}(ti,:)] = X;
%                 clear X
%             elseif length(X)<13044 %increase padding for FFT
%                 clear X
%                 params.pad=1;
%                 [M_ILDH{si,1}(ti,:),~,~,~,~,f] = coherencyc(medIL(medidx{1,ti}(:),ti),medDHIP(medidx{1,ti}(:),ti),params);
%             else
%                 fprintf('params.pad = %i\n',params.pad)
%                 fprintf('Length(X) = %i\n',length(X))
%                 error('There is a problem with coherencyc')       
%             end %data length check
%         else %not trial 1
%             X = coherencyc(medIL(medidx{1,ti}(:),ti),medDHIP(medidx{1,ti}(:),ti),params);
%             if length(X)>13042 && length(X)<52166 %good
%                 [M_ILDH{si,1}(ti,:)] = X;
%                 clear X
%             elseif length(X)<13044 %increase padding for FFT
%                 clear X
%                 params.pad=1;
%                 [M_ILDH{si,1}(ti,:)] = coherencyc(medIL(medidx{1,ti}(:),ti),medDHIP(medidx{1,ti}(:),ti),params);
%             else
%                 fprintf('params.pad = %i\n',params.pad)
%                 fprintf('Length(X) = %i\n',length(X))
%                 error('There is a problem with coherencyc')       
%             end %data length check
%         end %trial check
% 
%         [M_ILDH{si,1},f] = mscohere(horzcat(M_IL{si,1}{:}),horzcat(M_DH{si,1}{:}),window,noverlap,F,Fs);
%         [M_ILVH{si,1}] = coherencyc(medIL(medidx{1,ti}(:),ti),medVHIP(medidx{1,ti}(:),ti),params);
%         [M_ILPL{si,1}] = coherencyc(medIL(medidx{1,ti}(:),ti),medPL(medidx{1,ti}(:),ti),params);
%         [M_DHVH{si,1}] = coherencyc(medDHIP(medidx{1,ti}(:),ti),medVHIP(medidx{1,ti}(:),ti),params);
%         [M_DHPL{si,1}] = coherencyc(medDHIP(medidx{1,ti}(:),ti),medPL(medidx{1,ti}(:),ti),params);
%         [M_VHPL{si,1}] = coherencyc(medVHIP(medidx{1,ti}(:),ti),medPL(medidx{1,ti}(:),ti),params);
%         toc
    
        % Reset FFT padding for next trial
%         params.pad=0;        
        
%     end %trials. these loops take ~100 sec/ea
%     clear ti med*   
% end %Msubjs
% clear si subjID

% % Save Male data alone
% fn = 'Male_Coherencyc-BL-5to15_boot.mat';
% save([drOut fn],'f','M*','params')
% disp('Male data saved!')
% clear fn 

% % Save female data alone
% fn = 'Female_Coherencyc-BL-5to15_boot.mat';
% save([drOut fn],'f','F*','params')
% disp('Female data saved!')
% clear fn
%     % done on 2020-01-14
% 
% %% Save the data: Male and Female data (complete)
% fn = 'coherencyc-BL-5to15_boot.mat';
% save([drOut fn],'f','F*','M*','params')
% disp('Data saved!')
% clear fn 