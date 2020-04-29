%PlotBoot_PowSpecHormones
% [H1,H2,H3,H4,ILstat,PLstat,DHstat,VHstat] = PlotBoot_PowSpecHormones(f,A,Dil,Pil,Eil,Mil,Ddh,Pdh,Edh,Mdh,Dvh,Pvh,Evh,Mvh,Dpl,Ppl,Epl,Mpl)
% 
% Plots Power spectra: Females only, effects of hormone state, with shading 
% representing SEM, calculated within-subject for each hormone category (D,E,P)
% 
% Calls on scripts:
%   - shadedErrorBar.m  (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
%   - ksampL2.m 
% 
% Calls data produced by:
%   - PowSpec5to15_Hormones.m: 'PxxHormones-BL-5to15.mat' (called w/in Thesis6_Format4Bootstrap_5to15.m)
% 
% Called by:
%   - Thesis6_Format4Bootstrap_5to15.m
% 
% KJS init: 2020-02-19 as independent function for compatibility with Thesis6_Format4Bootstrap_5to15

function [H1,H2,H3,H4,ILstat,PLstat,DHstat,VHstat] = PlotBoot_PowSpecHormones(f,A,Dil,Pil,Eil,Mil,Ddh,Pdh,Edh,Mdh,Dvh,Pvh,Evh,Mvh,Dpl,Ppl,Epl,Mpl)

%% Setup

% Params for ksampL2.m & twosampF.m
method = 1;
biasflag = 1;
parflag = 1;

% Color maps
Dcol = [0.6980    0.5137         0]; %diestrus female
Pcol = [0.3490    0.0392         0]; %proestrus female
Ecol = [1.0000    0.8863    0.2118]; %estrus female
Mcol = [0.8627    0.6314    0.0549]; %metestrus female

%% FEMALES: Estrous stages

%% Plot mPFC-IL
H1 = figure('units','normalized','outerposition',[0 0 1 1]);

p4 = shadedErrorBar(f,pow2db(Mil),{@mean,@(x) std(pow2db(Mil))/sqrt(size(Mil,1))},'lineprops',{'color',Mcol});
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Metestrus';
hold on

p3 = shadedErrorBar(f,pow2db(Eil),{@mean,@(x) std(pow2db(Eil))/sqrt(size(Eil,1))},'lineprops',{'color',Ecol});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';

p2 = shadedErrorBar(f,pow2db(Pil),{@mean,@(x) std(pow2db(Pil))/sqrt(size(Pil,1))},'lineprops',{'color',Pcol});
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(f,pow2db(Dil),{@mean,@(x) std(pow2db(Dil))/sqrt(size(Dil,1))},'lineprops',{'color',Dcol});
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('IL')

legend([p1.mainLine, p2.mainLine, p3.mainLine, p4.mainLine],{'Diestrus','Proestrus','Estrus','Metestrus'})
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.75)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dil; Pil; Eil];
yy = [A, y1];
[ILstat.Stage]=ksampL2(yy,method,biasflag);%ANOVA
[ILstat.DvP] = twosampF(Dil,Pil,method,parflag); %posthoc: Diest v Proest
[ILstat.DvE] = twosampF(Dil,Eil,method,parflag); %posthoc: Diest v Est
[ILstat.PvE] = twosampF(Pil,Eil,method,parflag); %posthoc: Prost v Est
clear y1 yy

%% Plot mPFC-PL
H2 = figure('units','normalized','outerposition',[0 0 1 1]);
p4 = shadedErrorBar(f,pow2db(Mpl),{@mean,@(x) std(pow2db(Mpl))/sqrt(size(Mpl,1))},'lineprops',{'color',Mcol}); 
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Metestrus';
hold on

p3 = shadedErrorBar(f,pow2db(Epl),{@mean,@(x) std(pow2db(Epl))/sqrt(size(Epl,1))},'lineprops',{'color',Ecol}); 
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';

