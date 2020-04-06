function [H,stat] = PlotBoot_mscohereMvHorms(f,A,Dx,Px,Ex,Mx)
% [H,stat] = PlotBoot_mscohereMvHorms(f,A,Dx,Px,Ex,Mx)
% 
% Plots Power spectra: Males vs females/hormone state, with SEM shading 
% representing subjects, w/females separated each hormone category (D,E,P)
% 
% Calls on scripts:
%   - shadedErrorBar.m  (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
%   - ksampL2.m 
% 
% Calls data produced by:
%   - Format4Bootstrap_mscohereHormones.m: 'Female_mscohere-BL-5to15_boot.mat' (called w/in Thesis6_Format4Bootstrap_5to15.m)
%   - Format4Bootstrap_mscohere.m: 'mscohere-BL-5to15_boot.mat' (called within Thesis6_Format4Bootstrap_5to15.m)
% 
% Called by:
%   - Thesis6_Format4Bootstrap_5to15.m
% 
% KJS init: 2020-04-06

%% Setup

% Params for ksampL2.m
method = 1;
biasflag = 1;

% Color maps
maleblue = [0 0 0]/255; %MALES  (black)
digreen = [214 156 78]/255; %DIESTRUS FEMALES
propurp = [4 108 154]/255; %PROESTRUS FEMALES 
estyel = [171 221 222]/255; % ESTROUS FEMALES

%% Plot
H = figure('units','normalized','outerposition',[0 0 1 1]);
p3 = shadedErrorBar(f,Ex,{@mean,@(x) std(Ex)/sqrt(size(Ex,1))},'lineprops',{'color',estyel});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(f,Px,{@mean,@(x) std(Px)/sqrt(size(Px,1))},'lineprops',{'color',propurp}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(f,Dx,{@mean,@(x) std(Dx)/sqrt(size(Dx,1))},'lineprops',{'color',digreen}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(f,Mx,{@mean,@(x) std(Mx)/sqrt(size(Mx,1))},'lineprops',{'color',maleblue});
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([0.5 50])
ylim([0 1])
xticks(10:10:50)
yticks([0 : 0.2 : 1])
xlabel('Frequency (Hz)')
ylabel(sprintf('Magnitude^2 coherence'))
legend([p4.mainLine, p1.mainLine, p2.mainLine, p3.mainLine],{'Male','Diestrus','Proestrus','Estrus'})
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.75)

%% One-way ANOVA for functional data: Main-effects test
y1 = [Dx; Px; Ex; Mx];
yy = [A, y1];
[stat.Stage]=ksampL2(yy,method,biasflag);
clear y1 yy

% 
% %% Plot mPFC-PL
% H2 = figure('units','normalized','outerposition',[0 0 1 1]);
% p4 = shadedErrorBar(f,pow2db(Mpl),{@mean,@(f) std(pow2db(Mpl))/sqrt(size(Mpl,1))},'lineprops',{'color',metred}); 
% p4.mainLine.LineWidth = 3;
% p4.mainLine.DisplayName = 'Metestrus';
% hold on
% 
% p3 = shadedErrorBar(f,pow2db(Epl),{@mean,@(f) std(pow2db(Epl))/sqrt(size(Epl,1))},'lineprops',{'color',estyel}); 
% p3.mainLine.LineWidth = 3;
% p3.mainLine.DisplayName = 'Estrus';
% 
% p2 = shadedErrorBar(f,pow2db(Ppl),{@mean,@(f) std(pow2db(Ppl))/sqrt(size(Ppl,1))},'lineprops',{'color',propurp}); 
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Proestrus';
% 
% p1 = shadedErrorBar(f,pow2db(Dpl),{@mean,@(f) std(pow2db(Dpl))/sqrt(size(Dpl,1))},'lineprops',{'color',digreen}); 
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Diestrus';
% 
% axis square
% xlim([0.5 100])
% xticks(10:10:100)
% xlabel('Frequency (Hz)')
% ylabel('Power (dB)')
% title('mPFC-PL')
% 
% % legend([p1.mainLine, p2.mainLine, p3.mainLine, p4.mainLine],{'Diestrus','Proestrus','Estrus','Metestrus'})
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % One-way ANOVA for functional data: Main-effects test
% y1 = [Dpl; Ppl; Epl];
% yy = [A, y1];
% [PLstat.Stage]=ksampL2(yy,method,biasflag);
% clear y1 yy
% 
% 
% %% Plot dHPC
% H3 = figure('units','normalized','outerposition',[0 0 1 1]);
% 
% p4 = shadedErrorBar(f,pow2db(Mdh),{@mean,@(f) std(pow2db(Mdh))/sqrt(size(Mdh,1))},'lineprops',{'color',metred}); 
% p4.mainLine.LineWidth = 3;
% p4.mainLine.DisplayName = 'Metestrus';
% hold on
% 
% p3 = shadedErrorBar(f,pow2db(Edh),{@mean,@(f) std(pow2db(Edh))/sqrt(size(Edh,1))},'lineprops',{'color',estyel}); 
% p3.mainLine.LineWidth = 3;
% p3.mainLine.DisplayName = 'Estrus';
% 
% p2 = shadedErrorBar(f,pow2db(Pdh),{@mean,@(f) std(pow2db(Pdh))/sqrt(size(Pdh,1))},'lineprops',{'color',propurp}); 
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Proestrus';
% 
% p1 = shadedErrorBar(f,pow2db(Ddh),{@mean,@(f) std(pow2db(Ddh))/sqrt(size(Ddh,1))},'lineprops',{'color',digreen}); 
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Diestrus';
% 
% axis square
% xlim([0.5 100])
% xticks(10:10:100)
% xlabel('Frequency (Hz)')
% ylabel('Power (dB)')
% title('dHPC')
% 
% % legend([p1.mainLine, p2.mainLine, p3.mainLine, p4.mainLine],{'Diestrus','Proestrus','Estrus','Metestrus'})
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % One-way ANOVA for functional data: Main-effects test
% y1 = [Ddh; Pdh; Edh];
% yy = [A, y1];
% [DHstat.Stage]=ksampL2(yy,method,biasflag);
% clear y1 yy
% 
% %% Plot vHPC
% H4 = figure('units','normalized','outerposition',[0 0 1 1]);
% 
% p4 = shadedErrorBar(f,pow2db(Mvh),{@mean,@(f) std(pow2db(Mvh))/sqrt(size(Mvh,1))},'lineprops',{'color',metred}); 
% p4.mainLine.LineWidth = 3;
% p4.mainLine.DisplayName = 'Metestrus';
% hold on
% 
% p3 = shadedErrorBar(f,pow2db(Evh),{@mean,@(f) std(pow2db(Evh))/sqrt(size(Evh,1))},'lineprops',{'color',estyel}); 
% p3.mainLine.LineWidth = 3;
% p3.mainLine.DisplayName = 'Estrus';
% 
% p2 = shadedErrorBar(f,pow2db(Pvh),{@mean,@(f) std(pow2db(Pvh))/sqrt(size(Pvh,1))},'lineprops',{'color',propurp}); 
% p2.mainLine.LineWidth = 3;
% p2.mainLine.DisplayName = 'Proestrus';
% 
% p1 = shadedErrorBar(f,pow2db(Dvh),{@mean,@(f) std(pow2db(Dvh))/sqrt(size(Dvh,1))},'lineprops',{'color',digreen}); 
% p1.mainLine.LineWidth = 3;
% p1.mainLine.DisplayName = 'Diestrus';
% 
% axis square
% xlim([0.5 100])
% xticks(10:10:100)
% xlabel('Frequency (Hz)')
% ylabel('Power (dB)')
% title('vHPC')
% 
% % legend([p1.mainLine, p2.mainLine, p3.mainLine, p4.mainLine],{'Diestrus','Proestrus','Estrus','Metestrus'})
% set(gca,'fontsize',26)
% box off
% set(gca,'TitleFontSizeMultiplier',1.75)
% 
% % One-way ANOVA for functional data: Main-effects test
% y1 = [Dvh; Pvh; Evh];
% yy = [A, y1];
% [VHstat.Stage]=ksampL2(yy,method,biasflag);
% clear y1 yy

end %function
