function [Ax] = PlotHistBoot_MF(ax,Mx_boot,Fx_boot)
% [Ax] = PlotHistBoot_MF(ax,Mx_boot,Fx_boot)
% [Ax] = PlotHistBoot_Estrous(ax,Dx_boot,Px_boot,Ex_boot)
% 
% INPUTS:
%   - ax        gca
%   - Mx_boot   Male bootstrap samples
%   - Fx_boot   Female bootstrap samples
% 
% KJS init: 2020-04-16

numbins = 100; %number of bins for histogram

% Color maps
Mcol = [0         0.2980    0.2980]; %teal
Fcol = [0.9529    0.9098    0.0824]; %yellow

% Transparency of histogram bars, specified as a scalar value between 0 and 1 inclusive
Mfa = 0.72; %male
Ffa = 0.75;  %female

a1 = histogram(ax,Fx_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',Ffa,'FaceColor',Fcol);
hold on
a2 = histogram(ax,Mx_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',Mfa,'FaceColor',Mcol);
box off
axis square
legend Female Male
set(gca,'fontsize',20,'titlefontsizemultiplier',2)
Ax=gca;
end %function