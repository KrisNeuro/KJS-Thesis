%PlotBoot_mscohereHormones
% [H,stat] = PlotBoot_mscohereHormones(f,A,Dx,Px,Ex,Mx)
% 
% Plots mscohere: Females only, effects of hormone state, with shading 
% representing SEM, calculated within-subject for each hormone category (D,E,P)
% 
% Calls on scripts:
%   - shadedErrorBar.m  (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
%   - ksampL2.m 
% 
% Calls data produced by:
%   - Format4Bootstrap_mscohereHormones.m: 'Female_mscohere-BL-5to15_boot.mat' (called w/in Thesis6_Format4Bootstrap_5to15.m)
% 
% Called by:
%   - Thesis6_Format4Bootstrap_5to15.m
% 
% KJS init: 2020-02-28 as function

function [H,stat] = PlotBoot_mscohereHormones(f,A,Dx,Px,Ex,Mx)
%% Setup

% Params for ksampL2.m
method = 1;
biasflag = 1;

% Color maps
propurp = [0.490079,0.06569,0.568432]; %purple - PROESTRUS FEMALES
estyel = [0.982021,0.630867,0.240179]; %yellow - ESTRUS FEMALES
metred = [0.906173,0.1939,0.445214]; %magenta? - METESTRUS FEMALES
digreen = [0.295855,0.606869,0.258899]; %deep green - DIESTRUS FEMALES

%% Plot
H = figure('units','normalized','outerposition',[0 0 1 1]);
p4 = shadedErrorBar(f,Mx,{@mean,@(x) std(Mx)/sqrt(size(Mx,1))},'lineprops',{'color',metred});
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Metestrus';
hold on

p3 = shadedErrorBar(f,Ex,{@mean,@(x) std(Ex)/sqrt(size(Ex,1))},'lineprops',{'color',estyel});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';

p2 = shadedErrorBar(f,Px,{@mean,@(x) std(Px)/sqrt(size(Px,1))},'lineprops',{'color',propurp}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(f,Dx,{@mean,@(x) std(Dx)/sqrt(size(Dx,1))},'lineprops',{'color',digreen}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

axis square
xlim([0.5 50])
ylim([0 1])
xticks(10:10:50)
yticks([0 : 0.2 : 1])
xlabel('Frequency (Hz)')
ylabel(sprintf('Magnitude^2 coherence'))
legend([p1.mainLine, p2.mainLine, p3.mainLine, p4.mainLine],{'Diestrus','Proestrus','Estrus','Metestrus'})
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.75)

%% One-way ANOVA for functional data: Main-effects test
y1 = [Dx; Px; Ex];
yy = [A, y1];
[stat.Stage]=ksampL2(yy,method,biasflag);
clear y1 yy

end %function