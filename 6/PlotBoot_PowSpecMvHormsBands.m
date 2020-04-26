%PlotBoot_PowSpecMvHormsBands
%   [h,stat] = PlotBoot_PowSpecMvHormsBands(f,Dx,Px,Ex,Mx,stat,A)
% 
% Plots Power spectra: Males vs females/ hormone state, with shading 
% representing SEM, calculated within-subject for each hormone category (D,E,P)
% Subplots indicate frequency bands of interest: Theta, delta, gamma, beta
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

function [h,stat] = PlotBoot_PowSpecMvHormsBands(f,Dx,Px,Ex,Mx,stat,A)
%% Setup

% Params for ksampL2.m
method = 1;
biasflag = 1;

% Color maps
Mcol = [0         0.2980    0.2980]; %male
Dcol = [0.6980    0.5137         0]; %diestrus female
Pcol = [0.3490    0.0392         0]; %proestrus female
Ecol = [1.0000    0.8863    0.2118]; %estrus female

% Transparency of histogram bars, specified as a scalar value between 0 and 1 inclusive
Mfa = 0.72; %male
Dfa = 0.38; %diestrus
Pfa = 1; %proestrus
Efa = 0.58; %estrus

%% Designate frequency bands

% Theta
t1 = knnsearch(f,4);
t2 = knnsearch(f,12);
theta = f(t1:t2); %theta band frequencies

% Gamma
g1 = knnsearch(f,30);
g2 = knnsearch(f,80);
gamma = f(g1:g2); %gamma band frequencies

% Delta 
d1 = knnsearch(f,1);
d2 = knnsearch(f,4);
delta = f(d1:d2); %delta band frequencies

% Beta
b1 = knnsearch(f,15);
b2 = knnsearch(f,30);
beta = f(b1:b2);

%% Plot frequency bands of interest: Delta, Theta, Gamma, Beta
[h] = figure('units','normalized','position',[0.2,0,0.597222222222222,1]);

%% Delta
subplot(221)

