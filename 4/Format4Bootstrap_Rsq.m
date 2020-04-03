function [] = Format4Bootstrap_Rsq(subjs,root_drIn)
%% Format4Bootstrap_Rsq
% 
%  BL data only: All velocities considered
%   MALE DATA:
%       M{1,1} = data(ntrials,ntimestamps)  Male subject 1
%       M{2,1} = data(27,XXXX)  Male subject 2 (example: 27 trials, R-squared data with length(f)=XXXX)
% 
%   FEMALE DATA:    
%       Same as above, but 2nd dimension of cell array indexes estrous stage:
%         F{:,1}=Diestrus (D)
%         F{:,2}=Proestrus (P)
%         F{:,3}=Estrus (E)
%         F{:,4}=Metestrus (M)  **Included for MvF comparisons, Ignored for female hormone comparisons**
% 
% KJS init: 2020-01-17
% KJS edit 2020-01-31: Editing for Rsq calculated from all velocities.
% KJS edit 2020-02014: Edit to function format to be used by: Thesis4_AnalyzeAllVelDat.m

%% Setup
% Subject ID listing A*=male  E*=female
Msubjs = subjs(contains(subjs,'A')); %male subject IDs
Fsubjs = subjs(contains(subjs,'E')); %female subject IDs
drIn = [root_drIn 'BL' filesep]; %BL arena recordings only

%% Theta

% Preallocate output space
% Males    
    M_ILDH = cell(length(Msubjs),1);  % mPFCil-dHPC
    M_ILVH = cell(length(Msubjs),1);  % mPFCil-vHPC
    M_ILPL = cell(length(Msubjs),1);  % mPFCil-mPFCpl
    M_DHVH = cell(length(Msubjs),1);  % dHPC-vHPC
    M_DHPL = cell(length(Msubjs),1);  % dHPC-mPFCpl
    M_VHPL = cell(length(Msubjs),1);  % vHPC-mPFCpl
% Females
    F_ILDH = cell(length(Fsubjs),4);  % mPFCil-dHPC
    F_ILVH = cell(length(Fsubjs),4);  % mPFCil-vHPC
    F_ILPL = cell(length(Fsubjs),4);  % mPFCil-mPFCpl
    F_DHVH = cell(length(Fsubjs),4);  % dHPC-vHPC
    F_DHPL = cell(length(Fsubjs),4);  % dHPC-mPFCpl
    F_VHPL = cell(length(Fsubjs),4);  % vHPC-mPFCpl

%% Re-shape data: Theta R^2, BL arena, all velocities
% Males
for si = 1:length(Msubjs) %loop thru male subjects
    subjID = Msubjs{si}; %subject name

    % Load R^2 data - all trials, including outliers
    fn = [subjID '_BL_BandPowerCrossCorr.mat'];
    load([drIn subjID filesep fn],'Rsquare_orig') 
    clear fn
    
    [M_ILDH{si,1}(:,1)] = Rsquare_orig.Theta.il_dhip;
    [M_ILVH{si,1}(:,1)] = Rsquare_orig.Theta.il_vhip;
    [M_ILPL{si,1}(:,1)] = Rsquare_orig.Theta.il_pl;
    [M_DHVH{si,1}(:,1)] = Rsquare_orig.Theta.dhip_vhip;
    [M_DHPL{si,1}(:,1)] = Rsquare_orig.Theta.pl_dhip;
    [M_VHPL{si,1}(:,1)] = Rsquare_orig.Theta.pl_vhip;
    clear Rsq* subjID
end %Msubjs
clear si 

% Females (with 4 hormone states)
for si = 1:length(Fsubjs)
    subjID = Fsubjs{si};
    
    % Load index for hormone states
    load([drIn subjID filesep subjID '_ReducedData.mat'],'idx')
    
