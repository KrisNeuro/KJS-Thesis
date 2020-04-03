function [M_ILDH,M_ILVH,M_ILPL,M_DHVH,M_DHPL,M_VHPL,F_ILDH,F_ILVH,F_ILPL,F_DHVH,F_DHPL,F_VHPL,...
F_ILDH_D,F_ILVH_D,F_ILPL_D,F_DHVH_D,F_DHPL_D,F_VHPL_D,F_ILDH_P,F_ILVH_P,F_ILPL_P,F_DHVH_P,F_DHPL_P,F_VHPL_P,...
F_ILDH_E,F_ILVH_E,F_ILPL_E,F_DHVH_E,F_DHPL_E,F_VHPL_E,F_ILDH_M,F_ILVH_M,F_ILPL_M,F_DHVH_M,F_DHPL_M,F_VHPL_M] = Format4Bootstrap_Rsq2(subjs,drIn,Band)
%% Format4Bootstrap_Rsq2
% 
% [M_ILDH,M_ILVH,M_ILPL,M_DHVH,M_DHPL,M_VHPL,F_ILDH,F_ILVH,F_ILPL,F_DHVH,F_DHPL,F_VHPL,...
% F_ILDH_D,F_ILVH_D,F_ILPL_D,F_DHVH_D,F_DHPL_D,F_VHPL_D,F_ILDH_P,F_ILVH_P,F_ILPL_P,F_DHVH_P,F_DHPL_P,F_VHPL_P,...
% F_ILDH_E,F_ILVH_E,F_ILPL_E,F_DHVH_E,F_DHPL_E,F_VHPL_E,F_ILDH_M,F_ILVH_M,F_ILPL_M,F_DHVH_M,F_DHPL_M,F_VHPL_M] ...
%     = Format4Bootstrap_Rsq2(subjs,drIn,Band)
% 
%  BL data only: All running velocities considered
% 
%   Called by: Thesis4_AnalyzeAllVelDat.m
% 
% KJS init: 2020-03-10 (formatting similarly to Format4Bootstrap_thetaphaselag.m)

%% Setup

% Subject ID listing A*=male  E*=female
Msubjs = subjs(contains(subjs,'A')); %male subject IDs
Fsubjs = subjs(contains(subjs,'E')); %female subject IDs

if ~ischar(Band)
    char(Band)
end

%% Theta

% Preallocate output space
 % Males    
maxT = 27; %max # of trials for any single male subject
M_ILDH = cell(length(Msubjs), maxT);  % mPFCil-dHPC
M_ILVH = cell(length(Msubjs), maxT);  % mPFCil-vHPC
M_ILPL = cell(length(Msubjs), maxT);  % mPFCil-mPFCpl
M_DHVH = cell(length(Msubjs), maxT);  % dHPC-vHPC
M_DHPL = cell(length(Msubjs), maxT);  % dHPC-mPFCpl
M_VHPL = cell(length(Msubjs), maxT);  % vHPC-mPFCpl
clear maxT

  % Females
maxT = 28; %maximum # of trials for any single female subject
F_ILDH = cell(length(Fsubjs),maxT);
F_ILVH = cell(length(Fsubjs),maxT);
F_ILPL = cell(length(Fsubjs),maxT);
F_DHVH = cell(length(Fsubjs),maxT);
F_DHPL = cell(length(Fsubjs),maxT);
F_VHPL = cell(length(Fsubjs),maxT);
clear maxT

%% Re-shape data: Band R^2, BL arena, all velocities.  MvF

