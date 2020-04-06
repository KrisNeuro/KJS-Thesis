function [h,stat] = PlotBoot_mscohereMvHormsBands(f,Dx,Px,Ex,Mx,stat,A)
%% Setup

% Params for ksampL2.m
method = 1;
biasflag = 1;

% Color maps
maleblue = [0 0 0]/255; %MALES  (black)
digreen = [214 156 78]/255; %DIESTRUS FEMALES
propurp = [4 108 154]/255; %PROESTRUS FEMALES 
estyel = [171 221 222]/255; % ESTROUS FEMALES

%% Designate frequency bands
if size(f,1)<size(f,2)
    f=f';
end
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
p3 = shadedErrorBar(delta,Ex(:,d1:d2),{@mean,@(x) std(Ex(:,d1:d2))/sqrt(size(Ex,1))},'lineprops',{'color',estyel});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(delta,Px(:,d1:d2),{@mean,@(x) std(Px(:,d1:d2))/sqrt(size(Px,1))},'lineprops',{'color',propurp}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(delta,Dx(:,d1:d2),{@mean,@(x) std(Dx(:,d1:d2))/sqrt(size(Dx,1))},'lineprops',{'color',digreen}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(delta,Mx(:,d1:d2),{@mean,@(x) std(Mx(:,d1:d2))/sqrt(size(Mx,1))},'lineprops',{'color',maleblue});
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([0.5 4.5])
xticks(1:4)
set(gca,'fontsize',14)
xlabel('Frequency (Hz)')
ylabel(sprintf('Magnitude^2 coherence'))
title('Delta band')
box off
set(gca,'TitleFontSizeMultiplier',1.5)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dx(:,d1:d2); Px(:,d1:d2); Ex(:,d1:d2); Mx(:,d1:d2)];
yy = [A, y1];
[stat.delta]=ksampL2(yy,method,biasflag);
clear y1 yy


%% Theta
subplot(222)
p3 = shadedErrorBar(theta,Ex(:,t1:t2),{@mean,@(x) std(Ex(:,t1:t2))/sqrt(size(Ex,1))},'lineprops',{'color',estyel});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(theta,Px(:,t1:t2),{@mean,@(x) std(Px(:,t1:t2))/sqrt(size(Px,1))},'lineprops',{'color',propurp}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(theta,Dx(:,t1:t2),{@mean,@(x) std(Dx(:,t1:t2))/sqrt(size(Dx,1))},'lineprops',{'color',digreen}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(theta,Mx(:,t1:t2),{@mean,@(x) std(Mx(:,t1:t2))/sqrt(size(Mx,1))},'lineprops',{'color',maleblue});
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([3.5 12.5])
xticks(4:12)
xlabel('Frequency (Hz)')
ylabel(sprintf('Magnitude^2 coherence'))
title('Theta band')
box off
set(gca,'fontsize',14)
set(gca,'TitleFontSizeMultiplier',1.5)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dx(:,t1:t2); Px(:,t1:t2); Ex(:,t1:t2); Mx(:,t1:t2)];
yy = [A, y1];
[stat.theta]=ksampL2(yy,method,biasflag);
clear y1 yy

%% Beta
subplot(223)
p3 = shadedErrorBar(beta,Ex(:,b1:b2),{@mean,@(x) std(Ex(:,b1:b2))/sqrt(size(Ex,1))},'lineprops',{'color',estyel});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(beta,Px(:,b1:b2),{@mean,@(x) std(Px(:,b1:b2))/sqrt(size(Px,1))},'lineprops',{'color',propurp}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(beta,Dx(:,b1:b2),{@mean,@(x) std(Dx(:,b1:b2))/sqrt(size(Dx,1))},'lineprops',{'color',digreen}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(beta,Mx(:,b1:b2),{@mean,@(x) std(Mx(:,b1:b2))/sqrt(size(Mx,1))},'lineprops',{'color',maleblue});
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([14.5 30.5])
xticks(15:5:30)
set(gca,'fontsize',14)
xlabel('Frequency (Hz)')
ylabel(sprintf('Magnitude^2 coherence'))
title('Beta band')
box off
set(gca,'TitleFontSizeMultiplier',1.5)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dx(:,b1:b2); Px(:,b1:b2); Ex(:,b1:b2); Mx(:,b1:b2)];
yy = [A, y1];
[stat.beta]=ksampL2(yy,method,biasflag);
clear y1 yy

%% Gamma (broadband) 
subplot(224)
p3 = shadedErrorBar(gamma,Ex(:,g1:g2),{@mean,@(x) std(Ex(:,g1:g2))/sqrt(size(Ex,1))},'lineprops',{'color',estyel});
p3.mainLine.LineWidth = 3;
p3.mainLine.DisplayName = 'Estrus';
hold on

p2 = shadedErrorBar(gamma,Px(:,g1:g2),{@mean,@(x) std(Px(:,g1:g2))/sqrt(size(Px,1))},'lineprops',{'color',propurp}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Proestrus';

p1 = shadedErrorBar(gamma,Dx(:,g1:g2),{@mean,@(x) std(Dx(:,g1:g2))/sqrt(size(Dx,1))},'lineprops',{'color',digreen}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Diestrus';

p4 = shadedErrorBar(gamma,Mx(:,g1:g2),{@mean,@(x) std(Mx(:,g1:g2))/sqrt(size(Mx,1))},'lineprops',{'color',maleblue});
p4.mainLine.LineWidth = 3;
p4.mainLine.DisplayName = 'Male';

axis square
xlim([25 85])
xticks(30:10:80)
xlabel('Frequency (Hz)')
ylabel(sprintf('Magnitude^2 coherence'))
title('Gamma band')
set(gca,'fontsize',14)
box off
set(gca,'TitleFontSizeMultiplier',1.5)

% One-way ANOVA for functional data: Main-effects test
y1 = [Dx(:,g1:g2); Px(:,g1:g2); Ex(:,g1:g2); Mx(:,g1:g2)];
yy = [A, y1];
[stat.gamma]=ksampL2(yy,method,biasflag);
clear y1 yy

% legend([p4.mainLine, p1.mainLine, p2.mainLine, p3.mainLine],{'Male','Diestrus','Proestrus','Estrus'})

end