%     % Index hormone states
%     Didx = contains(BLlist,'_D'); %col 1
%     Pidx = contains(BLlist,'_P'); %col 2
%     Eidx = contains(BLlist,'_E'); %col 3
%     if any(contains(BLlist,'M'))
%         Midx = contains(BLlist,'_M'); %col 4
%     else
%         Midx = false(length(BLlist),1);
%     end
%     idx = double([Didx Pidx Eidx Midx]);
%     clear Didx Pidx Eidx Midx BLlist
    
    % Load Rsq data - all trials, including outliers
    fn = [subjID '_BL_BandPowerCrossCorr.mat']; 
    load([drIn subjID filesep fn],'Rsquare_orig')
    clear fn
    
    % Diestrus
    [F_ILDH{si,1}(:,1)] = Rsquare_orig.Theta.il_dhip(find(idx(:,1)==1)); %#ok<*IDISVAR,*NODEF>
    [F_ILVH{si,1}(:,1)] = Rsquare_orig.Theta.il_vhip(find(idx(:,1)==1));
    [F_ILPL{si,1}(:,1)] = Rsquare_orig.Theta.il_pl(find(idx(:,1)==1));
    [F_DHVH{si,1}(:,1)] = Rsquare_orig.Theta.dhip_vhip(find(idx(:,1)==1));
    [F_DHPL{si,1}(:,1)] = Rsquare_orig.Theta.pl_dhip(find(idx(:,1)==1));
    [F_VHPL{si,1}(:,1)] = Rsquare_orig.Theta.pl_vhip(find(idx(:,1)==1));
     % Proestrus
    [F_ILDH{si,2}(:,1)] = Rsquare_orig.Theta.il_dhip(find(idx(:,2)==1));
    [F_ILVH{si,2}(:,1)] = Rsquare_orig.Theta.il_vhip(find(idx(:,2)==1));
    [F_ILPL{si,2}(:,1)] = Rsquare_orig.Theta.il_pl(find(idx(:,2)==1));
    [F_DHVH{si,2}(:,1)] = Rsquare_orig.Theta.dhip_vhip(find(idx(:,2)==1));
    [F_DHPL{si,2}(:,1)] = Rsquare_orig.Theta.pl_dhip(find(idx(:,2)==1));
    [F_VHPL{si,2}(:,1)] = Rsquare_orig.Theta.pl_vhip(idx(:,2)==1);
     % Estrus
    [F_ILDH{si,3}(:,1)] = Rsquare_orig.Theta.il_dhip(find(idx(:,3)==1));
    [F_ILVH{si,3}(:,1)] = Rsquare_orig.Theta.il_vhip(find(idx(:,3)==1));
    [F_ILPL{si,3}(:,1)] = Rsquare_orig.Theta.il_pl(find(idx(:,3)==1));
    [F_DHVH{si,3}(:,1)] = Rsquare_orig.Theta.dhip_vhip(find(idx(:,3)==1));
    [F_DHPL{si,3}(:,1)] = Rsquare_orig.Theta.pl_dhip(find(idx(:,3)==1));
    [F_VHPL{si,3}(:,1)] = Rsquare_orig.Theta.pl_vhip(find(idx(:,3)==1));
     % Metestrus
    [F_ILDH{si,4}(:,1)] = Rsquare_orig.Theta.il_dhip(find(idx(:,4)==1));
    [F_ILVH{si,4}(:,1)] = Rsquare_orig.Theta.il_vhip(find(idx(:,4)==1));
    [F_ILPL{si,4}(:,1)] = Rsquare_orig.Theta.il_pl(find(idx(:,4)==1));
    [F_DHVH{si,4}(:,1)] = Rsquare_orig.Theta.dhip_vhip(find(idx(:,4)==1));
    [F_DHPL{si,4}(:,1)] = Rsquare_orig.Theta.pl_dhip(find(idx(:,4)==1));
    [F_VHPL{si,4}(:,1)] = Rsquare_orig.Theta.pl_vhip(find(idx(:,4)==1));
    clear Rsq* idx
end %si
clear si subjID

