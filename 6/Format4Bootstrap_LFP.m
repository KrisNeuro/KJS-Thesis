%% Format4Bootstrap_LFP
% [M_IL,M_PL,M_DH,M_VH,F_IL,F_PL,F_DH,F_VH] = Format4Bootstrap_LFP(subjs,root_drIn)
% 
%  Familiar arena (BL) data, only epochs of movement between 5-15 cm/s
%   MALE DATA:
%       M_*{1,1} = data(ntrials,ntimestamps)  Male subject 1
%       M_*{2,1} = data(27,XXXX)  Male subject 2 (example: 27 trials)
% 
%   FEMALE DATA:    
%       Same as above, but 2nd dimension of cell array indexes estrous stage:
%         F_*{:,1}=Diestrus (D)
%         F_*{:,2}=Proestrus (P)
%         F_*{:,3}=Estrus (E)
%         F_*{:,4}=Metestrus (M)  **Included for MvF comparisons, Ignored for female hormone comparisons**
% 
%   Fetches data generated by:
%       Thesis5_FilterByVelocity.m      'subjID_ReducedDataPerSpeed.mat'
% 
%   Called by:
%       Thesis6_Format4Bootstrap_5to15.m
% 
% KJS init: 2020-01-22
% KJS edit 2020-02-18: Formatted as function

function [M_IL,M_PL,M_DH,M_VH,F_IL,F_PL,F_DH,F_VH] = Format4Bootstrap_LFP(subjs,root_drIn)
%% Setup

% Subject ID listing: Separate the sexes. A*=male  E*=female
Msubjs = subjs(contains(subjs,'A')); % males
Fsubjs = subjs(contains(subjs,'E')); % females

%% MALES: Shape data: LFPs, BL arena, 5-15 cm/s velocity

disp('Formatting male data...')
% Preallocate output space
M_IL = cell(length(Msubjs),1);  % mPFCil
M_PL = cell(length(Msubjs),1);  % mPFCpl
M_DH = cell(length(Msubjs),1);  % dHPC
M_VH = cell(length(Msubjs),1);  % vHPC

for si = 1:length(Msubjs) %loop thru male subjects
    subjID = Msubjs{si}; %subject ID
    fprintf('Formatting LFPs for %s..\n',subjID)

    % Fetch data and time indices for 5-15 cm/s movement epochs, all trials
    fn = [subjID '_ReducedDataPerSpeed.mat']; % file name to load
    load([root_drIn subjID filesep fn],'medIL','medPL','medDHIP','medVHIP','medidx')
    clear fn

    for ri = 1:length(medidx) %#ok<*USENS> %loop thru trials
        [M_IL{si,1}{ri,1}] = medIL(medidx{1,ri},ri); %#ok<*IDISVAR>
        [M_DH{si,1}{ri,1}] = medDHIP(medidx{1,ri},ri);
        [M_VH{si,1}{ri,1}] = medVHIP(medidx{1,ri},ri);
        [M_PL{si,1}{ri,1}] = medPL(medidx{1,ri},ri);
    end
    clear med* ri
end %Msubjs
clear si subjID

%% FEMALES: Shape data: LFPs, BL arena, 5-15 cm/s velocity
% Females are indexed in 2nd dimension with 4 hormone states

disp('Formatting female data...')
% Preallocate output space
F_IL = cell(length(Fsubjs),4);  % mPFCil
F_PL = cell(length(Fsubjs),4);  % mPFCpl
F_DH = cell(length(Fsubjs),4);  % dHPC
F_VH = cell(length(Fsubjs),4);  % vHPC

for si = 1:length(Fsubjs)
    subjID = Fsubjs{si}; %subject ID
    fprintf('Formatting LFPs for %s..\n',subjID)
    
    % Fetch data and time indices for 5-15 cm/s movement epochs, all trials
    fn = [subjID '_ReducedDataPerSpeed.mat']; % file name to load
    load([root_drIn subjID filesep fn],'medIL','medPL','medDHIP','medVHIP','medidx','Rxlist')
    clear fn
    
    % Index trials by hormone state
    list = Rxlist;
    clear Rxlist
    Didx = contains(list,'_D'); %Diestrus
    Pidx = contains(list,'_P'); %Proestrus
    Eidx = contains(list,'_E'); %Estrus
    if any(contains(list,'M')) %Metestrus
        Midx = contains(list,'_M');
    else
        Midx = false(length(list),1);
    end
    idx = double([Didx Pidx Eidx Midx]);
    clear Didx Pidx Eidx Midx list

    for ti = 1:size(idx,1) %loop thru trials
        hidx = find(idx(ti,:)==1); %index for which hormone state to output
        F_IL{si,hidx}{ti,1} = medIL(medidx{1,ti},ti);
        F_DH{si,hidx}{ti,1} = medDHIP(medidx{1,ti},ti);
        F_VH{si,hidx}{ti,1} = medVHIP(medidx{1,ti},ti);
        F_PL{si,hidx}{ti,1} = medPL(medidx{1,ti},ti);
    end
    clear ti hidx idx med*

    % Remove empty cells
    for hi = 1:4 %loop thru columns/hormone states
        iidx = find(cellfun(@isempty,F_IL{si,hi})); %empty rows to remove
        F_IL{si,hi}(iidx,:) = [];
        F_PL{si,hi}(iidx,:) = [];
        F_DH{si,hi}(iidx,:) = [];
        F_VH{si,hi}(iidx,:) = [];
        clear iidx
    end
    clear hi 
end
clear si subjID

end %function


 