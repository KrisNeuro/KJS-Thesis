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
facealpha = 0.6; %Transparency of histogram bars, specified as a scalar value between 0 and 1 inclusive (default = 0.6)

%color maps
Dcol = [0.4471    0.5804    0.8314]; %diestrus
Pcol = [0.9020    0.6275    0.7686]; %proestrus
Ecol = [0.7765    0.8039    0.9686]; %estrus


histogram(ax,Dx_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha,'FaceColor',Dcol)
hold on
histogram(ax,Px_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha,'FaceColor',Pcol)
histogram(ax,Ex_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha,'FaceColor',Ecol)
box off
axis square
legend Diestrus Proestrus Estrus
set(gca,'fontsize',18,'titlefontsizemultiplier',1.5)
Ax=gca;
end 

% 
% % OLD SCRIPT BELOW
% 
% a1 = subplot(311); %Diestrus
% 	histogram(fD_PL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	hold on
% 	histogram(fD_VH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	histogram(fD_IL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	histogram(fD_DH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	box off
% 	title('Diestrus')
% 	legend mPFC-PL vHPC mPFC-IL dHPC 
% 	legend('location','best')
% 	set(a1,'fontsize',20,'titlefontsizemultiplier',1.5)
% 
% a2 = subplot(312); %Proestrus
% 	histogram(fP_PL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	hold on
% 	histogram(fP_VH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	histogram(fP_IL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	histogram(fP_DH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	box off
% 	title('Proestrus')
% 	ylabel('Probability')
% 	set(a2,'fontsize',20,'titlefontsizemultiplier',1.5)
% 
% a3 = subplot(313); %Estrus
% 	histogram(fE_PL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	hold on
% 	histogram(fE_VH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	histogram(fE_IL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	histogram(fE_DH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
% 	box off
% 	title('Estrus')
% 	xlabel('Theta band power')
% 	set(a3,'fontsize',20,'titlefontsizemultiplier',1.5)
% 
% linkaxes([a1 a2 a3],'x')