%% Save Theta R^2 data: Males and Females
fn = 'ThetaRsq-BL_boot.mat';
save([drIn fn],'F*','M*')
% save(['K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\Bootstrap\BL\' fn],'F*','M*')
disp('Theta Rsquared data saved!')
clear fn M_* F_*

%% Gamma R^2

% Preallocate output space
% Males
    M_ILDH = cell(length(Msubjs),1);  % mPFCil-dHPC
    M_ILVH = cell(length(Msubjs),1);  % mPFCil-vHPC
    M_ILPL = cell(length(Msubjs),1);  % mPFCil-mPFCpl
    M_DHVH = cell(length(Msubjs),1);  % dHPC-vHPC
    M_DHPL = cell(length(Msubjs),1);  % dHPC-mPFCpl
    M_VHPL = cell(length(Msubjs),1);  % vHPC-mPFCpl
% Females
    F_ILDH = cell(length(Fsubjs),4);  % mPFCil-dHPC
    F_ILVH = cell(length(Fsubjs),4);  % mPFCil-vHPC
    F_ILPL = cell(length(Fsubjs),4);  % mPFCil-mPFCpl
    F_DHVH = cell(length(Fsubjs),4);  % dHPC-vHPC
    F_DHPL = cell(length(Fsubjs),4);  % dHPC-mPFCpl
    F_VHPL = cell(length(Fsubjs),4);  % vHPC-mPFCpl
    
%% Re-shape data: Gamma R^2, BL arena, all velocities

% Males
for si = 1:length(Msubjs) %loop thru male subjects
    subjID = Msubjs{si}; %subject name

    % Load R^2 data - all trials, including outliers
    fn = [subjID '_BandPowerCrossCorr.mat']; 
    load([drIn subjID filesep fn],'Rsquare_orig')
    clear fn
    
    [M_ILDH{si,1}(:,1)] = Rsquare_orig.Gamma.il_dhip;
    [M_ILVH{si,1}(:,1)] = Rsquare_orig.Gamma.il_vhip;
    [M_ILPL{si,1}(:,1)] = Rsquare_orig.Gamma.il_pl;
    [M_DHVH{si,1}(:,1)] = Rsquare_orig.Gamma.dhip_vhip;
    [M_DHPL{si,1}(:,1)] = Rsquare_orig.Gamma.pl_dhip;
    [M_VHPL{si,1}(:,1)] = Rsquare_orig.Gamma.pl_vhip;
    clear Rsq* subjID
end %Msubjs
clear si

% Females (with 4 hormone states)
for si = 1:length(Fsubjs)
    subjID = Fsubjs{si};
    
    % Load index for hormone states
    load([drIn subjID filesep subjID '_ReducedData.mat'],'idx')
%     % Index hormone states
%     Didx = contains(BLlist,'_D'); %col 1
%     Pidx = contains(BLlist,'_P'); %col 2
%     Eidx = contains(BLlist,'_E'); %col 3
%     if any(contains(BLlist,'M'))
%         Midx = contains(BLlist,'_M'); %col 4
%     else
%         Midx = false(length(BLlist),1);
%     end
%     idx = double([Didx Pidx Eidx Midx]);
%     clear Didx Pidx Eidx Midx BLlist
    
    % Load R^2 data - all trials, including outliers
    fn = [subjID '_BandPowerCrossCorr.mat']; 
    load([drIn subjID filesep fn],'Rsquare_orig')
    clear fn

     % Diestrus
    [F_ILDH{si,1}(:,1)] = Rsquare_orig.Gamma.il_dhip(find(idx(:,1)==1));
    [F_ILVH{si,1}(:,1)] = Rsquare_orig.Gamma.il_vhip(find(idx(:,1)==1));
    [F_ILPL{si,1}(:,1)] = Rsquare_orig.Gamma.il_pl(find(idx(:,1)==1));
    [F_DHVH{si,1}(:,1)] = Rsquare_orig.Gamma.dhip_vhip(find(idx(:,1)==1));
    [F_DHPL{si,1}(:,1)] = Rsquare_orig.Gamma.pl_dhip(find(idx(:,1)==1));
    [F_VHPL{si,1}(:,1)] = Rsquare_orig.Gamma.pl_vhip(find(idx(:,1)==1));
     % Proestrus
    [F_ILDH{si,2}(:,1)] = Rsquare_orig.Gamma.il_dhip(find(idx(:,2)==1));
    [F_ILVH{si,2}(:,1)] = Rsquare_orig.Gamma.il_vhip(find(idx(:,2)==1));
    [F_ILPL{si,2}(:,1)] = Rsquare_orig.Gamma.il_pl(find(idx(:,2)==1));
    [F_DHVH{si,2}(:,1)] = Rsquare_orig.Gamma.dhip_vhip(find(idx(:,2)==1));
    [F_DHPL{si,2}(:,1)] = Rsquare_orig.Gamma.pl_dhip(find(idx(:,2)==1));
    [F_VHPL{si,2}(:,1)] = Rsquare_orig.Gamma.pl_vhip(find(idx(:,2)==1));
     % Estrus
    [F_ILDH{si,3}(:,1)] = Rsquare_orig.Gamma.il_dhip(find(idx(:,3)==1));
    [F_ILVH{si,3}(:,1)] = Rsquare_orig.Gamma.il_vhip(find(idx(:,3)==1));
    [F_ILPL{si,3}(:,1)] = Rsquare_orig.Gamma.il_pl(find(idx(:,3)==1));
    [F_DHVH{si,3}(:,1)] = Rsquare_orig.Gamma.dhip_vhip(find(idx(:,3)==1));
    [F_DHPL{si,3}(:,1)] = Rsquare_orig.Gamma.pl_dhip(find(idx(:,3)==1));
    [F_VHPL{si,3}(:,1)] = Rsquare_orig.Gamma.pl_vhip(find(idx(:,3)==1));
    % Metestrus
    [F_ILDH{si,4}(:,1)] = Rsquare_orig.Gamma.il_dhip(find(idx(:,4)==1));
    [F_ILVH{si,4}(:,1)] = Rsquare_orig.Gamma.il_vhip(find(idx(:,4)==1));
    [F_ILPL{si,4}(:,1)] = Rsquare_orig.Gamma.il_pl(find(idx(:,4)==1));
    [F_DHVH{si,4}(:,1)] = Rsquare_orig.Gamma.dhip_vhip(find(idx(:,4)==1));
    [F_DHPL{si,4}(:,1)] = Rsquare_orig.Gamma.pl_dhip(find(idx(:,4)==1));
    [F_VHPL{si,4}(:,1)] = Rsquare_orig.Gamma.pl_vhip(find(idx(:,4)==1));  
    clear Rsq* idx subjID
end %si
clear si 

%% Save Gamma R^2 data: Male and Female data
fn = 'GammaRsq-BL_boot.mat';
save([drIn fn],'F*','M*')
% save(['K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\Bootstrap\BL\' fn],'F*','M*')
disp('Gamma Rsquared data saved!')
clear fn M_* F_*


%% Delta R^2

% Preallocate output space
% Males
    M_ILDH = cell(length(Msubjs),1);  % mPFCil-dHPC
    M_ILVH = cell(length(Msubjs),1);  % mPFCil-vHPC
    M_ILPL = cell(length(Msubjs),1);  % mPFCil-mPFCpl
    M_DHVH = cell(length(Msubjs),1);  % dHPC-vHPC
    M_DHPL = cell(length(Msubjs),1);  % dHPC-mPFCpl
    M_VHPL = cell(length(Msubjs),1);  % vHPC-mPFCpl
% Females
    F_ILDH = cell(length(Fsubjs),4);  % mPFCil-dHPC
    F_ILVH = cell(length(Fsubjs),4);  % mPFCil-vHPC
    F_ILPL = cell(length(Fsubjs),4);  % mPFCil-mPFCpl
    F_DHVH = cell(length(Fsubjs),4);  % dHPC-vHPC
    F_DHPL = cell(length(Fsubjs),4);  % dHPC-mPFCpl
    F_VHPL = cell(length(Fsubjs),4);  % vHPC-mPFCpl

%% Re-shape data: Delta R^2, BL arena, all velocities

% Males
for si = 1:length(Msubjs) %loop thru male subjects
    subjID = Msubjs{si}; %subject name

    % Load R^2 data - all trials, including outliers
    fn = [subjID '_BandPowerCrossCorr.mat']; % file name to load
    load([drIn subjID filesep fn],'Rsquare_orig')
    clear fn
    
    [M_ILDH{si,1}(:,1)] = Rsquare_orig.Delta.il_dhip;
    [M_ILVH{si,1}(:,1)] = Rsquare_orig.Delta.il_vhip;
    [M_ILPL{si,1}(:,1)] = Rsquare_orig.Delta.il_pl;
    [M_DHVH{si,1}(:,1)] = Rsquare_orig.Delta.dhip_vhip;
    [M_DHPL{si,1}(:,1)] = Rsquare_orig.Delta.pl_dhip;
    [M_VHPL{si,1}(:,1)] = Rsquare_orig.Delta.pl_vhip;
    
    clear Rsq* subjID
end %Msubjs
clear si 

% Females (with 4 hormone states)
for si = 1:length(Fsubjs)
    subjID = Fsubjs{si};
    
    % Load index for hormone states
    load([drIn subjID filesep subjID '_ReducedData.mat'],'idx')
%     % Index hormone states
%     Didx = contains(BLlist,'_D'); %col 1
%     Pidx = contains(BLlist,'_P'); %col 2
%     Eidx = contains(BLlist,'_E'); %col 3
%     if any(contains(BLlist,'M'))
%         Midx = contains(BLlist,'_M'); %col 4
%     else
%         Midx = false(length(BLlist),1);
%     end
%     idx = double([Didx Pidx Eidx Midx]);
%     clear Didx Pidx Eidx Midx BLlist
    
    % Load R^2 data - all trials, including outliers
    fn = [subjID '_BandPowerCrossCorr.mat']; % file name to load
    load([drIn subjID filesep fn],'Rsquare_orig')
    clear fn

     % Diestrus
    [F_ILDH{si,1}(:,1)] = Rsquare_orig.Delta.il_dhip(find(idx(:,1)==1));
    [F_ILVH{si,1}(:,1)] = Rsquare_orig.Delta.il_vhip(find(idx(:,1)==1));
    [F_ILPL{si,1}(:,1)] = Rsquare_orig.Delta.il_pl(find(idx(:,1)==1));
    [F_DHVH{si,1}(:,1)] = Rsquare_orig.Delta.dhip_vhip(find(idx(:,1)==1));
    [F_DHPL{si,1}(:,1)] = Rsquare_orig.Delta.pl_dhip(find(idx(:,1)==1));
    [F_VHPL{si,1}(:,1)] = Rsquare_orig.Delta.pl_vhip(find(idx(:,1)==1));
     % Proestrus
    [F_ILDH{si,2}(:,1)] = Rsquare_orig.Delta.il_dhip(find(idx(:,2)==1));
    [F_ILVH{si,2}(:,1)] = Rsquare_orig.Delta.il_vhip(find(idx(:,2)==1));
    [F_ILPL{si,2}(:,1)] = Rsquare_orig.Delta.il_pl(find(idx(:,2)==1));
    [F_DHVH{si,2}(:,1)] = Rsquare_orig.Delta.dhip_vhip(find(idx(:,2)==1));
    [F_DHPL{si,2}(:,1)] = Rsquare_orig.Delta.pl_dhip(find(idx(:,2)==1));
    [F_VHPL{si,2}(:,1)] = Rsquare_orig.Delta.pl_vhip(find(idx(:,2)==1));
     % Estrus
    [F_ILDH{si,3}(:,1)] = Rsquare_orig.Delta.il_dhip(find(idx(:,3)==1));
    [F_ILVH{si,3}(:,1)] = Rsquare_orig.Delta.il_vhip(find(idx(:,3)==1));
    [F_ILPL{si,3}(:,1)] = Rsquare_orig.Delta.il_pl(find(idx(:,3)==1));
    [F_DHVH{si,3}(:,1)] = Rsquare_orig.Delta.dhip_vhip(find(idx(:,3)==1));
    [F_DHPL{si,3}(:,1)] = Rsquare_orig.Delta.pl_dhip(find(idx(:,3)==1));
    [F_VHPL{si,3}(:,1)] = Rsquare_orig.Delta.pl_vhip(find(idx(:,3)==1));
    % Metestrus
    [F_ILDH{si,4}(:,1)] = Rsquare_orig.Delta.il_dhip(find(idx(:,4)==1));
    [F_ILVH{si,4}(:,1)] = Rsquare_orig.Delta.il_vhip(find(idx(:,4)==1));
    [F_ILPL{si,4}(:,1)] = Rsquare_orig.Delta.il_pl(find(idx(:,4)==1)); %#ok<*FNDSB>
    [F_DHVH{si,4}(:,1)] = Rsquare_orig.Delta.dhip_vhip(find(idx(:,4)==1));
    [F_DHPL{si,4}(:,1)] = Rsquare_orig.Delta.pl_dhip(find(idx(:,4)==1));
    [F_VHPL{si,4}(:,1)] = Rsquare_orig.Delta.pl_vhip(find(idx(:,4)==1));  
    clear Rsq* idx subjID
end
clear si 

%% Save Delta R^2 data: Male and Female data
fn = 'DeltaRsq-BL_boot.mat';
save([drIn fn],'F*','M*')
% save(['K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\Bootstrap\BL\' fn],'F*','M*')
disp('Delta Rsquared data saved!')
clear fn 

end %function