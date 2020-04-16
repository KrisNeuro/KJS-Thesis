function [h1] = Plot_4pjm_MF(MF_IL_pjm,MF_DH_pjm,MF_VH_pjm,MF_PL_pjm,nperms,x)
%Plot_4pjm_MF 
% [h1] = Plot_4pjm_MF(MF_IL_pjm,MF_DH_pjm,MF_VH_pjm,MF_PL_pjm,nperms,x)
% 
%   Plots joint-probability matrices for 4 brain region bootstrapped
%   samples: Female vs Male comparison
% 
%   Called by:
%       Thesis7_Analyze5to15BLDat_V2.m
% 
% KJS init (as fxn): 2020-03-13

h1 = figure('units','normalized','outerposition',[0 0 1 1]);
ax1 = subplot(221); %IL
    imagesc(squeeze(mean(MF_IL_pjm(:,:,1:nperms),3))); hold on; plot(x,x,'k','linew',2);
    axis xy square; 
    xlabel('Male mPFC-IL'); ylabel('Female mPFC-IL')
    set(gca,'fontsize',14)
    colormap(ax1,jet)
ax2 = subplot(222); %DH
    imagesc(squeeze(mean(MF_DH_pjm(:,:,1:nperms),3))); hold on; plot(x,x,'k','linew',2);
    axis xy square; 
    xlabel('Male dHPC'); ylabel('Female dHPC')
    set(gca,'fontsize',14)
    colormap(ax2,jet)
ax3 = subplot(223); %VH
    imagesc(squeeze(mean(MF_VH_pjm(:,:,1:nperms),3))); hold on; plot(x,x,'k','linew',2);
    axis xy square; 
    xlabel('Male vHPC'); ylabel('Female vHPC')
    set(gca,'fontsize',14)
    colormap(ax3,jet)
ax4 = subplot(224); %PL
    imagesc(squeeze(mean(MF_PL_pjm(:,:,1:nperms),3))); hold on; plot(x,x,'k','linew',2);
    axis xy square; 
    xlabel('Male mPFC-PL'); ylabel('Female mPFC-PL')
    set(gca,'fontsize',14)
    colormap(ax4,jet)

end

