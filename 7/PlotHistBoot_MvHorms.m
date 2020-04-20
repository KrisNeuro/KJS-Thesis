function [Ax] = PlotHistBoot_MvHorms(ax,Mx_boot,Dx_boot,Px_boot,Ex_boot)
% [Ax] = PlotHistBoot_MvHorms(ax,Mx_boot,Dx_boot,Px_boot,Ex_boot)
% 
% INPUTS:
%   - ax        gca
%   - Mx_boot   Male bootstrap samples
%   - Dx_boot   Diestrus female bootstrap samples
%   - Px_boot   Proestrus female bootstrap samples
%   - Ex_boot   Estrus female bootstrap samples
% 
% KJS init: 2020-04-19

numbins = 100; %number of bins for histogram
facealpha = 0.6; %Transparency of histogram bars, specified as a scalar value between 0 and 1 inclusive (default = 0.6)

%color maps
Mcol = [0 0 0]; %male
Dcol = [0.9255    0.7961    0.6824]; %diestrus female
Pcol = [0.0157    0.4235    0.6039]; %proestrus female
Ecol = [0.8392    0.6118    0.3059]; %estrus female

histogram(ax,Mx_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha,'FaceColor',Mcol)
hold on
histogram(ax,Dx_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha,'FaceColor',Dcol)
histogram(ax,Px_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha,'FaceColor',Pcol)
histogram(ax,Ex_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha,'FaceColor',Ecol)
box off
axis square
legend Male Diestrus Proestrus Estrus
set(gca,'fontsize',18,'titlefontsizemultiplier',1.5)
Ax=gca;
end 

