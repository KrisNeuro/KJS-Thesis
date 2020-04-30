function [Ax] = PlotHistBoot_Estrous(ax,Dx_boot,Px_boot,Ex_boot)
% [Ax] = PlotHistBoot_Estrous(ax,Dx_boot,Px_boot,Ex_boot)
% 
% INPUTS:
%   - ax        gca
%   - Dx_boot   Diestrus female bootstrap samples
%   - Px_boot   Proestrus female bootstrap samples
%   - Ex_boot   Estrus female bootstrap samples
% 
% KJS init: 2020-04-19

numbins = 100; %number of bins for histogram

%color maps
Dcol = [0.6980    0.5137         0]; %diestrus female
Pcol = [0.3490    0.0392         0]; %proestrus female
Ecol = [1.0000    0.8863    0.2118]; %estrus female
% Mcol = [0.8627    0.6314    0.0549]; %metestrus female

% Transparency of histogram bars, specified as a scalar value between 0 and 1 inclusive
Dfa = 0.38; %diestrus
Pfa = 1; %proestrus
Efa = 0.58; %estrus
% Mfa = 0.89; %metestrus

a1= histogram(ax,Px_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',Pfa,'FaceColor',Pcol);
hold on
% a4 = histogram(ax,Mx_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',Mfa,'FaceColor',Mcol); 
a2 = histogram(ax,Ex_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',Efa,'FaceColor',Ecol);
a3 = histogram(ax,Dx_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',Dfa,'FaceColor',Dcol);

box off
axis square
% legend([a3 a1 a2 a4],{'Diestrus' 'Proestrus' 'Estrus' 'Metestrus'})
legend([a3 a1 a2],{'Diestrus' 'Proestrus' 'Estrus'})
legend('boxoff')
ylabel('probability')
set(gca,'fontsize',20,'titlefontsizemultiplier',2)
Ax=gca;
end