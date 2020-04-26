%BootStat_MvF
function [Mx_boot,Fx_boot,MF_p_test,MF_p2_test,MF_pjm] = BootStat_MvF(Mx,Fx)
% [Mx_boot,Fx_boot,MF_p_test,MF_pjm] = BootStat_MvF(Mx,Fx)
% 
% Calculates bootstrap resampling of unidimensional data in a
% single-variable sex differences comparison. 
% 
% INPUTS:
% 	-*x 			Input data, cell format:rows=subjects; columns=trials
%
% OUTPUTS:
%   - Mx_boot       Bootstrapped samples: Male
%   - Fx_boot       Bootstrapped samples: Female
%   - MF_*_p_test   Probability estimate of Female sample (variable2) being 
%                   equal to or greater than Male sample (variable1)
%   - MF_pjm        Joint-probability matrix (size: 100x100)
% 
%   CALLS FUNCTIONS:
%       - get_bootstrapped_sample.m
%       - get_direct_prob.m
% 
% KJS init: 2020-03-03
% KJS edit: 2020-03-05
% KJS edit: 2020-03-13 Added *_boot outputs

%% 
% Setup
nboot = 10^4; %number of times to resample data (with replacement)
f_n=1;

% Get bootstrapped samples: Male 
Mx_boot = get_bootstrapped_sample(Mx, nboot, f_n);  

% Get bootstrapped samples: Female (all trials)
Fx_boot = get_bootstrapped_sample(Fx, nboot, f_n); 

% Ptest: Males vs Females 
[MF_p_test,MF_p2_test,MF_pjm] = get_direct_prob(Mx_boot,Fx_boot);

end %fxn