% Males
for si = 1:length(Msubjs) %loop thru male subjects
    subjID = Msubjs{si}; %subject name

    % Load R^2 data - all trials, including outlier points in correlation
    fn = [subjID '_BL_BandPowerCrossCorr.mat'];
    load([drIn subjID filesep fn],'Rsquare_orig') 
    clear fn
    
    for ri = 1:length(Rsquare_orig.(Band).il_dhip) %loop trials
        [M_ILDH{si,ri}] = Rsquare_orig.(Band).il_dhip(ri);
        [M_ILVH{si,ri}] = Rsquare_orig.(Band).il_vhip(ri);
        [M_ILPL{si,ri}] = Rsquare_orig.(Band).il_pl(ri);
        [M_DHVH{si,ri}] = Rsquare_orig.(Band).dhip_vhip(ri);
        [M_DHPL{si,ri}] = Rsquare_orig.(Band).pl_dhip(ri);
        [M_VHPL{si,ri}] = Rsquare_orig.(Band).pl_vhip(ri);
    end
    clear Rsq* subjID ri
end %Msubjs
clear si 

% Females
for si = 1:length(Fsubjs) %loop thru female subjects
    subjID = Fsubjs{si}; %subject name

    % Load R^2 data - all trials, including outlier points in correlation
    fn = [subjID '_BL_BandPowerCrossCorr.mat'];
    load([drIn subjID filesep fn],'Rsquare_orig') 
    clear fn
    
    for ri = 1:length(Rsquare_orig.(Band).il_dhip) %loop trials
        [F_ILDH{si,ri}] = Rsquare_orig.(Band).il_dhip(ri);
        [F_ILVH{si,ri}] = Rsquare_orig.(Band).il_vhip(ri);
        [F_ILPL{si,ri}] = Rsquare_orig.(Band).il_pl(ri);
        [F_DHVH{si,ri}] = Rsquare_orig.(Band).dhip_vhip(ri);
        [F_DHPL{si,ri}] = Rsquare_orig.(Band).pl_dhip(ri);
        [F_VHPL{si,ri}] = Rsquare_orig.(Band).pl_vhip(ri);
    end
    clear Rsq* subjID ri
end %Fsubjs
clear si 


%% Re-shape data: Band R^2, BL arena, all velocities.  Females/Hormones
maxD = 14;
maxP = 9;
maxE = 9;
maxM = 3;
% Preallocate space: Diestrus
    F_ILDH_D = cell(length(Fsubjs),maxD);
    F_ILVH_D = cell(length(Fsubjs),maxD);
    F_ILPL_D = cell(length(Fsubjs),maxD);
    F_DHVH_D = cell(length(Fsubjs),maxD);
    F_DHPL_D = cell(length(Fsubjs),maxD);
    F_VHPL_D = cell(length(Fsubjs),maxD);
    clear maxD
% Preallocate space: Proestrus
    F_ILDH_P = cell(length(Fsubjs),maxP);
    F_ILVH_P = cell(length(Fsubjs),maxP);
    F_ILPL_P = cell(length(Fsubjs),maxP);
    F_DHVH_P = cell(length(Fsubjs),maxP);
    F_DHPL_P = cell(length(Fsubjs),maxP);
    F_VHPL_P = cell(length(Fsubjs),maxP);
    clear maxP
% Preallocate space: Estrus
    F_ILDH_E = cell(length(Fsubjs),maxE);
    F_ILVH_E = cell(length(Fsubjs),maxE);
    F_ILPL_E = cell(length(Fsubjs),maxE);
    F_DHVH_E = cell(length(Fsubjs),maxE);
    F_DHPL_E = cell(length(Fsubjs),maxE);
    F_VHPL_E = cell(length(Fsubjs),maxE);
    clear maxE
% Preallocate space: Metestrus
    F_ILDH_M = cell(length(Fsubjs),maxM);
    F_ILVH_M = cell(length(Fsubjs),maxM);
    F_ILPL_M = cell(length(Fsubjs),maxM);
    F_DHVH_M = cell(length(Fsubjs),maxM);
    F_DHPL_M = cell(length(Fsubjs),maxM);
    F_VHPL_M = cell(length(Fsubjs),maxM);
    clear maxM

    
for si = 1:length(Fsubjs)
    subjID = Fsubjs{si}; %subject name

