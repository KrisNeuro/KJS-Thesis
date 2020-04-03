function [H1,stat] = PlotBoot_mscohere(f,Mx,Fx)
% [H1,H2,H3,H4,ILstat,PLstat,DHstat,VHstat] = PlotBoot_mscohere(f,Mil,Fil,Mpl,Fpl,Mdh,Fdh,Mvh,Fvh)
% 
% Plots mscohere: Sex differences, with shading for SEM indicating subjects
% 
% Calls on scripts:
%   - colorcet.m  (https://peterkovesi.com/projects/colourmaps/)
%   - shadedErrorBar.m  (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
%   - twosampF.m 
% 
% % Calls data produced by:
%   - Format4Bootstrap_mscohere.m: 'mscohere-BL-5to15_boot.mat' (called within Thesis6_Format4Bootstrap_5to15.m)
% 
%   Called by:
%       - Thesis6_Format4Bootstrap_5to15.m
% 
% KJS init: 2020-01-24
% KJS re-write init (as fxn): 2020-02-27

%% SETUP

% twosampF.m parameters
method = 1;
parflag = 1;
% biasflag = 1;

% Color maps
maleblue = colorcet('L6'); %linear blue 192 
    maleblue = maleblue(192,:); % MALES
fempurp = colorcet('L8'); %linear blue magenta yellow
    propurp = fempurp(65,:); %purple - FEMALES
clear fempurp


% %% Load in data formatted for boostrap
% drIn = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\Bootstrap\BL\';
% load([drIn 'mscohere-BL-5to15_boot.mat'],'F_*','M_*','f')
% clear *subjs

% %% Concatenate data
% % mPFC-IL - dHPC
% Fildh = [cell2mat(F_ILDH(:,1)); cell2mat(F_ILDH(:,2)); cell2mat(F_ILDH(:,3)); cell2mat(F_ILDH(:,4))];
% Mildh = cell2mat(M_ILDH);
% % mPFC-IL - vHPC
% Filvh = [cell2mat(F_ILVH(:,1)); cell2mat(F_ILVH(:,2)); cell2mat(F_ILVH(:,3)); cell2mat(F_ILVH(:,4))];
% Milvh = cell2mat(M_ILVH);
% % mPFC-IL - PL
% Filpl = [cell2mat(F_ILPL(:,1)); cell2mat(F_ILPL(:,2)); cell2mat(F_ILPL(:,3)); cell2mat(F_ILPL(:,4))];
% Milpl = cell2mat(M_ILPL);
% % dHPC-vHPC
% Fdhvh = [cell2mat(F_DHVH(:,1)); cell2mat(F_DHVH(:,2)); cell2mat(F_DHVH(:,3)); cell2mat(F_DHVH(:,4))];
% Mdhvh = cell2mat(M_DHVH);
% % dHPC - PL
% Fdhpl = [cell2mat(F_DHPL(:,1)); cell2mat(F_DHPL(:,2)); cell2mat(F_DHPL(:,3)); cell2mat(F_DHPL(:,4))];
% Mdhpl = cell2mat(M_DHPL);
% %vHPC - PL
% Fvhpl = [cell2mat(F_VHPL(:,1)); cell2mat(F_VHPL(:,2)); cell2mat(F_VHPL(:,3)); cell2mat(F_VHPL(:,4))];
% Mvhpl = cell2mat(M_VHPL);
% clear M_*

%% Plot mscohere
H1 = figure('units','normalized','outerposition',[0 0 1 1]);
% p2 = shadedErrorBar(f,Mildh,{@mean,@std},'lineprops',{'color',maleblue});
p2 = shadedErrorBar(f,Mx,{@mean,@(x) std(Mx)/sqrt(size(Mx,1))},'lineprops',{'color',maleblue}); %subject-collapsed
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Male';
hold on
% p1 = shadedErrorBar(f,Fildh,{@mean,@std},'lineprops',{'color',propurp});
p1 = shadedErrorBar(f,Fx,{@mean,@(x) std(Fx)/sqrt(size(Fx,1))},'lineprops',{'color',propurp}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Female';
axis square
xlim([0.5 50])
ylim([0 1])
xticks(10:10:50)
yticks([0 : 0.2 : 1])
xlabel('Frequency (Hz)')
ylabel('Magnitude-squared Coherence')
% title('mPFCIL - dHPC')
legend([p1.mainLine, p2.mainLine],{'Female','Male'})
legend('location','southwest')
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.5)

% Functional 2-sample F-test
[stat] = twosampF(Fx,Mx,method,parflag);
% 
% %% Plot mPFCIL- vHPC
% H2 = figure('units','normalized','outerposition',[0 0 1 1]);
% p2 = shadedErrorBar(f,Milvh,{@mean,@std},'lineprops',{'color',maleblue});
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Male';
% hold on
% p1 = shadedErrorBar(f,Filvh,{@mean,@std},'lineprops',{'color',propurp});
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Female';
% axis square
% xlim([0.5 50])
% ylim([0 1])
% xticks(10:10:50)
% yticks([0 : 0.2 : 1])
% xlabel('Frequency (Hz)')
% ylabel('Magnitude-squared Coherence')
% title('mPFCIL - vHPC')
% % legend([p1.mainLine, p2.mainLine],{'Female','Male'})
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % Functional 2-sample F-test
% [ILVHstat.MvF] = twosampF(Filvh,Milvh,method,parflag);
% 
% %% Plot ILPL
% H3 = figure('units','normalized','outerposition',[0 0 1 1]);
% p2 = shadedErrorBar(f,Milpl,{@mean,@std},'lineprops',{'color',maleblue});
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Male';
% hold on
% p1 = shadedErrorBar(f,Filpl,{@mean,@std},'lineprops',{'color',propurp});
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Female';
% axis square
% xlim([0.5 50])
% ylim([0 1])
% xticks(10:10:50)
% yticks([0 : 0.2 : 1])
% xlabel('Frequency (Hz)')
% ylabel('Magnitude-squared Coherence')
% title('mPFCIL - mPFCPL')
% % legend([p1.mainLine, p2.mainLine],{'Female','Male'})
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % Functional 2-sample F-test
% [ILPLstat.MvF] = twosampF(Filpl,Milpl,method,parflag);
% 
% %% DHVH
% H4 = figure('units','normalized','outerposition',[0 0 1 1]);
% p2 = shadedErrorBar(f,Mdhvh,{@mean,@std},'lineprops',{'color',maleblue});
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Male';
% hold on
% p1 = shadedErrorBar(f,Fdhvh,{@mean,@std},'lineprops',{'color',propurp});
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Female';
% axis square
% xlim([0.5 50])
% ylim([0 1])
% xticks(10:10:50)
% yticks([0 : 0.2 : 1])
% xlabel('Frequency (Hz)')
% ylabel('Magnitude-squared Coherence')
% title('dHPC - vHPC')
% % legend([p1.mainLine, p2.mainLine],{'Female','Male'})
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % Functional 2-sample F-test
% [DHVHstat.MvF] = twosampF(Fdhvh,Mdhvh,method,parflag);
% 
% %% DHPL
% H5 = figure('units','normalized','outerposition',[0 0 1 1]);
% p2 = shadedErrorBar(f,Mdhpl,{@mean,@std},'lineprops',{'color',maleblue});
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Male';
% hold on
% p1 = shadedErrorBar(f,Fdhpl,{@mean,@std},'lineprops',{'color',propurp});
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Female';
% axis square
% xlim([0.5 50])
% ylim([0 1])
% xticks(10:10:50)
% yticks([0 : 0.2 : 1])
% xlabel('Frequency (Hz)')
% ylabel('Magnitude-squared Coherence')
% title('dHPC - mPFCPL')
% % legend([p1.mainLine, p2.mainLine],{'Female','Male'})
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % Functional 2-sample F-test
% [DHPLstat.MvF] = twosampF(Fdhpl,Mdhpl,method,parflag);
% 
% %% VHPL
% H6 = figure('units','normalized','outerposition',[0 0 1 1]);
% p2 = shadedErrorBar(f,Mvhpl,{@mean,@std},'lineprops',{'color',maleblue});
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Male';
% hold on
% p1 = shadedErrorBar(f,Fvhpl,{@mean,@std},'lineprops',{'color',propurp});
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Female';
% axis square
% xlim([0.5 50])
% ylim([0 1])
% xticks(10:10:50)
% yticks([0 : 0.2 : 1])
% xlabel('Frequency (Hz)')
% ylabel('Magnitude-squared Coherence')
% title('vHPC - mPFCPL')
% % legend([p1.mainLine, p2.mainLine],{'Female','Male'})
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% 
% % Functional 2-sample F-test
% [VHPLstat.MvF] = twosampF(Fvhpl,Mvhpl,method,parflag);
% 
% %% Save figures
% cd('K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\figs\PowSpec_ReducedChannels\BL\FunctionalAnova')
% saveas(H1,'ILDHms-SexDiffs-SD-5to15.tif')
% saveas(H1,'ILDHms-SexDiffs-SD-5to15.fig')
% close(H1); clear H1
% 
% saveas(H2,'ILVHms-SexDiffs-SD-5to15.tif')
% saveas(H2,'ILVHms-SexDiffs-SD-5to15.fig')
% close(H2); clear H2
% 
% saveas(H3,'ILPLms-SexDiffs-SD-5to15.tif')
% saveas(H3,'ILPLms-SexDiffs-SD-5to15.fig')
% close(H3); clear H3
% 
% saveas(H4,'DHVHms-SexDiffs-SD-5to15.tif')
% saveas(H4,'DHVHms-SexDiffs-SD-5to15.fig')
% close(H4); clear H4
% 
% saveas(H5,'DHPLms-SexDiffs-SD-5to15.tif')
% saveas(H5,'DHPLms-SexDiffs-SD-5to15.fig')
% close(H5); clear H5
% 
% saveas(H6,'VHPLms-SexDiffs-SD-5to15.tif')
% saveas(H6,'VHPLms-SexDiffs-SD-5to15.fig')
% close(H6); clear H6
% 
% %% FEMALES: Estrous stages
% % A: nx1  indicator of the levels of Factor A (Female hormone state)
%     DiN = size(cell2mat(F_ILDH(:,1)),1); %Diestrus n count
%     ProN = size(cell2mat(F_ILDH(:,2)),1); %Proestrus n count
%     EstN = size(cell2mat(F_ILDH(:,3)),1); %Estrus n count
%     A(1:DiN) = 1; %Diestrus=1
%     A(DiN+1:DiN+ProN)=2; %Proestrus=2
%     A(DiN+ProN+1:DiN+ProN+EstN)=3; %Estrus=3
%     A = A'; %orient correctly
% % clear Mil Fil Mpl Fpl Mdh Fdh Mvh Fvh
% 
% % concatenate data per stage
% % ILDH
% Dildh = cell2mat(F_ILDH(:,1));
% Pildh = cell2mat(F_ILDH(:,2));
% Eildh = cell2mat(F_ILDH(:,3));
% Mildh =  cell2mat(F_ILDH(:,4));
% 
% % ILVH
% Dilvh = cell2mat(F_ILVH(:,1));
% Pilvh = cell2mat(F_ILVH(:,2));
% Eilvh = cell2mat(F_ILVH(:,3));
% Milvh =  cell2mat(F_ILVH(:,4));
% 
% % ILPL
% Dilpl = cell2mat(F_ILPL(:,1));
% Pilpl = cell2mat(F_ILPL(:,2));
% Eilpl = cell2mat(F_ILPL(:,3));
% Milpl =  cell2mat(F_ILPL(:,4));
% 
% % dHvH
% Ddhvh = cell2mat(F_DHVH(:,1));
% Pdhvh = cell2mat(F_DHVH(:,2));
% Edhvh = cell2mat(F_DHVH(:,3));
% Mdhvh =  cell2mat(F_DHVH(:,4));
% 
% %DH-PL
% Ddhpl = cell2mat(F_DHPL(:,1));
% Pdhpl = cell2mat(F_DHPL(:,2));
% Edhpl = cell2mat(F_DHPL(:,3));
% Mdhpl =  cell2mat(F_DHPL(:,4));
% 
% %vHPC
% Dvhpl = cell2mat(F_VHPL(:,1));
% Pvhpl = cell2mat(F_VHPL(:,2));
% Evhpl = cell2mat(F_VHPL(:,3));
% Mvhpl =  cell2mat(F_VHPL(:,4));
% 
% %% Plot mPFC-IL - dHPC
% H1 = figure('units','normalized','outerposition',[0 0 1 1]);
% p4 = shadedErrorBar(f,Mildh,{@mean,@std},'lineprops',{'color',metred});
% p4.mainLine.LineWidth = 3;
% p4.mainLine.DisplayName = 'Metestrus';
% hold on
% 
% p3 = shadedErrorBar(f,Eildh,{@mean,@std},'lineprops',{'color',estyel});
% p3.mainLine.LineWidth = 3;
% p3.mainLine.DisplayName = 'Estrus';
% 
% p2 = shadedErrorBar(f,Pildh,{@mean,@std},'lineprops',{'color',propurp});
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Proestrus';
% 
% p1 = shadedErrorBar(f,Dildh,{@mean,@std},'lineprops',{'color',digreen});
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Diestrus';
% 
% axis square
% xlim([0.5 50])
% ylim([0 1])
% xticks(10:10:50)
% yticks([0 : 0.2 : 1])
% xlabel('Frequency (Hz)')
% ylabel('Magnitude-squared Coherence')
% title('mPFCIL - dHPC')
% 
% legend([p1.mainLine, p2.mainLine, p3.mainLine, p4.mainLine],{'Diestrus','Proestrus','Estrus','Metestrus'})
% legend('location','southwest')
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % Functional 2-sample F-test
% y1 = [Dildh; Pildh; Eildh];
% yy = [A, y1];
% [ILDHstat.Stage]=ksampL2(yy,method,biasflag);
% clear y1 yy
% 
% %% Plot ILVH
% H2 = figure('units','normalized','outerposition',[0 0 1 1]);
% 
% p4 = shadedErrorBar(f,Milvh,{@mean,@std},'lineprops',{'color',metred});
% p4.mainLine.LineWidth = 3;
% p4.mainLine.DisplayName = 'Metestrus';
% hold on
% 
% p3 = shadedErrorBar(f,Eilvh,{@mean,@std},'lineprops',{'color',estyel});
% p3.mainLine.LineWidth = 3;
% p3.mainLine.DisplayName = 'Estrus';
% 
% p2 = shadedErrorBar(f,Pilvh,{@mean,@std},'lineprops',{'color',propurp});
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Proestrus';
% 
% p1 = shadedErrorBar(f,Dilvh,{@mean,@std},'lineprops',{'color',digreen});
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Diestrus';
% 
% axis square
% xlim([0.5 50])
% ylim([0 1])
% xticks(10:10:50)
% yticks([0 : 0.2 : 1])
% xlabel('Frequency (Hz)')
% ylabel('Magnitude-squared Coherence')
% title('mPFCIL - vHPC')
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % Functional 2-sample F-test
% y1 = [Dilvh; Pilvh; Eilvh];
% yy = [A, y1];
% [ILVHstat.Stage]=ksampL2(yy,method,biasflag);
% clear y1 yy
% 
% %% Plot ILPL
% H3 = figure('units','normalized','outerposition',[0 0 1 1]);
% 
% p4 = shadedErrorBar(f,Milpl,{@mean,@std},'lineprops',{'color',metred});
% p4.mainLine.LineWidth = 3;
% p4.mainLine.DisplayName = 'Metestrus';
% hold on
% 
% p3 = shadedErrorBar(f,Eilpl,{@mean,@std},'lineprops',{'color',estyel});
% p3.mainLine.LineWidth = 3;
% p3.mainLine.DisplayName = 'Estrus';
% 
% p2 = shadedErrorBar(f,Pilpl,{@mean,@std},'lineprops',{'color',propurp});
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Proestrus';
% 
% p1 = shadedErrorBar(f,Dilpl,{@mean,@std},'lineprops',{'color',digreen});
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Diestrus';
% 
% axis square
% xlim([0.5 50])
% ylim([0 1])
% xticks(10:10:50)
% yticks([0 : 0.2 : 1])
% xlabel('Frequency (Hz)')
% ylabel('Magnitude-squared Coherence')
% title('mPFCIL - mPFCPL')
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% 
% % Functional 2-sample F-test
% y1 = [Dilpl; Pilpl; Eilpl];
% yy = [A, y1];
% [ILPLstat.Stage]=ksampL2(yy,method,biasflag);
% clear y1 yy
% 
% %% Plot DH-VH
% H4 = figure('units','normalized','outerposition',[0 0 1 1]);
% p4 = shadedErrorBar(f,Mdhvh,{@mean,@std},'lineprops',{'color',metred});
% p4.mainLine.LineWidth = 3;
% p4.mainLine.DisplayName = 'Metestrus';
% hold on
% 
% p3 = shadedErrorBar(f,Edhvh,{@mean,@std},'lineprops',{'color',estyel});
% p3.mainLine.LineWidth = 3;
% p3.mainLine.DisplayName = 'Estrus';
% 
% p2 = shadedErrorBar(f,Pdhvh,{@mean,@std},'lineprops',{'color',propurp});
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Proestrus';
% 
% p1 = shadedErrorBar(f,Ddhvh,{@mean,@std},'lineprops',{'color',digreen});
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Diestrus';
% 
% axis square
% xlim([0.5 50])
% ylim([0 1])
% xticks(10:10:50)
% yticks([0 : 0.2 : 1])
% xlabel('Frequency (Hz)')
% ylabel('Magnitude-squared Coherence')
% title('dHPC - vHPC')
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % Functional 2-sample F-test
% y1 = [Ddhvh; Pdhvh; Edhvh];
% yy = [A, y1];
% [DHVHstat.Stage]=ksampL2(yy,method,biasflag);
% clear y1 yy
% 
% %% Plot DH-PL
% H5 = figure('units','normalized','outerposition',[0 0 1 1]);
% p4 = shadedErrorBar(f,Mdhpl,{@mean,@std},'lineprops',{'color',metred});
% p4.mainLine.LineWidth = 3;
% p4.mainLine.DisplayName = 'Metestrus';
% hold on
% 
% p3 = shadedErrorBar(f,Edhpl,{@mean,@std},'lineprops',{'color',estyel});
% p3.mainLine.LineWidth = 3;
% p3.mainLine.DisplayName = 'Estrus';
% 
% p2 = shadedErrorBar(f,Pdhpl,{@mean,@std},'lineprops',{'color',propurp});
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Proestrus';
% 
% p1 = shadedErrorBar(f,Ddhpl,{@mean,@std},'lineprops',{'color',digreen});
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Diestrus';
% 
% axis square
% xlim([0.5 50])
% ylim([0 1])
% xticks(10:10:50)
% yticks([0 : 0.2 : 1])
% xlabel('Frequency (Hz)')
% ylabel('Magnitude-squared Coherence')
% title('dHPC - mPFCPL')
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % Functional 2-sample F-test
% y1 = [Ddhpl; Pdhpl; Edhpl];
% yy = [A, y1];
% [DHPLstat.Stage]=ksampL2(yy,method,biasflag);
% clear y1 yy
% 
% %% Plot VH-PL
% H6 = figure('units','normalized','outerposition',[0 0 1 1]);
% p4 = shadedErrorBar(f,Mvhpl,{@mean,@std},'lineprops',{'color',metred});
% p4.mainLine.LineWidth = 3;
% p4.mainLine.DisplayName = 'Metestrus';
% hold on
% 
% p3 = shadedErrorBar(f,Evhpl,{@mean,@std},'lineprops',{'color',estyel});
% p3.mainLine.LineWidth = 3;
% p3.mainLine.DisplayName = 'Estrus';
% 
% p2 = shadedErrorBar(f,Pvhpl,{@mean,@std},'lineprops',{'color',propurp});
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Proestrus';
% 
% p1 = shadedErrorBar(f,Dvhpl,{@mean,@std},'lineprops',{'color',digreen});
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Diestrus';
% 
% axis square
% xlim([0.5 50])
% ylim([0 1])
% xticks(10:10:50)
% yticks([0 : 0.2 : 1])
% xlabel('Frequency (Hz)')
% ylabel('Magnitude-squared Coherence')
% title('vHPC - mPFCPL')
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % Functional 2-sample F-test
% y1 = [Dvhpl; Pvhpl; Evhpl];
% yy = [A, y1];
% [VHPLstat.Stage]=ksampL2(yy,method,biasflag);
% clear y1 yy
% 
% %% Save figures
% cd('K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\figs\PowSpec_ReducedChannels\BL\FunctionalAnova')
% saveas(H1,'ILDHms-Stage-SD-5to15.tif')
% saveas(H1,'ILDHms-Stage-SD-5to15.fig')
% close(H1); clear H1
% 
% saveas(H2,'ILVHms-Stage-SD-5to15.tif')
% saveas(H2,'ILVHms-Stage-SD-5to15.fig')
% close(H2); clear H2
% 
% saveas(H3,'ILPLms-Stage-SD-5to15.tif')
% saveas(H3,'ILPLms-Stage-SD-5to15.fig')
% close(H3); clear H3
% 
% saveas(H4,'DHVHms-Stage-SD-5to15.tif')
% saveas(H4,'DHVHms-Stage-SD-5to15.fig')
% close(H4); clear H4
% 
% saveas(H5,'DHPLms-Stage-SD-5to15.tif')
% saveas(H5,'DHPLms-Stage-SD-5to15.fig')
% close(H5); clear H5
% 
% saveas(H6,'VHPLms-Stage-SD-5to15.tif')
% saveas(H6,'VHPLms-Stage-SD-5to15.fig')
% close(H6); clear H6
end %function
