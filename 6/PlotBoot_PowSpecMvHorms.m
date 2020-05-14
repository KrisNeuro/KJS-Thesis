%PlotBoot_PowSpecMvHorms
% [H1,H2,H3,H4,ILstat,PLstat,DHstat,VHstat] = PlotBoot_PowSpecMvHorms(f,A,Dil,Pil,Eil,Mil,Ddh,Pdh,Edh,Mdh,Dvh,Pvh,Evh,Mvh,Dpl,Ppl,Epl,Mpl)
% 
% Plots Power spectra: Males vs females/hormone state, with shading 
% representing SEM, calculated within-subject for each hormone category
% (D,E,P). Metestrus is excluded.
% 
% Calls on scripts:
%   - shadedErrorBar.m  (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
%   - ksampL2.m 
% 
% Calls data produced by:
%   - PowSpec5to15_Hormones.m: 'PxxHormones-BL-5to15.mat' (called w/in Thesis6_Format4Bootstrap_5to15.m)
%   - Male Pxx data: Pxx-BL-5to15.mat
% 
% Called by:
%   - Thesis6_Format4Bootstrap_5to15.m
% 
% KJS init: 2020-04-06 

function [H1,H2,H3,H4,ILstat,PLstat,DHstat,VHstat] = PlotBoot_PowSpecMvHorms(f,A,Dil,Pil,Eil,Mil,Ddh,Pdh,Edh,Mdh,Dvh,Pvh,Evh,Mvh,Dpl,Ppl,Epl,Mpl)

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

%% Plot mPFC-IL
H1 = figure('units','normalized','outerposition',[0 0 1 1]);

p3 = shadedErrorBar(f,pow2db(Eil),{@mean,@(x) std(pow2db(Eil))/sqrt(size(Eil,1))},'lineprops',{'color',Ecol});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(f,pow2db(Pil),{@mean,@(x) std(pow2db(Pil))/sqrt(size(Pil,1))},'lineprops',{'color',Pcol}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(f,pow2db(Dil),{@mean,@(x) std(pow2db(Dil))/sqrt(size(Dil,1))},'lineprops',{'color',Dcol}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(f,pow2db(Mil),{@mean,@(x) std(pow2db(Mil))/sqrt(size(Mil,1))},'lineprops',{'color',Mcol}); 
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('IL')
legend([p4.mainLine, p1.mainLine, p2.mainLine, p3.mainLine],{'Male','Diestrus','Proestrus','Estrus'});
legend('boxoff')
box off
set(gca,'FontName','Arial','fontsize',24,'TitleFontSizeMultiplier',2)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dil; Pil; Eil; Mil];
yy = [A, y1];
[ILstat.MvHorms]=ksampL2(yy,method,biasflag); %ANOVA - main effect
[ILstat.MvD] = twosampF(Dil,Mil,method,parflag); %posthoc: Diest v Male
[ILstat.MvP] = twosampF(Pil,Mil,method,parflag); %posthoc: Proest v Male
[ILstat.MvE] = twosampF(Eil,Mil,method,parflag); %posthoc: Est v Male
clear y1 yy

%% Plot PrL (mPFC-PL)
H2 = figure('units','normalized','outerposition',[0 0 1 1]);

p3 = shadedErrorBar(f,pow2db(Epl),{@mean,@(x) std(pow2db(Epl))/sqrt(size(Epl,1))},'lineprops',{'color',Ecol}); 
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(f,pow2db(Ppl),{@mean,@(x) std(pow2db(Ppl))/sqrt(size(Ppl,1))},'lineprops',{'color',Pcol}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(f,pow2db(Dpl),{@mean,@(x) std(pow2db(Dpl))/sqrt(size(Dpl,1))},'lineprops',{'color',Dcol}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(f,pow2db(Mpl),{@mean,@(x) std(pow2db(Mpl))/sqrt(size(Mpl,1))},'lineprops',{'color',Mcol}); 
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('PrL')
legend([p4.mainLine, p1.mainLine, p2.mainLine, p3.mainLine],{'Male','Diestrus','Proestrus','Estrus'}); 
legend('boxoff')
box off
set(gca,'FontName','Arial','fontsize',24,'TitleFontSizeMultiplier',2)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dpl; Ppl; Epl; Mpl];
yy = [A, y1];
[PLstat.MvHorms]=ksampL2(yy,method,biasflag); %ANOVA
[PLstat.MvD] = twosampF(Dpl,Mpl,method,parflag); %posthoc: Diest v Male
[PLstat.MvP] = twosampF(Ppl,Mpl,method,parflag); %posthoc: Proest v Male
[PLstat.MvE] = twosampF(Epl,Mpl,method,parflag); %posthoc: Est v Male
clear y1 yy


%% Plot dHPC
H3 = figure('units','normalized','outerposition',[0 0 1 1]);

p3 = shadedErrorBar(f,pow2db(Edh),{@mean,@(x) std(pow2db(Edh))/sqrt(size(Edh,1))},'lineprops',{'color',Ecol}); 
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(f,pow2db(Pdh),{@mean,@(x) std(pow2db(Pdh))/sqrt(size(Pdh,1))},'lineprops',{'color',Pcol}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(f,pow2db(Ddh),{@mean,@(x) std(pow2db(Ddh))/sqrt(size(Ddh,1))},'lineprops',{'color',Dcol}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(f,pow2db(Mdh),{@mean,@(x) std(pow2db(Mdh))/sqrt(size(Mdh,1))},'lineprops',{'color',Mcol}); 
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('dHPC')
legend([p4.mainLine, p1.mainLine, p2.mainLine, p3.mainLine],{'Male','Diestrus','Proestrus','Estrus'}); 
legend('boxoff')
box off
set(gca,'FontName','Arial','fontsize',24,'TitleFontSizeMultiplier',2)

% One-way ANOVA for functional data: Main-effects test
y1 = [Ddh; Pdh; Edh; Mdh];
yy = [A, y1];
[DHstat.MvHorms]=ksampL2(yy,method,biasflag); %ANOVA
[DHstat.MvD] = twosampF(Ddh,Mdh,method,parflag); %posthoc: Diest v Male
[DHstat.MvP] = twosampF(Pdh,Mdh,method,parflag); %posthoc: Proest v Male
[DHstat.MvE] = twosampF(Edh,Mdh,method,parflag); %posthoc: Est v Male
clear y1 yy

%% Plot vHPC
H4 = figure('units','normalized','outerposition',[0 0 1 1]);

p3 = shadedErrorBar(f,pow2db(Evh),{@mean,@(x) std(pow2db(Evh))/sqrt(size(Evh,1))},'lineprops',{'color',Ecol}); 
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(f,pow2db(Pvh),{@mean,@(x) std(pow2db(Pvh))/sqrt(size(Pvh,1))},'lineprops',{'color',Pcol}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(f,pow2db(Dvh),{@mean,@(x) std(pow2db(Dvh))/sqrt(size(Dvh,1))},'lineprops',{'color',Dcol}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(f,pow2db(Mvh),{@mean,@(x) std(pow2db(Mvh))/sqrt(size(Mvh,1))},'lineprops',{'color',Mcol}); 
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('vHPC')
legend([p4.mainLine, p1.mainLine, p2.mainLine, p3.mainLine],{'Male','Diestrus','Proestrus','Estrus'}); 
legend('boxoff')
box off
set(gca,'FontName','Arial','fontsize',24,'TitleFontSizeMultiplier',2)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dvh; Pvh; Evh; Mvh];
yy = [A, y1];
[VHstat.MvHorms]=ksampL2(yy,method,biasflag); %ANOVA
[VHstat.MvD] = twosampF(Dvh,Mvh,method,parflag); %posthoc: Diest v Male
[VHstat.MvP] = twosampF(Pvh,Mvh,method,parflag); %posthoc: Proest v Male
[VHstat.MvE] = twosampF(Evh,Mvh,method,parflag); %posthoc: Est v Male
clear y1 yy

end