%    Load index for hormone states across recordings
%        idx format:
%         (:,1) = Diestrus
%         (:,2) = Proestrus
%         (:,3) = Estrus
%         (:,4) = Metestrus
    fnn = [subjID '_ThetaFiltfilt.mat']; % file name to load
    load([drIn subjID filesep fnn],'idx')
    clear fnn
        if size(idx,1) < size(idx,2)
            idx = idx';
        end
        
    % Load R^2 data - all trials, including outlier points in correlation
    fn = [subjID '_BL_BandPowerCrossCorr.mat'];
    load([drIn subjID filesep fn],'Rsquare_orig') 
    clear fn
    
    for ti = 1:4 %loop thru hormone states: column 1=Diestrus, 2=Proestrus, 3=Estrus, 4=Metestrus
        hidx = find(idx(:,ti)==1); %index of trials in this state
        for ri = 1:length(hidx) %loop trials in this hormone state
            switch ti
                case 1 %Diestrus
                    F_ILDH_D{si,ri} = Rsquare_orig.(Band).il_dhip(hidx(ri)); 
                    F_ILVH_D{si,ri} = Rsquare_orig.(Band).il_vhip(hidx(ri)); 
                    F_ILPL_D{si,ri} = Rsquare_orig.(Band).il_pl(hidx(ri)); 
                    F_DHVH_D{si,ri} = Rsquare_orig.(Band).dhip_vhip(hidx(ri)); 
                    F_DHPL_D{si,ri} = Rsquare_orig.(Band).pl_dhip(hidx(ri)); 
                    F_VHPL_D{si,ri} = Rsquare_orig.(Band).pl_vhip(hidx(ri)); 
                case 2 %Proestrus
                    F_ILDH_P{si,ri} = Rsquare_orig.(Band).il_dhip(hidx(ri)); 
                    F_ILVH_P{si,ri} = Rsquare_orig.(Band).il_vhip(hidx(ri)); 
                    F_ILPL_P{si,ri} = Rsquare_orig.(Band).il_pl(hidx(ri)); 
                    F_DHVH_P{si,ri} = Rsquare_orig.(Band).dhip_vhip(hidx(ri)); 
                    F_DHPL_P{si,ri} = Rsquare_orig.(Band).pl_dhip(hidx(ri)); 
                    F_VHPL_P{si,ri} = Rsquare_orig.(Band).pl_vhip(hidx(ri)); 
                case 3
                    F_ILDH_E{si,ri} = Rsquare_orig.(Band).il_dhip(hidx(ri)); 
                    F_ILVH_E{si,ri} = Rsquare_orig.(Band).il_vhip(hidx(ri)); 
                    F_ILPL_E{si,ri} = Rsquare_orig.(Band).il_pl(hidx(ri)); 
                    F_DHVH_E{si,ri} = Rsquare_orig.(Band).dhip_vhip(hidx(ri)); 
                    F_DHPL_E{si,ri} = Rsquare_orig.(Band).pl_dhip(hidx(ri)); 
                    F_VHPL_E{si,ri} = Rsquare_orig.(Band).pl_vhip(hidx(ri)); 
                case 4
                    F_ILDH_M{si,ri} = Rsquare_orig.(Band).il_dhip(hidx(ri)); 
                    F_ILVH_M{si,ri} = Rsquare_orig.(Band).il_vhip(hidx(ri)); 
                    F_ILPL_M{si,ri} = Rsquare_orig.(Band).il_pl(hidx(ri)); 
                    F_DHVH_M{si,ri} = Rsquare_orig.(Band).dhip_vhip(hidx(ri)); 
                    F_DHPL_M{si,ri} = Rsquare_orig.(Band).pl_dhip(hidx(ri)); 
                    F_VHPL_M{si,ri} = Rsquare_orig.(Band).pl_vhip(hidx(ri)); 
            end %switch
            clear ri
        end %trials
        clear hidx
    end %hormones
    clear idx ti sidx subjID Rsq*
end %Fsubjs
clear si 

end %function