p2 = shadedErrorBar(f,pow2db(Ppl),{@mean,@(x) std(pow2db(Ppl))/sqrt(size(Ppl,1))},'lineprops',{'color',Pcol}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(f,pow2db(Dpl),{@mean,@(x) std(pow2db(Dpl))/sqrt(size(Dpl,1))},'lineprops',{'color',Dcol}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('PrL')

legend([p1.mainLine, p2.mainLine, p3.mainLine, p4.mainLine],{'Diestrus','Proestrus','Estrus','Metestrus'})
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.75)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dpl; Ppl; Epl];
yy = [A, y1];
[PLstat.Stage]=ksampL2(yy,method,biasflag);%ANOVA
[PLstat.DvP] = twosampF(Dpl,Ppl,method,parflag); %posthoc: Diest v Proest
[PLstat.DvE] = twosampF(Dpl,Epl,method,parflag); %posthoc: Diest v Est
[PLstat.PvE] = twosampF(Ppl,Epl,method,parflag); %posthoc: Prost v Est
clear y1 yy


%% Plot dHPC
H3 = figure('units','normalized','outerposition',[0 0 1 1]);

p4 = shadedErrorBar(f,pow2db(Mdh),{@mean,@(x) std(pow2db(Mdh))/sqrt(size(Mdh,1))},'lineprops',{'color',Mcol}); 
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Metestrus';
hold on

p3 = shadedErrorBar(f,pow2db(Edh),{@mean,@(x) std(pow2db(Edh))/sqrt(size(Edh,1))},'lineprops',{'color',Ecol}); 
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';

p2 = shadedErrorBar(f,pow2db(Pdh),{@mean,@(x) std(pow2db(Pdh))/sqrt(size(Pdh,1))},'lineprops',{'color',Pcol}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(f,pow2db(Ddh),{@mean,@(x) std(pow2db(Ddh))/sqrt(size(Ddh,1))},'lineprops',{'color',Dcol}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('dHPC')

legend([p1.mainLine, p2.mainLine, p3.mainLine, p4.mainLine],{'Diestrus','Proestrus','Estrus','Metestrus'})
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.75)

% One-way ANOVA for functional data: Main-effects test
y1 = [Ddh; Pdh; Edh];
yy = [A, y1];
[DHstat.Stage]=ksampL2(yy,method,biasflag);%ANOVA
[DHstat.DvP] = twosampF(Ddh,Pdh,method,parflag); %posthoc: Diest v Proest
[DHstat.DvE] = twosampF(Ddh,Edh,method,parflag); %posthoc: Diest v Est
[DHstat.PvE] = twosampF(Pdh,Edh,method,parflag); %posthoc: Prost v Est
clear y1 yy

%% Plot vHPC
H4 = figure('units','normalized','outerposition',[0 0 1 1]);

p4 = shadedErrorBar(f,pow2db(Mvh),{@mean,@(x) std(pow2db(Mvh))/sqrt(size(Mvh,1))},'lineprops',{'color',Mcol}); 
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Metestrus';
hold on

p3 = shadedErrorBar(f,pow2db(Evh),{@mean,@(x) std(pow2db(Evh))/sqrt(size(Evh,1))},'lineprops',{'color',Ecol}); 
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';

p2 = shadedErrorBar(f,pow2db(Pvh),{@mean,@(x) std(pow2db(Pvh))/sqrt(size(Pvh,1))},'lineprops',{'color',Pcol}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(f,pow2db(Dvh),{@mean,@(x) std(pow2db(Dvh))/sqrt(size(Dvh,1))},'lineprops',{'color',Dcol}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('vHPC')

legend([p1.mainLine, p2.mainLine, p3.mainLine, p4.mainLine],{'Diestrus','Proestrus','Estrus','Metestrus'})
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.75)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dvh; Pvh; Evh];
yy = [A, y1];
[VHstat.Stage]=ksampL2(yy,method,biasflag); %ANOVA
[VHstat.DvP] = twosampF(Dvh,Pvh,method,parflag); %posthoc: Diest v Proest
[VHstat.DvE] = twosampF(Dvh,Evh,method,parflag); %posthoc: Diest v Est
[VHstat.PvE] = twosampF(Pvh,Evh,method,parflag); %posthoc: Prost v Est
clear y1 yy

end
