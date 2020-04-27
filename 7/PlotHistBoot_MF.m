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
facealpha = 0.6; %Transparency of histogram bars, specified as a scalar value between 0 and 1 inclusive (default = 0.6)

%color maps
Mcol = [0.0431    0.4667    0.3686]; %male
Fcol = [0.2078    0.1529    0.2902]; %female


histogram(ax,Mx_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha,'FaceColor',Mcol)
hold on
histogram(ax,Fx_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha,'FaceColor',Fcol)
box off
axis square
legend Male Female
set(gca,'fontsize',20,'titlefontsizemultiplier',2)
Ax=gca;
end %function