%PlotBoot_PowSpec
% [H1,H2,H3,H4,ILstat,PLstat,DHstat,VHstat] = PlotBoot_PowSpec(f,Mil,Fil,Mpl,Fpl,Mdh,Fdh,Mvh,Fvh)
% 
% Plots Power spectra: Sex differences, with shading for SEM indicating subjects
% 
% Calls on scripts:
%   - shadedErrorBar.m  (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
%   - twosampF.m 
% 
% Calls data produced by:
%   - PowSpec5to15.m: 'Pxx-BL-5to15.mat' (called within Thesis6_Format4Bootstrap_5to15.m)
% 
% Called by:
%   - Thesis6_Format4Bootstrap_5to15.m
% 
% KJS edit: 2020-02-19 for compatibility with Thesis6_Format4Bootstrap_5to15

function [H1,H2,H3,H4,ILstat,PLstat,DHstat,VHstat] = PlotBoot_PowSpec(f,Mil,Fil,Mpl,Fpl,Mdh,Fdh,Mvh,Fvh)
%% SETUP

% twosampF.m parameters
method = 1;
parflag = 1;

% Color maps
maleblue = [0.171931,0.744122,0.988253]; % MALES
propurp = [0.490079,0.06569,0.568432]; %FEMALES

%% Plot mPFC-IL
H1 = figure('units','normalized','outerposition',[0 0 1 1]);
p2 = shadedErrorBar(f,pow2db(Mil),{@mean,@(x) std(pow2db(Mil))/sqrt(size(Mil,1))},'lineprops',{'color',maleblue}); %subject-collapsed
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Male';
hold on
p1 = shadedErrorBar(f,pow2db(Fil),{@mean,@(x) std(pow2db(Fil))/sqrt(size(Fil,1))},'lineprops',{'color',propurp});
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Female';
axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('IL')
% legend([p1.mainLine, p2.mainLine],{'Female','Male'})
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.75)

% Functional 2-sample F-test
[ILstat.MvF] = twosampF(Fil,Mil,method,parflag);

%% Plot mPFC-PL
H2 = figure('units','normalized','outerposition',[0 0 1 1]);
p2 = shadedErrorBar(f,pow2db(Mpl),{@mean,@(x) std(pow2db(Mpl))/sqrt(size(Mpl,1))},'lineprops',{'color',maleblue}); 
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Male';
hold on
p1 = shadedErrorBar(f,pow2db(Fpl),{@mean,@(x) std(pow2db(Fpl))/sqrt(size(Fpl,1))},'lineprops',{'color',propurp});
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Female';
axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('PrL')
legend([p1.mainLine, p2.mainLine],{'Female','Male'})
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.75)

% Functional 2-sample F-test
[PLstat.MvF] = twosampF(Fpl,Mpl,method,parflag);

%% Plot dHPC
H3 = figure('units','normalized','outerposition',[0 0 1 1]);
p2 = shadedErrorBar(f,pow2db(Mdh),{@mean,@(x) std(pow2db(Mdh))/sqrt(size(Mdh,1))},'lineprops',{'color',maleblue});
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Male';
hold on
p1 = shadedErrorBar(f,pow2db(Fdh),{@mean,@(x) std(pow2db(Fdh))/sqrt(size(Fdh,1))},'lineprops',{'color',propurp});
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Female';
axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('dHPC')
% legend([p1.mainLine, p2.mainLine],{'Female','Male'})
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.75)

% Functional 2-sample F-test
[DHstat.MvF] = twosampF(Fdh,Mdh,method,parflag);

%% Plot vHPC
H4 = figure('units','normalized','outerposition',[0 0 1 1]);
p2 = shadedErrorBar(f,pow2db(Mvh),{@mean,@(x) std(pow2db(Mvh))/sqrt(size(Mvh,1))},'lineprops',{'color',maleblue});
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Male';
hold on
p1 = shadedErrorBar(f,pow2db(Fvh),{@mean,@(x) std(pow2db(Fvh))/sqrt(size(Fvh,1))},'lineprops',{'color',propurp});
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Female';
axis square
xlim([0.5 100])
xticks(10:10:100)
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
title('vHPC')
% legend([p1.mainLine, p2.mainLine],{'Female','Male'})
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.75)

% Functional 2-sample F-test
[VHstat.MvF] = twosampF(Fvh,Mvh,method,parflag);

end %function
