%PlotBoot_PowSpecBands
% [h,stat] = PlotBoot_PowSpecBands(f,Mx,Fx)
% 
%   Plots power spectra data separated by sex and subject (trials
%   concatenated), BL arena, 5-15cm/s movement velocity. 
%   Subplots indicate frequency bands of interest: Theta, delta, gamma, beta
% 
%   Also calculates twosampF test statistics for each frequency band.
% 
%   Inputs:
%       f       Frequency vector
%       Mx      Male Pxx data for one brain region
%       Fx      Female Pxx data for one brain region
% 
% Calls on scripts:
%   - shadedErrorBar.m  (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
%   - twosampF.m 
% 
% Calls data produced by:
%   - PowSpec5to15.m: 'Pxx-BL-5to15.mat' (called within Thesis6_Format4Bootstrap_5to15.m)
% 
%   Called by:
%       - Thesis6_Format4Bootstrap_5to15.m
% 
% KJS init (as fxn): 2020-02-20
% 

function [h,stat] = PlotBoot_PowSpecBands(f,Mx,Fx,stat)
%% SETUP

% twosampF.m parameters
method = 1;
parflag = 1;

% Color maps
maleblue = [0.171931,0.744122,0.988253]; % MALES
propurp = [0.490079,0.06569,0.568432]; %FEMALES

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
    p2 = shadedErrorBar(delta,pow2db(Mx(:,d1:d2)),{@mean,@(f) std(pow2db(Mx(:,d1:d2)))/sqrt(size(Mx,1))},'lineprops',{'color',maleblue});
    p2.mainLine.LineWidth = 3;
    p2.mainLine.DisplayName = 'Males';
hold on
    % Female
    p3 = shadedErrorBar(delta,pow2db(Fx(:,d1:d2)),{@mean,@(f) std(pow2db(Fx(:,d1:d2)))/sqrt(size(Fx,1))},'lineprops',{'color',propurp});
    p3.mainLine.LineWidth = 3;
    p3.mainLine.DisplayName = 'Females - All stages';
    
    axis square
    xlim([0.5 4.5])
    xticks(1:4)
    set(gca,'fontsize',14)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Delta band')
    box off
    set(gca,'TitleFontSizeMultiplier',1.5)
    
    % twosampF: Delta
    [stat.delta] = twosampF(Fx(:,d1:d2),Mx(:,d1:d2),method,parflag);
    
    
%% Theta
subplot(222)
    % Male
    p2 = shadedErrorBar(theta,pow2db(Mx(:,t1:t2)),{@mean,@(f) std(pow2db(Mx(:,t1:t2)))/sqrt(size(Mx,1))},'lineprops',{'color',maleblue});
    p2.mainLine.LineWidth = 3;
    p2.mainLine.DisplayName = 'Males';
hold on
    % Female
    p3 = shadedErrorBar(theta,pow2db(Fx(:,t1:t2)),{@mean,@(f) std(pow2db(Fx(:,t1:t2)))/sqrt(size(Fx,1))},'lineprops',{'color',propurp});
    p3.mainLine.LineWidth = 3;
    p3.mainLine.DisplayName = 'Females - All stages';
    
    axis square
    xlim([3.5 12.5])
    xticks(4:12)
    set(gca,'fontsize',14)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Theta band')
    legend([p2.mainLine, p3.mainLine],{'Males','Females'})
    legend('location','southwest')
    box off
    set(gca,'TitleFontSizeMultiplier',1.5)
    
    % twosampF: Theta
    [stat.theta] = twosampF(Fx(:,t1:t2),Mx(:,t1:t2),method,parflag);
    
%% Beta
subplot(223)
    % Male
    p2 = shadedErrorBar(beta,pow2db(Mx(:,b1:b2)),{@mean,@(f) std(pow2db(Mx(:,b1:b2)))/sqrt(size(Mx,1))},'lineprops',{'color',maleblue});
    p2.mainLine.LineWidth = 3;
    p2.mainLine.DisplayName = 'Males';
hold on
    % Female
    p3 = shadedErrorBar(beta,pow2db(Fx(:,b1:b2)),{@mean,@(f) std(pow2db(Fx(:,b1:b2)))/sqrt(size(Fx,1))},'lineprops',{'color',propurp});
    p3.mainLine.LineWidth = 3;
    p3.mainLine.DisplayName = 'Females - All stages';
    
    axis square
    xlim([14.5 30.5])
    xticks(15:5:30)
    set(gca,'fontsize',14)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Beta band')
    box off
    set(gca,'TitleFontSizeMultiplier',1.5)
    
    % twosampF: Beta
    [stat.beta] = twosampF(Fx(:,b1:b2),Mx(:,b1:b2),method,parflag);
    
    
%% Gamma (broadband) 
subplot(224)
    % Male
    p2 = shadedErrorBar(gamma,pow2db(Mx(:,g1:g2)),{@mean,@(f) std(pow2db(Mx(:,g1:g2)))/sqrt(size(Mx,1))},'lineprops',{'color',maleblue});
    p2.mainLine.LineWidth = 3;
    p2.mainLine.DisplayName = 'Males';
hold on
    % Female
    p3 = shadedErrorBar(gamma,pow2db(Fx(:,g1:g2)),{@mean,@(f) std(pow2db(Fx(:,g1:g2)))/sqrt(size(Fx,1))},'lineprops',{'color',propurp});
    p3.mainLine.LineWidth = 3;
    p3.mainLine.DisplayName = 'Females - All stages';
    
    axis square
    xlim([25 85])
    xticks(30:10:80)
    set(gca,'fontsize',14)
    xlabel('Frequency (Hz)')
    ylabel('Power (dB)')
    title('Broadband gamma')
    box off
    set(gca,'TitleFontSizeMultiplier',1.5)
    
    % twosampF: Gamma
    [stat.gamma] = twosampF(Fx(:,g1:g2),Mx(:,g1:g2),method,parflag);

end %function

