function [H1,stat] = PlotBoot_mscohere(f,Mx,Fx)
% [H1,H2,H3,H4,ILstat,PLstat,DHstat,VHstat] = PlotBoot_mscohere(f,Mil,Fil,Mpl,Fpl,Mdh,Fdh,Mvh,Fvh)
% 
% Plots mscohere: Sex differences, with shading for SEM indicating subjects
% 
% Calls on scripts:
%   - shadedErrorBar.m  (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
%   - twosampF.m 
% 
% % Calls data produced by:
%   - Format4Bootstrap_mscohere.m: 'mscohere-BL-5to15_boot.mat' (called within Thesis6_Format4Bootstrap_5to15.m)
% 
%   Called by:
%       - Thesis6_Format4Bootstrap_5to15.m
% 
% KJS init: 2020-01-24
% KJS re-write init (as fxn): 2020-02-27

%% SETUP

% twosampF.m parameters
method = 1;
parflag = 1;

% Color maps
maleblue = [0.1719    0.7441    0.9883]; % MALES
propurp = [0.4901    0.0657    0.5684]; %FEMALES

%% Plot mscohere
H1 = figure('units','normalized','outerposition',[0 0 1 1]);
% p2 = shadedErrorBar(f,Mildh,{@mean,@std},'lineprops',{'color',maleblue});
p2 = shadedErrorBar(f,Mx,{@mean,@(x) std(Mx)/sqrt(size(Mx,1))},'lineprops',{'color',maleblue}); %subject-collapsed
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Male';
hold on
% p1 = shadedErrorBar(f,Fildh,{@mean,@std},'lineprops',{'color',propurp});
p1 = shadedErrorBar(f,Fx,{@mean,@(x) std(Fx)/sqrt(size(Fx,1))},'lineprops',{'color',propurp}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Female';
axis square
xlim([0.5 50])
ylim([0 1])
xticks(10:10:50)
yticks([0 : 0.2 : 1])
xlabel('Frequency (Hz)')
ylabel('Magnitude-squared Coherence')
legend([p1.mainLine, p2.mainLine],{'Female','Male'})
legend('location','southwest')
set(gca,'fontsize',26)
box off
set(gca,'TitleFontSizeMultiplier',1.5)

% Functional 2-sample F-test
[stat] = twosampF(Fx,Mx,method,parflag);

end %function
