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

% Params for ksampL2.m & twosampF.m
method = 1;
biasflag = 1;
parflag = 1;

% Color maps
Mcol = [0         0.2980    0.2980]; %male
Dcol = [0.6980    0.5137         0]; %diestrus female
Pcol = [0.3490    0.0392         0]; %proestrus female
Ecol = [1.0000    0.8863    0.2118]; %estrus female

%% Plot
H = figure('units','normalized','outerposition',[0 0 1 1]);
p3 = shadedErrorBar(f,Ex,{@mean,@(x) std(Ex)/sqrt(size(Ex,1))},'lineprops',{'color',Ecol});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(f,Px,{@mean,@(x) std(Px)/sqrt(size(Px,1))},'lineprops',{'color',Pcol}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(f,Dx,{@mean,@(x) std(Dx)/sqrt(size(Dx,1))},'lineprops',{'color',Dcol}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(f,Mx,{@mean,@(x) std(Mx)/sqrt(size(Mx,1))},'lineprops',{'color',Mcol});
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([0.5 100])
ylim([0 1])
xticks(10:10:100)
yticks(0 : 0.2 : 1)
xlabel('Frequency (Hz)')
ylabel(sprintf('Magnitude^2 coherence'))
legend([p4.mainLine, p1.mainLine, p2.mainLine, p3.mainLine],{'Male','Diestrus','Proestrus','Estrus'}); 
legend('boxoff')
box off
set(gca,'FontName','Arial','fontsize',24,'TitleFontSizeMultiplier',2)

%% One-way ANOVA for functional data: Main-effects test
y1 = [Dx; Px; Ex; Mx];
yy = [A, y1];
[stat.MvHorms]=ksampL2(yy,method,biasflag); %ANOVA
[stat.MvD] = twosampF(Mx,Dx,method,parflag); %posthoc: Male v Diest
[stat.MvP] = twosampF(Mx,Px,method,parflag); %posthoc: Male v Proest
[stat.MvE] = twosampF(Mx,Ex,method,parflag); %posthoc: Male v Est
clear y1 yy

end %function
