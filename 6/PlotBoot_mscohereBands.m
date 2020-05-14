%PlotBoot_mscohereBands
% [h,stat] = PlotBoot_mscohereBands(f,Mx,Fx)
% 
%   Plots mscohere data separated by sex and subject (trials
%   concatenated), BL arena, 5-15cm/s movement velocity. 
%   Subplots indicate frequency bands of interest: Theta, delta, gamma, beta
% 
%   Also calculates twosampF test statistics for each frequency band.
% 
%   Inputs:
%       f       Frequency vector
%       Mx      Male mscohere data for one pairwise connection
%       Fx      Female mscohere data for one pairwise connection
% 
% Calls on scripts:
%   - shadedErrorBar.m  (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
%   - twosampF.m 
% 
% Calls data produced by:
%   - Format4Bootstrap_mscohere.m: 'mscohere-BL-5to15_boot.mat' (called within Thesis6_Format4Bootstrap_5to15.m)
% 
%   Called by:
%       - Thesis6_Format4Bootstrap_5to15.m
% 
% KJS init (as fxn): 2020-02-27  ***INCOMPLETE***
% 

function [h,stat] = PlotBoot_mscohereBands(f,Mx,Fx,stat)
%% SETUP

% twosampF.m parameters
method = 1;
parflag = 1;

% Color maps
Mcol = [0         0.2980    0.2980]; %teal
Fcol = [0.9529    0.9098    0.0824]; %yellow

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
    % Male
    p2 = shadedErrorBar(delta,Mx(:,d1:d2),{@mean,@(x) std(Mx(:,d1:d2))/sqrt(size(Mx,1))},'lineprops',{'color',Mcol});
    p2.mainLine.LineWidth = 3;
    p2.mainLine.DisplayName = 'Males';
hold on
    % Female
    p3 = shadedErrorBar(delta,Fx(:,d1:d2),{@mean,@(f) std(Fx(:,d1:d2))/sqrt(size(Fx,1))},'lineprops',{'color',Fcol});
    p3.mainLine.LineWidth = 3;
    p3.mainLine.DisplayName = 'Females - All stages';
    
    axis square
    xlim([0.5 4.5])
    xticks(1:4)
    xlabel('Frequency (Hz)')
    ylabel(sprintf('Magnitude^2 coherence'))
    title('Delta band')
    box off
    set(gca,'FontName','Arial','fontsize',14,'TitleFontSizeMultiplier',1.5)
    
    % twosampF: Delta
    [stat.delta] = twosampF(Fx(:,d1:d2),Mx(:,d1:d2),method,parflag);
    
    
%% Theta
subplot(222)
    % Male
    p2 = shadedErrorBar(theta,Mx(:,t1:t2),{@mean,@(x) std(Mx(:,t1:t2))/sqrt(size(Mx,1))},'lineprops',{'color',Mcol});
    p2.mainLine.LineWidth = 3;
    p2.mainLine.DisplayName = 'Males';
hold on
    % Female
    p3 = shadedErrorBar(theta,Fx(:,t1:t2),{@mean,@(x) std(Fx(:,t1:t2))/sqrt(size(Fx,1))},'lineprops',{'color',Fcol});
    p3.mainLine.LineWidth = 3;
    p3.mainLine.DisplayName = 'Females - All stages';
    
    axis square
    xlim([3.5 12.5])
    xticks(4:12)
    xlabel('Frequency (Hz)')
    ylabel(sprintf('Magnitude^2 coherence'))
    title('Theta band')
%     legend([p2.mainLine, p3.mainLine],{'Male','Female'})
%     legend('location','southwest')
%     legend('boxoff')
    box off
    set(gca,'FontName','Arial','fontsize',14,'TitleFontSizeMultiplier',1.5)
    
    % twosampF: Theta
    [stat.theta] = twosampF(Fx(:,t1:t2),Mx(:,t1:t2),method,parflag);
    
%% Beta
subplot(223)
    % Male
    p2 = shadedErrorBar(beta,Mx(:,b1:b2),{@mean,@(x) std(Mx(:,b1:b2))/sqrt(size(Mx,1))},'lineprops',{'color',Mcol});
    p2.mainLine.LineWidth = 3;
    p2.mainLine.DisplayName = 'Males';
hold on
    % Female
    p3 = shadedErrorBar(beta,Fx(:,b1:b2),{@mean,@(x) std(Fx(:,b1:b2))/sqrt(size(Fx,1))},'lineprops',{'color',Fcol});
    p3.mainLine.LineWidth = 3;
    p3.mainLine.DisplayName = 'Females - All stages';
    
    axis square
    xlim([14.5 30.5])
    xticks(15:5:30)
    xlabel('Frequency (Hz)')
    ylabel(sprintf('Magnitude^2 coherence'))
    title('Beta band')
    box off
    set(gca,'FontName','Arial','fontsize',14,'TitleFontSizeMultiplier',1.5)
    
    % twosampF: Beta
    [stat.beta] = twosampF(Fx(:,b1:b2),Mx(:,b1:b2),method,parflag);
    
    
%% Gamma (broadband) 
subplot(224)
    % Male
    p2 = shadedErrorBar(gamma,Mx(:,g1:g2),{@mean,@(x) std(Mx(:,g1:g2))/sqrt(size(Mx,1))},'lineprops',{'color',Mcol});
    p2.mainLine.LineWidth = 3;
    p2.mainLine.DisplayName = 'Males';
hold on
    % Female
    p3 = shadedErrorBar(gamma,Fx(:,g1:g2),{@mean,@(x) std(Fx(:,g1:g2))/sqrt(size(Fx,1))},'lineprops',{'color',Fcol});
    p3.mainLine.LineWidth = 3;
    p3.mainLine.DisplayName = 'Females - All stages';
    
    axis square
    xlim([25 85])
    xticks(30:10:80)
    xlabel('Frequency (Hz)')
    ylabel(sprintf('Magnitude^2 coherence'))
    title('Broadband gamma')
    box off
    set(gca,'FontName','Arial','fontsize',14,'TitleFontSizeMultiplier',1.5)
    
    % twosampF: Gamma
    [stat.gamma] = twosampF(Fx(:,g1:g2),Mx(:,g1:g2),method,parflag);

end %function
