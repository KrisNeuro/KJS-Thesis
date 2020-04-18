function [H1] = PlotHistBoot_Estrous()
H1 = figure('units','normalized','outerposition',[0 0 1 1]);

numbins = 100; %number of bins for histogram
facealpha = 0.6; %Transparency of histogram bars, specified as a scalar value between 0 and 1 inclusive (default = 0.6)

a1 = subplot(311); %Diestrus
	histogram(fD_PL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	hold on
	histogram(fD_VH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	histogram(fD_IL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	histogram(fD_DH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	box off
	title('Diestrus')
	legend mPFC-PL vHPC mPFC-IL dHPC 
	legend('location','best')
	set(a1,'fontsize',20,'titlefontsizemultiplier',1.5)

a2 = subplot(312); %Proestrus
	histogram(fP_PL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	hold on
	histogram(fP_VH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	histogram(fP_IL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	histogram(fP_DH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	box off
	title('Proestrus')
	ylabel('Probability')
	set(a2,'fontsize',20,'titlefontsizemultiplier',1.5)

a3 = subplot(313); %Estrus
	histogram(fE_PL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	hold on
	histogram(fE_VH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	histogram(fE_IL_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	histogram(fE_DH_theta_boot,'normalization','probability','EdgeColor','none','NumBins',numbins,'FaceAlpha',facealpha)
	box off
	title('Estrus')
	xlabel('Theta band power')
	set(a3,'fontsize',20,'titlefontsizemultiplier',1.5)

linkaxes([a1 a2 a3],'x')

end %function
