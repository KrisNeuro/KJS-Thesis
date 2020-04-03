function [Fx_D_boot,Fx_P_boot,Fx_E_boot,fDP_p_test,fDE_p_test,fPE_p_test,DP_pjm,DE_pjm,PE_pjm] = BootStat_FHorms(Dx,Px,Ex)
%BootStat_FHorms
% [Fx_D_boot,Fx_P_boot,Fx_E_boot,fDP_p_test,fDE_p_test,fPE_p_test,DP_pjm,DE_pjm,PE_pjm] = BootStat_FHorms(Dx,Px,Ex)
% 
% Calculates bootstrap resampling of unidimensional data in a
% single-variable female hormone comparison. Compares ONLY Diestrus,
% Proestrus, and Estrus variables (Metestrus data is excluded).
% 
% OUTPUTS:
%   - MF_fDP_p_test Probability estimate of Proestrus sample (variable2) 
%                   being greater than Diestrus sample (variable1).
%   - fDE_p_test Probability estimate of Estrus sample (variable2) 
%                   being greater than Diestrus sample (variable1).
%   - fPE_p_test Probability estimate of Estrus sample (variable2) 
%                   being greater than Proestrus sample (variable1).
%   - DP_pjm        Joint-probability matrix: D vs P (size: 100x100).
%   - DE_pjm        Joint-probability matrix: D vs E (size: 100x100).
%   - PE_pjm        Joint-probability matrix: P vs E (size: 100x100).
% 
%   CALLS FUNCTIONS:
%       - get_bootstrapped_sample.m
%       - get_direct_prob.m
% 
% KJS init: 2020-03-03
% KJS edit 2020-03-13 Added *_boot outputs

%% setup
nboot = 10^4; %number of times to resample data with replacement
f_n=1;

%% Get bootstrapped samples
Fx_D_boot = get_bootstrapped_sample(Dx, nboot, f_n); % Diestrus
Fx_P_boot = get_bootstrapped_sample(Px, nboot, f_n); % Proestrus
Fx_E_boot = get_bootstrapped_sample(Ex, nboot, f_n); % Estrus

%% Ptest: Females/Hormones
[fDP_p_test,DP_pjm] = get_direct_prob(Fx_D_boot, Fx_P_boot);
[fDE_p_test,DE_pjm] = get_direct_prob(Fx_D_boot, Fx_E_boot);
[fPE_p_test,PE_pjm] = get_direct_prob(Fx_P_boot, Fx_E_boot);

end

