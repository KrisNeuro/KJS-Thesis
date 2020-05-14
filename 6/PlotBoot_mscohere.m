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
Mcol = [0         0.2980    0.2980]; %teal
Fcol = [0.9529    0.9098    0.0824]; %yellow

%% Plot mscohere
H1 = figure('units','normalized','outerposition',[0 0 1 1]);
% p2 = shadedErrorBar(f,Mildh,{@mean,@std},'lineprops',{'color',Mcol});
p2 = shadedErrorBar(f,Mx,{@mean,@(x) std(Mx)/sqrt(size(Mx,1))},'lineprops',{'color',Mcol}); %subject-collapsed
p2.mainLine.LineWidth = 3;
p2.mainLine.DisplayName = 'Male';
hold on
p1 = shadedErrorBar(f,Fx,{@mean,@(x) std(Fx)/sqrt(size(Fx,1))},'lineprops',{'color',Fcol}); 
p1.mainLine.LineWidth = 3;
p1.mainLine.DisplayName = 'Female';
axis square
xlim([0.5 100])
ylim([0 1])
xticks(10:10:100)
yticks([0 : 0.2 : 1])
xlabel('Frequency (Hz)')
ylabel('Magnitude-squared Coherence')
legend([p1.mainLine, p2.mainLine],{'Female','Male'})
legend('location','southwest')
legend('boxoff')
set(gca,'FontName','Arial','fontsize',24,'TitleFontSizeMultiplier',2)
box off

% Functional 2-sample F-test
[stat] = twosampF(Fx,Mx,method,parflag);

end %function