p2 = shadedErrorBar(delta,pow2db(Px(:,d1:d2)),{@mean,@(x) std(pow2db(Px(:,d1:d2)))/sqrt(size(Px,1))},'lineprops',{'color',Pcol}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';
hold on

p3 = shadedErrorBar(delta,pow2db(Ex(:,d1:d2)),{@mean,@(x) std(pow2db(Ex(:,d1:d2)))/sqrt(size(Ex,1))},'lineprops',{'color',Ecol});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';

p1 = shadedErrorBar(delta,pow2db(Dx(:,d1:d2)),{@mean,@(x) std(pow2db(Dx(:,d1:d2)))/sqrt(size(Dx,1))},'lineprops',{'color',Dcol}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(delta,pow2db(Mx(:,d1:d2)),{@mean,@(x) std(pow2db(Mx(:,d1:d2)))/sqrt(size(Mx,1))},'lineprops',{'color',Mcol});
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([0.5 4.5])
xticks(1:4)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('Delta band')
legend([p4.mainLine, p2.mainLine, p1.mainLine, p3.mainLine],{'Male','Proestrus','Diestrus','Estrus'})
set(gca,'fontsize',14)
box off
set(gca,'TitleFontSizeMultiplier',1.5)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dx(:,d1:d2); Px(:,d1:d2); Ex(:,d1:d2); Mx(:,d1:d2)];
yy = [A, y1];
[stat.delta]=ksampL2(yy,method,biasflag);
clear y1 yy


%% Theta
subplot(222)
p3 = shadedErrorBar(theta,pow2db(Ex(:,t1:t2)),{@mean,@(x) std(pow2db(Ex(:,t1:t2)))/sqrt(size(Ex,1))},'lineprops',{'color',estyel});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(theta,pow2db(Px(:,t1:t2)),{@mean,@(x) std(pow2db(Px(:,t1:t2)))/sqrt(size(Px,1))},'lineprops',{'color',propurp}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(theta,pow2db(Dx(:,t1:t2)),{@mean,@(x) std(pow2db(Dx(:,t1:t2)))/sqrt(size(Dx,1))},'lineprops',{'color',digreen}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(theta,pow2db(Mx(:,t1:t2)),{@mean,@(x) std(pow2db(Mx(:,t1:t2)))/sqrt(size(Mx,1))},'lineprops',{'color',maleblue}); 
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Metestrus';

axis square
xlim([3.5 12.5])
xticks(4:12)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('Theta band')
% legend([p4.mainLine, p1.mainLine, p2.mainLine, p3.mainLine],{'Male','Diestrus','Proestrus','Estrus'})
% legend('location','southwest')
set(gca,'fontsize',14)
box off
set(gca,'TitleFontSizeMultiplier',1.5)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dx(:,t1:t2); Px(:,t1:t2); Ex(:,t1:t2); Mx(:,t1:t2)];
yy = [A, y1];
[stat.theta]=ksampL2(yy,method,biasflag);
clear y1 yy

%% Beta
subplot(223)
p3 = shadedErrorBar(beta,pow2db(Ex(:,b1:b2)),{@mean,@(x) std(pow2db(Ex(:,b1:b2)))/sqrt(size(Ex,1))},'lineprops',{'color',estyel});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(beta,pow2db(Px(:,b1:b2)),{@mean,@(x) std(pow2db(Px(:,b1:b2)))/sqrt(size(Px,1))},'lineprops',{'color',propurp}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(beta,pow2db(Dx(:,b1:b2)),{@mean,@(x) std(pow2db(Dx(:,b1:b2)))/sqrt(size(Dx,1))},'lineprops',{'color',digreen}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(beta,pow2db(Mx(:,b1:b2)),{@mean,@(x) std(pow2db(Mx(:,b1:b2)))/sqrt(size(Mx,1))},'lineprops',{'color',maleblue});
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([14.5 30.5])
xticks(15:5:30)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('Beta band')
% legend([p4.mainLine, p1.mainLine, p2.mainLine, p3.mainLine],{'Male','Diestrus','Proestrus','Estrus'})
set(gca,'fontsize',14)
box off
set(gca,'TitleFontSizeMultiplier',1.5)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dx(:,b1:b2); Px(:,b1:b2); Ex(:,b1:b2); Mx(:,b1:b2)];
yy = [A, y1];
[stat.beta]=ksampL2(yy,method,biasflag);
clear y1 yy

%% Gamma (broadband) 
subplot(224)
p3 = shadedErrorBar(gamma,pow2db(Ex(:,g1:g2)),{@mean,@(x) std(pow2db(Ex(:,g1:g2)))/sqrt(size(Ex,1))},'lineprops',{'color',estyel});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(gamma,pow2db(Px(:,g1:g2)),{@mean,@(x) std(pow2db(Px(:,g1:g2)))/sqrt(size(Px,1))},'lineprops',{'color',propurp}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(gamma,pow2db(Dx(:,g1:g2)),{@mean,@(x) std(pow2db(Dx(:,g1:g2)))/sqrt(size(Dx,1))},'lineprops',{'color',digreen}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(gamma,pow2db(Mx(:,g1:g2)),{@mean,@(x) std(pow2db(Mx(:,g1:g2)))/sqrt(size(Mx,1))},'lineprops',{'color',maleblue});
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([25 85])
xticks(30:10:80)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('Gamma band')
% legend([p4.mainLine, p1.mainLine, p2.mainLine, p3.mainLine],{'Male','Diestrus','Proestrus','Estrus'})
set(gca,'fontsize',14)
box off
set(gca,'TitleFontSizeMultiplier',1.5)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dx(:,g1:g2); Px(:,g1:g2); Ex(:,g1:g2); Mx(:,g1:g2)];
yy = [A, y1];
[stat.gamma]=ksampL2(yy,method,biasflag);
clear y1 yy


end %function

