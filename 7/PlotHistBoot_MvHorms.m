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

%color maps
Mcol = [0         0.2980    0.2980]; %male
Dcol = [0.6980    0.5137         0]; %diestrus female
Pcol = [0.3490    0.0392         0]; %proestrus female
Ecol = [1.0000    0.8863    0.2118]; %estrus female

% Transparency of histogram bars, specified as a scalar value between 0 and 1 inclusive
Mfa = 0.72; %male
Dfa = 0.38; %diestrus
Pfa = 1; %proestrus
Efa = 0.58; %estrus

a3 = histogram(ax,Px_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',Pfa,'FaceColor',Pcol);
hold on
a1 = histogram(ax,Mx_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',Mfa,'FaceColor',Mcol);
a4 = histogram(ax,Ex_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',Efa,'FaceColor',Ecol);
a2 = histogram(ax,Dx_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',Dfa,'FaceColor',Dcol);

box off
axis square
legend([a1 a3 a2 a4],{'Male' 'Proestrus' 'Diestrus' 'Estrus'})
legend('boxoff')
ylabel('probability')
set(gca,'fontsize',20,'titlefontsizemultiplier',2)
Ax=gca;
end 