%% Thesis6_Format4Bootstrap_5to15.m
% 
%  Format LFP data taken from epochs of movement 5-15 cm/s in the familiar 
%  ('BL') arena for bootstrapping procedures relating to power spectra, band
%  power, and coherence between regions
% 
%   Steps:
%       1. Format for bootstrap: LFP data
%       2.1 Calculate Power Spectra: One curve per subject
%       2.2 Calculate female Power Spectra: Separate each subj by estrous stage
%       2.3 Plot Power Spectra & Functional statistical tests: Sex Differences
%       2.4 Plot Power Spectra & Functional statistical tests: Females only/Estrous stages
%       2.5 Plot Power Spectra & Functional statistical tests: Male vs Estrous stages
%       3 Calculate band power in theta, gamma, and delta bands
%       4. Format for bootstrap: coherencyc & Plot                 
%       5.1 Calculate mscohere: One curve per subject
%       5.2 Calculate female mscohere: Separate each subj by estrous stage
%       5.3 Plot mscohere & Functional statistical tests: Sex Differences
%       5.4 Plot mscohere & Functional statistical tests: Females only/Estrous stages
% 
% 
%   Fetches data generated by:
%       Thesis5_FilterByVelocity.m      'subjID_ReducedDataPerSpeed.mat'
% 
%   Calls on:
%       - colorcet.m  (https://peterkovesi.com/projects/colourmaps/)
%       - shadedErrorBar.m  (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
%       - twosampF.m 
%       - Format4Bootstrap_LFP.m
%       - PowSpec5to15.m
%       - PowSpec5to15_Hormones.m
%       - PlotBoot_PowSpec.m
%       - PlotBoot_PowSpecBands.m
%       - PlotBoot_PowSpecHormones.m
%       - PlotBoot_PowSpecHormonesBands.m
%       - PlotBoot_PowSpecMvHorms.m
%       - PlotBoot_PowSpecMvHormsBands.m
%       - PowSpec5to15Trials.m
%       - Format4Bootstrap_BandPower2.m
%       - get_bootstrapped_sample.m
%       - get_direct_prob.m
%       - Format4Bootstrap_coherency.m
%       - coherencyc.m  (Chronux toolbox)
%       - PlotBoot_mscohere.m
%       - PlotBoot_mscohereBands.m
%       - PlotBoot_mscohereHormones.m
%       - PlotBoot_mscohereHormonesBands.m 
% 
% 
% KJS init 2020-02-18
% KJS edits: 2/18/20 - 2/27/20
% KJS edit 2020-04-06: Add Male vs Female hormone comparison and plotting

%% SETUP
subjs = {'A201' 'A202' 'A301' 'A602' 'E105' 'E106' 'E107' 'E108' 'E201'}; % Subject ID listing. A*=male  E*=female    ***USER MUST HARD-CODE THESE VARIABLES FOR EACH NEW EXPERIMENTAL SET****

% Set data directories & Add paths containing script
if license == "731138" % user = KJS/Kabbaj lab
    root_drIn = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\ReducedEEG\BL\'; %data input
    figdrOut = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\figs\'; %figure output directory  
    addpath(genpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\toolboxes\chronux')) %coherencyc
    if ~exist('colorcet.m','file'); addpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\toolboxes'); end %colorcet.m
    if ~exist('shadedErrorBar.m','file'); addpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\m\code\shadedErrorBar'); end %shadedErrorBar.m
    if ~exist('twosampF.m','file'); addpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\m\code\YiQi\functionalanova'); end %twosampF.m
    if ~exist('get_bootstrapped_sample.m','file') || ~exist('get_direct_prob.m','file'); addpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\m\sandbox\');end
else% user = anyone else
    root_drIn = [uigetdir(pwd,'Select root input directory holding data: Reduced EEG, BL arena') filesep];
    figdrOut = [uigetdir(pwd,'Select root figure output directory') filesep];
    if ~exist('colorcet.m','file'); addpath(uigetdir(pwd,'Select folder containing colorcet.m')); end %colorcet.m
    if ~exist('shadedErrorBar.m','file'); addpath(uigetdir(pwd,'Select folder containing shadedErrorBar.m')); end %shadedErrorBar.m
    if ~exist('twosampF.m','file'); addpath(uigetdir(pwd,'Select folder containing twosampF.m')); end %twosampF.m
    if ~exist('coherencyc.m','file'); addpath(uigetdir(pwd,'Select folder containing Chronux toolbox')); end %coherencyc.m
    if ~exist('Format4Bootstrap_LFP.m','file') || ~exist('Format4Bootstrap_PowSpec.m','file') ...
            || ~exist('Format4Bootstrap_mscohere.m','file') || ~exist('Format4Bootstrap_BandPower.m','file') %#ok<ALIGN>
        addpath(uigetdir(pwd,'Select folder containing Format4Bootstrap_*.m files'));end
    if ~exist('PlotBoot_PowSpec.m','file') || ~exist('PlotBoot_mscohere.m','file')
        addpath(uigetdir(pwd,'Select folder containing PlotBoot_*.m files')); end
    if ~exist('get_bootstrapped_sample.m','file') || ~exist('get_direct_prob.m','file'); addpath(uigetdir(pwd,'Select folder containing bootstrapping .m files')); end
end
if ~exist(figdrOut,'dir'); mkdir(figdrOut); end

%% 1. Format for bootstrap: LFP data, BL arena, all trials        
 % SEE: Format4Bootstrap_LFP.m
disp('Shaping LFP data for bootstrap...')
[M_IL,M_PL,M_DH,M_VH,F_IL,F_PL,F_DH,F_VH] = Format4Bootstrap_LFP(subjs,root_drIn);

% Save the data
disp('Saving LFP bootstrap data..')
fn = 'LFP-BL-5to15_boot.mat';
save([root_drIn '5to15' filesep fn],'F*','M*','-v7.3')
disp('Saved!')
clear fn 
 
%% 2.1 Calculate Power Spectra: One curve per subject 
% Uses data generated by Format4Bootstrap_LFP.m (above)

% If needed, fetch bootstrap-shaped LFP data, BL arena, 5-15 cm/s movement
if ~exist('M_IL','var') || ~exist('F_IL','var')
    disp('Fetching 5-15cm/s LFP BL data')
    fn = 'LFP-BL-5to15_boot.mat';
    load([root_drIn '5to15' filesep fn],'F*','M*')
    clear fn
end

% Calculate Pxx (pwelch)
  % Female data includes all hormone states per subject
disp('Calculating Pxx...')
[f,M_IL_Pxx,M_DH_Pxx,M_VH_Pxx,M_PL_Pxx,F_IL_Pxx,F_DH_Pxx,F_VH_Pxx,F_PL_Pxx] = PowSpec5to15(subjs,M_IL,M_DH,M_VH,M_PL,F_IL,F_DH,F_VH,F_PL); 
clear M_IL M_DH M_VH M_PL 
% clear F_IL F_DH F_VH F_PL

% Save the data: One curve per subject
disp('Saving Pxx data...')
fn = 'Pxx-BL-5to15.mat';
save([root_drIn '5to15' filesep fn],'f','subjs','M_IL_Pxx','M_DH_Pxx','M_VH_Pxx','M_PL_Pxx','F_IL_Pxx','F_DH_Pxx','F_VH_Pxx','F_PL_Pxx','-v7.3')
disp('Saved!')
clear fn F_IL_Pxx F_DH_Pxx F_VH_Pxx F_PL_Pxx M_*

%% 2.2 Calculate female Power Spectra: Separate each subj by estrous stage 
% Uses data generated by Format4Bootstrap_LFP.m (above)

if ~exist('F_IL','var') % Fetch female LFP data: BL arena, 5-15 cm/s
    disp('Fetching 5-15cm/s LFP BL data for females...')
    fn = 'LFP-BL-5to15_boot.mat';
    load([root_drIn '5to15' filesep fn],'F*')
    clear fn
end
    
% Calculate Pxx (pwelch)
  % Female data is separated for each hormone states, within-subject
disp('Calculating Pxx for female hormone states...')
Fsubjs = subjs(contains(subjs,'E')); % Female subject IDs
[F_IL_Pxx,F_DH_Pxx,F_VH_Pxx,F_PL_Pxx] = PowSpec5to15_Hormones(Fsubjs,F_IL,F_DH,F_VH,F_PL);
clear F_IL F_DH F_VH F_PL Fsubjs

% Save the data: 4 curve per subject, for each hormone state
disp('Saving Pxx data...')
fn = 'PxxHormones-BL-5to15.mat';
save([root_drIn '5to15' filesep fn],'f','Fsubjs','F_IL_Pxx','F_DH_Pxx','F_VH_Pxx','F_PL_Pxx','-v7.3')
disp('Saved!')
% clear 

%% 2.3 Plot Power Spectra & Functional statistical tests: Sex Differences   
% SEE: PlotBoot_PowSpec.m & PlotBoot_PowSpecBands.m

% Fetch data. Use M_*_Pxx and F_*_Pxx without hormone state separation.
if ~exist('M_IL_Pxx','var') || ~exist('F_IL_Pxx','var')
    fn = 'Pxx-BL-5to15.mat';
    load([root_drIn '5to15' filesep fn],'f','M_IL_Pxx','M_DH_Pxx','M_VH_Pxx','M_PL_Pxx','F_IL_Pxx','F_DH_Pxx','F_VH_Pxx','F_PL_Pxx')
    clear fn
end
 
 % Concatenate data & Check that data are shaped correctly
% mPFC-IL
    Fil = cell2mat(F_IL_Pxx');
    Mil = cell2mat(M_IL_Pxx');
% dHPC
    Fdh = cell2mat(F_DH_Pxx');
    Mdh = cell2mat(M_DH_Pxx');
%vHPC
    Fvh = cell2mat(F_VH_Pxx');
    Mvh = cell2mat(M_VH_Pxx');
%mPFC-PL
    Fpl = cell2mat(F_PL_Pxx');
    Mpl = cell2mat(M_PL_Pxx');
clear M_* F_*
if size(Mil,1) > size(Mil,2) 
    Mil = Mil';
    Mdh = Mdh';
    Mvh = Mvh';
    Mpl = Mpl';
    Fil = Fil';
    Fdh = Fdh';
    Fvh = Fvh';
    Fpl = Fpl';
end
 
% Plot Power spectra: Sex differences, 0.5-100 Hz
[H1,H2,H3,H4,ILstat,PLstat,DHstat,VHstat] = PlotBoot_PowSpec(f,Mil,Fil,Mpl,Fpl,Mdh,Fdh,Mvh,Fvh);

    % Save figures
    fd = [figdrOut 'PowSpec_ReducedChannels\BL\FunctionalAnova\']; %output directory
    if ~exist(fd,'dir'); mkdir(fd); end    
    saveas(H1,[fd 'mPFCIL-MvF-SubjSEM-5to15BL.tif'])
    saveas(H1,[fd 'mPFCIL-MvF-SubjSEM-5to15BL.fig'])
        close(H1); clear H1
    saveas(H2,[fd 'mPFCPL-MvF-SubjSEM-5to15BL.tif'])
    saveas(H2,[fd 'mPFCPL-MvF-SubjSEM-5to15BL.fig'])
        close(H2); clear H2
    saveas(H3,[fd 'dHPC-MvF-SubjSEM-5to15BL.tif'])
    saveas(H3,[fd 'dHPC-MvF-SubjSEM-5to15BL.fig'])
        close(H3); clear H3
    saveas(H4,[fd 'vHPC-MvF-SubjSEM-5to15BL.tif'])
    saveas(H4,[fd 'vHPC-MvF-SubjSEM-5to15BL.fig'])
        close(H4); clear H4
        
% Plot Power spectra: Sex differences, Frequency bands of interest
% mPFC-IL
    [h1,ILstat] = PlotBoot_PowSpecBands(f,Mil,Fil,ILstat); %#ok<*ASGLU>
    clear Mil Fil
% mPFC-PL
    [h2,PLstat] = PlotBoot_PowSpecBands(f,Mpl,Fpl,PLstat);
    clear Mpl Fpl
% dHPC
    [h3,DHstat] = PlotBoot_PowSpecBands(f,Mdh,Fdh,DHstat);
    clear Mdh Fdh
% vHPC
    [h4,VHstat] = PlotBoot_PowSpecBands(f,Mvh,Fvh,VHstat);
    clear Mvh Fvh
         
    % Save figures
    saveas(h1,[fd 'mPFCILbands-MvF-SubjSEM-5to15BL.tif'])
    saveas(h1,[fd 'mPFCILbands-MvF-SubjSEM-5to15BL.fig'])
        close(h1); clear h1
    saveas(h2,[fd 'mPFCPLbands-MvF-SubjSEM-5to15BL.tif'])
    saveas(h2,[fd 'mPFCPLbands-MvF-SubjSEM-5to15BL.fig'])
        close(h2); clear h2
    saveas(h3,[fd 'dHPCbands-MvF-SubjSEM-5to15BL.tif'])
    saveas(h3,[fd 'dHPCbands-MvF-SubjSEM-5to15BL.fig'])
        close(h3); clear h3
    saveas(h4,[fd 'vHPCbands-MvF-SubjSEM-5to15BL.tif'])
    saveas(h4,[fd 'vHPCbands-MvF-SubjSEM-5to15BL.fig'])
        close(h4); clear h4
        
% Save data: Functional f-tests
fn = 'FunctionalTestStatistics-powspec_5to15_BL_SexDiffs.mat';
save([root_drIn '5to15' filesep fn],'subjs','DHstat','ILstat','PLstat','VHstat','-v7.3')
disp('Functional test outputs saved!')
clear fn *stat f
        
%% 2.4 Plot Power Spectra & Functional statistical tests: Females only/Estrous stages  
% SEE: PlotBoot_PowSpecHormones.m

 % Fetch data: Separated by estrous stage
 fn = 'PxxHormones-BL-5to15.mat';
 load([root_drIn '5to15' filesep fn],'f','F_IL_Pxx','F_DH_Pxx','F_VH_Pxx','F_PL_Pxx')
 clear fn
 
 % A: nx1  indicator of the levels of Factor A (Female hormone state)
    DiN = size(cell2mat(F_IL_Pxx(:,1)'),2); %Diestrus n count
    ProN = size(cell2mat(F_IL_Pxx(:,2)'),2); %Proestrus n count
    EstN = size(cell2mat(F_IL_Pxx(:,3)'),2); %Estrus n count
    A(1:DiN) = 1; %Diestrus=1
    A(DiN+1:DiN+ProN)=2; %Proestrus=2
    A(DiN+ProN+1:DiN+ProN+EstN)=3; %Estrus=3
    A = A'; %orient correctly
    clear DiN ProN EstN

% Concatenate data: per hormone stage
% mPFC-IL
    Dil = cell2mat(F_IL_Pxx(:,1)'); %Diestrus
    Pil = cell2mat(F_IL_Pxx(:,2)'); %Proestrus
    Eil = cell2mat(F_IL_Pxx(:,3)'); %Estrus
    Mil =  cell2mat(F_IL_Pxx(:,4)'); %Metestrus
% dHPC
    Ddh = cell2mat(F_DH_Pxx(:,1)');
    Pdh = cell2mat(F_DH_Pxx(:,2)');
    Edh = cell2mat(F_DH_Pxx(:,3)');
    Mdh =  cell2mat(F_DH_Pxx(:,4)');
%vHPC
    Dvh = cell2mat(F_VH_Pxx(:,1)');
    Pvh = cell2mat(F_VH_Pxx(:,2)');
    Evh = cell2mat(F_VH_Pxx(:,3)');
    Mvh =  cell2mat(F_VH_Pxx(:,4)');
%mPFC-PL
    Dpl = cell2mat(F_PL_Pxx(:,1)');
    Ppl = cell2mat(F_PL_Pxx(:,2)');
    Epl = cell2mat(F_PL_Pxx(:,3)');
    Mpl =  cell2mat(F_PL_Pxx(:,4)');
    clear F_*

% Check that data is oriented correctly
if size(Dil,1) > size(Dil,2) 
    Dil = Dil';
    Pil = Pil';
    Eil = Eil';
    Mil = Mil';  
    Ddh = Ddh';
    Pdh = Pdh';
    Edh = Edh';
    Mdh = Mdh';
    Dvh = Dvh';
    Pvh = Pvh';
    Evh = Evh';
    Mvh = Mvh';  
    Dpl = Dpl';
    Ppl = Ppl';
    Epl = Epl';
    Mpl = Mpl';
end

% Plot Power spectra: Effect of estrous stage, 0.5-100 Hz
[H1,H2,H3,H4,ILstat,PLstat,DHstat,VHstat] = PlotBoot_PowSpecHormones(f,A,Dil,Pil,Eil,Mil,Ddh,Pdh,Edh,Mdh,Dvh,Pvh,Evh,Mvh,Dpl,Ppl,Epl,Mpl);

    % Save figures
    fd = [figdrOut 'PowSpec_ReducedChannels\BL\FunctionalAnova\']; %output directory
    saveas(H1,[fd 'mPFCIL-Hormones-SubjSEM-5to15BL.tif'])
    saveas(H1,[fd 'mPFCIL-Hormones-SubjSEM-5to15BL.fig'])
        close(H1); clear H1
    saveas(H2,[fd 'mPFCPL-Hormones-SubjSEM-5to15BL.tif'])
    saveas(H2,[fd 'mPFCPL-Hormones-SubjSEM-5to15BL.fig'])
        close(H2); clear H2
    saveas(H3,[fd 'dHPC-Hormones-SubjSEM-5to15BL.tif'])
    saveas(H3,[fd 'dHPC-Hormones-SubjSEM-5to15BL.fig'])
        close(H3); clear H3
    saveas(H4,[fd 'vHPC-Hormones-SubjSEM-5to15BL.tif'])
    saveas(H4,[fd 'vHPC-Hormones-SubjSEM-5to15BL.fig'])
        close(H4); clear H4
    
% Plot Power spectra: Effect of estrous stage, Frequency bands of interest
% mPFC-IL
    [h1,ILstat] = PlotBoot_PowSpecHormonesBands(f,Dil,Pil,Eil,Mil,ILstat,A);
    clear Mil
% mPFC-PL
    [h2,PLstat] = PlotBoot_PowSpecHormonesBands(f,Dpl,Ppl,Epl,Mpl,PLstat,A);
    clear Mpl
% dHPC
    [h3,DHstat] = PlotBoot_PowSpecHormonesBands(f,Ddh,Pdh,Edh,Mdh,DHstat,A);
    clear Mdh
% vHPC
    [h4,VHstat] = PlotBoot_PowSpecHormonesBands(f,Dvh,Pvh,Evh,Mvh,VHstat,A);
    clear Mvh
         
    % Save figures
    saveas(h1,[fd 'mPFCILbands-Hormones-SubjSEM-5to15BL.tif'])
    saveas(h1,[fd 'mPFCILbands-Hormones-SubjSEM-5to15BL.fig'])
        close(h1); clear h1
    saveas(h2,[fd 'mPFCPLbands-Hormones-SubjSEM-5to15BL.tif'])
    saveas(h2,[fd 'mPFCPLbands-Hormones-SubjSEM-5to15BL.fig'])
        close(h2); clear h2
    saveas(h3,[fd 'dHPCbands-Hormones-SubjSEM-5to15BL.tif'])
    saveas(h3,[fd 'dHPCbands-Hormones-SubjSEM-5to15BL.fig'])
        close(h3); clear h3
    saveas(h4,[fd 'vHPCbands-Hormones-SubjSEM-5to15BL.tif'])
    saveas(h4,[fd 'vHPCbands-Hormones-SubjSEM-5to15BL.fig'])
        close(h4); clear h4 fd
    
% Save data: One-way functional ANOVAs
fn = 'FunctionalTestStatistics-powspec_5to15_BL_Hormones.mat';
save([root_drIn '5to15' filesep fn],'subjs','A','DHstat','ILstat','PLstat','VHstat','-v7.3')
disp('Functional test outputs saved!')%done 2020-02-20
clear fn *stat 

%% 2.5 Plot Power Spectra & Functional statistical tests: Male vs Estrous stages
% See: PlotBoot_PowSpecMvHorms.m & PlotBoot_PowSpecMvHormsBands.m

% Load male data
fn = 'Pxx-BL-5to15.mat';
load([root_drIn '5to15' filesep fn],'M_*')
clear fn

% Re-shape data
Mil = cell2mat(M_IL_Pxx');
Mdh = cell2mat(M_DH_Pxx');
Mvh = cell2mat(M_VH_Pxx');
Mpl = cell2mat(M_PL_Pxx');
clear M_*
if size(Mil,1) > size(Mil,2) 
    Mil = Mil';
    Mdh = Mdh';
    Mvh = Mvh';
    Mpl = Mpl';
end

% Append males onto 'A' for fANOVAs
A = [A; 4; 4; 4; 4];

% Plot Power spectra: Males vs Estrous stages, 0.5-100 Hz
[H1,H2,H3,H4,ILstat,PLstat,DHstat,VHstat] = PlotBoot_PowSpecMvHorms(f,A,Dil,Pil,Eil,Mil,Ddh,Pdh,Edh,Mdh,Dvh,Pvh,Evh,Mvh,Dpl,Ppl,Epl,Mpl);

    % Save figures
    fd = [figdrOut 'PowSpec_ReducedChannels\BL\FunctionalAnova\']; %output directory
    saveas(H1,[fd 'mPFCIL-MvHorms-SubjSEM-5to15BL.png'])
    saveas(H1,[fd 'mPFCIL-MvHorms-SubjSEM-5to15BL.fig'])
        close(H1); clear H1
    saveas(H2,[fd 'mPFCPL-MvHorms-SubjSEM-5to15BL.png'])
    saveas(H2,[fd 'mPFCPL-MvHorms-SubjSEM-5to15BL.fig'])
        close(H2); clear H2
    saveas(H3,[fd 'dHPC-MvHorms-SubjSEM-5to15BL.png'])
    saveas(H3,[fd 'dHPC-MvHorms-SubjSEM-5to15BL.fig'])
        close(H3); clear H3
    saveas(H4,[fd 'vHPC-MvHorms-SubjSEM-5to15BL.png'])
    saveas(H4,[fd 'vHPC-MvHorms-SubjSEM-5to15BL.fig'])
        close(H4); clear H4

% Plot Power spectra: Males vs Estrous stages, Frequency bands of interest
% mPFC-IL
    [h1,ILstat] = PlotBoot_PowSpecMvHormsBands(f,Dil,Pil,Eil,Mil,ILstat,A);
    clear Dil Pil Eil Mil
% mPFC-PL
   [h2,PLstat] = PlotBoot_PowSpecMvHormsBands(f,Dpl,Ppl,Epl,Mpl,PLstat,A);
    clear Dpl Ppl Epl Mpl
% dHPC
    [h3,DHstat] = PlotBoot_PowSpecMvHormsBands(f,Ddh,Pdh,Edh,Mdh,DHstat,A);
    clear Ddh Pdh Edh Mdh
% vHPC
    [h4,VHstat] = PlotBoot_PowSpecMvHormsBands(f,Dvh,Pvh,Evh,Mvh,VHstat,A);
    clear Dvh Pvh Evh Mvh
         
    % Save figures
    saveas(h1,[fd 'mPFCILbands-MvHorms-SubjSEM-5to15BL.png'])
    saveas(h1,[fd 'mPFCILbands-MvHorms-SubjSEM-5to15BL.fig'])
        close(h1); clear h1
    saveas(h2,[fd 'mPFCPLbands-MvHorms-SubjSEM-5to15BL.png'])
    saveas(h2,[fd 'mPFCPLbands-MvHorms-SubjSEM-5to15BL.fig'])
        close(h2); clear h2
    saveas(h3,[fd 'dHPCbands-MvHorms-SubjSEM-5to15BL.png'])
    saveas(h3,[fd 'dHPCbands-MvHorms-SubjSEM-5to15BL.fig'])
        close(h3); clear h3
    saveas(h4,[fd 'vHPCbands-MvHorms-SubjSEM-5to15BL.png'])
    saveas(h4,[fd 'vHPCbands-MvHorms-SubjSEM-5to15BL.fig'])
        close(h4); clear h4 fd
        
% Save data: One-way functional ANOVAs
fn = 'FunctionalTestStatistics-powspec_5to15_BL_MvHorms.mat';
save([root_drIn '5to15' filesep fn],'subjs','DHstat','ILstat','PLstat','VHstat','-v7.3')
disp('Functional test outputs saved!')
clear fn *stat f

    
%% 3 Calculate band power in theta, gamma, and delta bands                % PowSpecTrials takes significant time to run**
 % SEE: PowSpec5to15Trials.m, Format4Bootstrap_BandPower.m
 
% Fetch LFP data from all familiar arena trials, 5-15cm/s velocity
disp('Loading 5-15cm/s LFP data, all trials...')
fn = 'LFP-BL-5to15_boot.mat';
load([root_drIn '5to15' filesep fn],'F*','M*')
clear fn 

% Calculate power spectra for each trial individually (5-15 cm/s)
[f,M_IL_Pxx,M_DH_Pxx,M_VH_Pxx,M_PL_Pxx,F_IL_Pxx,F_DH_Pxx,F_VH_Pxx,F_PL_Pxx] = PowSpec5to15Trials(subjs,M_IL,M_DH,M_VH,M_PL,F_IL,F_DH,F_VH,F_PL);
clear M_IL M_DH M_VH M_PL F_IL F_DH F_VH F_PL

    % Save the data: Trial-separated power spectra, female hormone states separated
    fn = 'PxxTrials-BL-5to15.mat';
    save([root_drIn '5to15' filesep fn],'f','F_*','M_*','subjs','-v7.3')
    disp('Data saved!') %done 2020-02-26
    clear fn

% Calculate band power for theta, delta, gamma frequency bands over trials
disp('Shaping frequency band power data for bootstrap...')
% [M_il,M_pl,M_dh,M_vh,F_il,F_pl,F_dh,F_vh] = Format4Bootstrap_BandPower(subjs,f,M_IL_Pxx,M_PL_Pxx,M_DH_Pxx,M_VH_Pxx,F_IL_Pxx,F_DH_Pxx,F_VH_Pxx,F_PL_Pxx);  %NO. Needs additional re-shaping for bootstrap procedure
[M_IL_theta,M_IL_gamma,M_IL_delta,M_DH_theta,M_DH_gamma,M_DH_delta,M_VH_theta,M_VH_gamma,M_VH_delta,M_PL_theta,M_PL_gamma,M_PL_delta,...
    F_IL_theta,F_IL_gamma,F_IL_delta,F_DH_theta,F_DH_gamma,F_DH_delta,F_VH_theta,F_VH_gamma,F_VH_delta,F_PL_theta,F_PL_gamma,F_PL_delta,...
    F_IL_D_theta,F_IL_D_gamma,F_IL_D_delta,F_DH_D_theta,F_DH_D_gamma,F_DH_D_delta,F_VH_D_theta,F_VH_D_gamma,F_VH_D_delta,F_PL_D_theta,F_PL_D_gamma,F_PL_D_delta,...
    F_IL_P_theta,F_IL_P_gamma,F_IL_P_delta,F_DH_P_theta,F_DH_P_gamma,F_DH_P_delta,F_VH_P_theta,F_VH_P_gamma,F_VH_P_delta,F_PL_P_theta,F_PL_P_gamma,F_PL_P_delta,...
    F_IL_E_theta,F_IL_E_gamma,F_IL_E_delta,F_DH_E_theta,F_DH_E_gamma,F_DH_E_delta,F_VH_E_theta,F_VH_E_gamma,F_VH_E_delta,F_PL_E_theta,F_PL_E_gamma,F_PL_E_delta,...
    F_IL_M_theta,F_IL_M_gamma,F_IL_M_delta,F_DH_M_theta,F_DH_M_gamma,F_DH_M_delta,F_VH_M_theta,F_VH_M_gamma,F_VH_M_delta,F_PL_M_theta,F_PL_M_gamma,F_PL_M_delta] ...
    = Format4Bootstrap_BandPower2(subjs,f,M_IL_Pxx,M_PL_Pxx,M_DH_Pxx,M_VH_Pxx,F_IL_Pxx,F_DH_Pxx,F_VH_Pxx,F_PL_Pxx);
clear *_Pxx 

    % Save the data
    disp('Saving band power data..')
    fn = 'FreqBandPow-BL-5to15_boot.mat';
    save([root_drIn '5to15' filesep fn],'F_*','M_*','subjs','-v7.3') % Done on 2020-02-26
    disp('Saved!')
    clear fn 

    
%% 4. Format for bootstrap: coherencyc                                      OK
 % SEE: Format4Bootstrap_coherency.m
% Uses data generated by Format4Bootstrap_LFP.m (above, in step 1)

% If needed, fetch bootstrap-shaped LFP data, BL arena, 5-15 cm/s movement
if ~exist('M_IL','var') || ~exist('F_IL','var')
    disp('Fetching 5-15cm/s LFP BL data')
    fn = 'LFP-BL-5to15_boot.mat';
    load([root_drIn '5to15' filesep fn],'F*','M*')
    clear fn
end

%  Calculate coherencyc: One curve per trial, BL arena, 5-15cm/s
  % Concatenating by subject causes a memory ERROR using tapers=[30 59] or
  % [45 89], not [3 5], but horrible results using so few tapers.. 
    %   "Requested 33554432x59 (29.5GB) array exceeds maximum array size preference. Creation of
    %   arrays greater than this limit may take a long time and cause MATLAB to become unresponsive.
    %   See array size limit or preference panel for more information.
    %   Error in fftfilt (line 141)
    %       B = fft(b,nfft);
    %   Error in dpss>dpsscalc (line 172)
    %     q(:,blkind) = fftfilt(E(N:-1:1,blkind),E(:,blkind));
    %   Error in dpss (line 66)
    %    [E,V] = dpsscalc(N,NW,k);
    %   Error in dpsschk (line 28)
    %     [tapers,eigs]=dpss(N,tapers(1),tapers(2));"

[f,params,M_ILDH,M_ILVH,M_ILPL,M_DHVH,M_DHPL,M_VHPL,F_ILDH,F_ILVH,F_ILPL,F_DHVH,F_DHPL,F_VHPL] ...
    = Format4Bootstrap_coherency(subjs,root_drIn,M_IL,M_DH,M_VH,M_PL,F_IL,F_DH,F_VH,F_PL);
clear M_IL M_DH M_VH M_PL F_IL F_DH F_VH F_PL

    % Save the data: Male and Female data 
    disp('Saving coherencyc data (large)...')
    fn = 'coherencyc-BL-5to15_boot.mat';
    save([root_drIn '5to15' filesep fn],'f','F_*','M_*','params','subjs','-v7.3') 
    disp('Coherencyc data saved!') %done on 2020-02-25
    clear fn params 
 
    % Plot(?) 
%     NOT SURE HOW TO DO THIS WITHOUT TRIAL-COLLAPSED DATA, AS IN POWER SPECTRA ABOVE ******************   Take animal average across trials? Median or mean?
%     clear M_* F_* f     

%% 5.1 Calculate mscohere: One curve per subject                           %ok. 5-10min/subj runtime, instant save 
 % SEE: Format4Bootstrap_mscohere.m,  
 % Uses data generated by Format4Bootstrap_LFP.m (above, in step 1)

% If needed, fetch bootstrap-shaped LFP data, BL arena, 5-15 cm/s movement
if ~exist('M_IL','var') || ~exist('F_IL','var')
    disp('Fetching 5-15cm/s LFP BL data...')
    fn = 'LFP-BL-5to15_boot.mat';
    load([root_drIn '5to15' filesep fn],'F*','M*')
    clear fn
end

% Calculate coherence (mscohere) 
disp('Calculating mscohere across subjects...')
[f,M_ILDH,M_ILVH,M_ILPL,M_DHVH,M_DHPL,M_VHPL,F_ILDH,F_ILVH,F_ILPL,F_DHVH,F_DHPL,F_VHPL] ...
    = Format4Bootstrap_mscohere(subjs,root_drIn,M_IL,M_DH,M_VH,M_PL,F_IL,F_DH,F_VH,F_PL);
clear M_IL M_DH M_VH M_PL F_IL F_DH F_VH F_PL

% Save the data: One curve per subject
disp('Saving mscohere data...')
fn = 'mscohere-BL-5to15_boot.mat';
save([root_drIn '5to15' filesep fn],'f','F_*','M_*','-v7.3') 
disp('Saved!') %done on 2020-02-27
clear fn 


%% 5.2 Calculate female mscohere: Separate each subj by estrous stage      %ok 5-10min/subj runtime, slow-ish save 
 % SEE: Format4Bootstrap_mscohereHormones.m
% Female data is indexed by hormone state, per subject

disp('Calculating mscohere for females across hormone states...')
clear F_ILDH F_ILVH F_ILPL F_DHVH F_DHPL F_VHPL % all trials concatenated, to set up for 
Fsubjs = subjs(contains(subjs,'E')); % females
[F_ILDH,F_ILVH,F_ILPL,F_DHVH,F_DHPL,F_VHPL] = Format4Bootstrap_mscohereHormones(Fsubjs,F_IL,F_DH,F_VH,F_PL);
clear Fsubjs

% Save female data alone
disp('Saving female mscohere data...')
fn = 'Female_mscohere-BL-5to15_boot.mat';
save([root_drIn '5to15' filesep fn],'f','F_*','-v7.3')
disp('Saved!')
clear fn

%% 5.3 Plot mscohere & 1 statistical tests: Sex Differences                %ok
% % SEE: PlotBoot_mscohere.m 

% Fetch mscohere data if needed
if ~exist('M_ILDH','var') || ~exist('F_ILDH','var') || size(F_ILDH,2)>1
    clear F_*
    disp('Loading mscohere data...')
    fn = 'mscohere-BL-5to15_boot.mat';
    load([root_drIn '5to15' filesep fn],'f','F_*','M_*')
    clear fn
end
 
 % Concatenate data & Check that data are shaped correctly
    Fildh = cell2mat(F_ILDH);
    Mildh = cell2mat(M_ILDH);
        Filvh = cell2mat(F_ILVH);
        Milvh = cell2mat(M_ILVH);
    Filpl = cell2mat(F_ILPL);
    Milpl = cell2mat(M_ILPL);   
        Fdhvh = cell2mat(F_DHVH);
        Mdhvh = cell2mat(M_DHVH);
    Fdhpl = cell2mat(F_DHPL);
    Mdhpl = cell2mat(M_DHPL);
        Fvhpl = cell2mat(F_VHPL);
        Mvhpl = cell2mat(M_VHPL);
clear M_* F_*

if size(Mildh,1) > size(Mildh,2) 
    Mildh = Mildh';
    Fildh = Fildh';
        Filvh = Filvh';
        Milvh = Milvh';
    Filpl = Filpl';
    Milpl = Milpl';   
        Fdhvh = Fdhvh';
        Mdhvh = Mdhvh';
    Fdhpl = Fdhpl';
    Mdhpl = Mdhpl';
        Fvhpl = Fvhpl';
        Mvhpl = Mvhpl';
end

% Plot mscohere: Sex differences, 0.5-50 Hz
%mPFCIL-dHPC
    [H1,ILDHstat.MvF] = PlotBoot_mscohere(f,Mildh,Fildh);
    title('mPFCIL - dHPC')
%mPFCIL-vHPC
    [H2,ILVHstat.MvF] = PlotBoot_mscohere(f,Milvh,Filvh);
    title('mPFCIL - vHPC')
    legend off
%mPFCIL-mPFCPL
    [H3,ILPLstat.MvF] = PlotBoot_mscohere(f,Milpl,Filpl);
    title('mPFCIL - mPFCPL')
    legend off
%dHPC-vHPC
    [H4,DHVHstat.MvF] = PlotBoot_mscohere(f,Mdhvh,Fdhvh);
    title('dHPC - vHPC')
    legend off
%dHPC-mPFCPL
    [H5,DHPLstat.MvF] = PlotBoot_mscohere(f,Mdhpl,Fdhpl);
    title('dHPC - mPFCPL')
    legend off
%vHPC-mPFCPL
    [H6,VHPLstat.MvF] = PlotBoot_mscohere(f,Mvhpl,Fvhpl);
    title('vHPC - mPFCPL')
    legend off

    % Save figures
    fd = [figdrOut 'Cohereograms\FunctionalAnova\']; %output directory
    if ~exist(fd,'dir'); mkdir(fd); end    
    saveas(H1,[fd 'ILDHmscohere-MvF-SubjSEM-5to15BL.tif'])
    saveas(H1,[fd 'ILDHmscohere-MvF-SubjSEM-5to15BL.fig'])
        close(H1); clear H1
    saveas(H2,[fd 'ILVHmscohere-MvF-SubjSEM-5to15BL.tif'])
    saveas(H2,[fd 'ILVHmscohere-MvF-SubjSEM-5to15BL.fig'])
        close(H2); clear H2
    saveas(H3,[fd 'ILPLmscohere-MvF-SubjSEM-5to15BL.tif'])
    saveas(H3,[fd 'ILPLmscohere-MvF-SubjSEM-5to15BL.fig'])
        close(H3); clear H3
    saveas(H4,[fd 'DHVHmscohere-MvF-SubjSEM-5to15BL.tif'])
    saveas(H4,[fd 'DHVHmscohere-MvF-SubjSEM-5to15BL.fig'])
        close(H4); clear H4
    saveas(H5,[fd 'DHPLmscohere-MvF-SubjSEM-5to15BL.tif'])
    saveas(H5,[fd 'DHPLmscohere-MvF-SubjSEM-5to15BL.fig'])
        close(H5); clear H5
    saveas(H6,[fd 'VHPLmscohere-MvF-SubjSEM-5to15BL.tif'])
    saveas(H6,[fd 'VHPLmscohere-MvF-SubjSEM-5to15BL.fig'])
        close(H6); clear H6

% Plot mscohere: Sex differences, Frequency bands of interest
% mPFC-IL - dHPC
    [h1,ILDHstat] = PlotBoot_mscohereBands(f,Mildh,Fildh,ILDHstat); 
    clear Mildh Fildh
%mPFCIL-vHPC
    [h2,ILVHstat] = PlotBoot_mscohereBands(f,Milvh,Filvh,ILVHstat); 
    clear Milvh Filvh
%mPFCIL-mPFCPL
    [h3,ILPLstat] = PlotBoot_mscohereBands(f,Milpl,Filpl,ILPLstat); 
    clear Milpl Filpl
%dHPC-vHPC
    [h4,DHVHstat] = PlotBoot_mscohereBands(f,Mdhvh,Fdhvh,DHVHstat); 
    clear Mdhvh Fdhvh
%dHPC-mPFCPL
    [h5,DHPLstat] = PlotBoot_mscohereBands(f,Mdhpl,Fdhpl,DHPLstat); 
    clear Mdhpl Fdhpl
%vHPC-mPFCPL
    [h6,VHPLstat] = PlotBoot_mscohereBands(f,Mvhpl,Fvhpl,VHPLstat); 
    clear Mvhpl Fvhpl

% Save figures
    saveas(h1,[fd 'ILDHmscohere-MvFbands-SubjSEM-5to15BL.tif'])
    saveas(h1,[fd 'ILDHmscohere-MvFbands-SubjSEM-5to15BL.fig'])
        close(h1); clear h1
    saveas(h2,[fd 'ILVHmscohere-MvFbands-SubjSEM-5to15BL.tif'])
    saveas(h2,[fd 'ILVHmscohere-MvFbands-SubjSEM-5to15BL.fig'])
        close(h2); clear h2
    saveas(h3,[fd 'ILPLmscohere-MvFbands-SubjSEM-5to15BL.tif'])
    saveas(h3,[fd 'ILPLmscohere-MvFbands-SubjSEM-5to15BL.fig'])
        close(h3); clear h3
    saveas(h4,[fd 'DHVHmscohere-MvFbands-SubjSEM-5to15BL.tif'])
    saveas(h4,[fd 'DHVHmscohere-MvFbands-SubjSEM-5to15BL.fig'])
        close(h4); clear h4
    saveas(h5,[fd 'DHPLmscohere-MvFbands-SubjSEM-5to15BL.tif'])
    saveas(h5,[fd 'DHPLmscohere-MvFbands-SubjSEM-5to15BL.fig'])
        close(h5); clear h5
    saveas(h6,[fd 'VHPLmscohere-MvFbands-SubjSEM-5to15BL.tif'])
    saveas(h6,[fd 'VHPLmscohere-MvFbands-SubjSEM-5to15BL.fig'])
        close(h6); clear h6
        
% Save data: Functional f-tests
fn = 'FunctionalTestStatistics-mscohere_5to15_BL_SexDiffs.mat';
save([root_drIn '5to15' filesep fn],'subjs','*stat','-v7.3')
disp('Functional test outputs saved!')
clear fn *stat f


%% 5.4 Plot mscohere & Functional statistical tests: Females only/Estrous stages
 % SEE: PlotBoot_mscohereHormones.m, PlotBoot_mscohereHormonesBands.m

% Fetch female mscohere data, separated by hormone state
disp('Fetching female mscohere data...')
fn = 'Female_mscohere-BL-5to15_boot.mat';
load([root_drIn '5to15' filesep fn],'f','F_*')
clear fn

% A: nx1  indicator of the levels of Factor A (Female hormone state)
    DiN = size(cell2mat(F_ILDH(:,1)),1); %Diestrus n count (subjects)
    ProN = size(cell2mat(F_ILDH(:,2)),1); %Proestrus n count
    EstN = size(cell2mat(F_ILDH(:,3)),1); %Estrus n count
    A(1:DiN) = 1; %Diestrus=1
    A(DiN+1:DiN+ProN)=2; %Proestrus=2
    A(DiN+ProN+1:DiN+ProN+EstN)=3; %Estrus=3
    if size(A,1) < size(A,2)
        A = A'; %orient correctly
    end
    clear DiN ProN EstN

% Concatenate data: per hormone stage
% mPFCIL - dHPC
    Dildh = cell2mat(F_ILDH(:,1)); %Diestrus
    Pildh = cell2mat(F_ILDH(:,2)); %Proestrus
    Eildh = cell2mat(F_ILDH(:,3)); %Estrus
    Mildh = cell2mat(F_ILDH(:,4)); %Metestrus
% mPFCIL - vHPC
    Dilvh = cell2mat(F_ILVH(:,1)); 
    Pilvh = cell2mat(F_ILVH(:,2)); 
    Eilvh = cell2mat(F_ILVH(:,3)); 
    Milvh = cell2mat(F_ILVH(:,4));
% mPFCIL - mPFCPL
    Dilpl = cell2mat(F_ILPL(:,1)); 
    Pilpl = cell2mat(F_ILPL(:,2)); 
    Eilpl = cell2mat(F_ILPL(:,3)); 
    Milpl = cell2mat(F_ILPL(:,4));
% dHPC - vHPC
    Ddhvh = cell2mat(F_DHVH(:,1)); 
    Pdhvh = cell2mat(F_DHVH(:,2)); 
    Edhvh = cell2mat(F_DHVH(:,3)); 
    Mdhvh = cell2mat(F_DHVH(:,4));
% dHPC - mPFCPL
    Ddhpl = cell2mat(F_DHPL(:,1)); 
    Pdhpl = cell2mat(F_DHPL(:,2)); 
    Edhpl = cell2mat(F_DHPL(:,3)); 
    Mdhpl = cell2mat(F_DHPL(:,4));
% vHPC - mPFCPL
    Dvhpl = cell2mat(F_VHPL(:,1)); 
    Pvhpl = cell2mat(F_VHPL(:,2)); 
    Evhpl = cell2mat(F_VHPL(:,3)); 
    Mvhpl = cell2mat(F_VHPL(:,4));
clear F_*

% Check that data are oriented correctly
if size(Dildh,1) > size(Dildh,2) 
    Dildh = Dildh';    Pildh = Pildh';    Eildh = Eildh';    Mildh = Mildh';  
    Dilvh = Dilvh';    Pilvh = Pilvh';    Eilvh = Eilvh';    Milvh = Milvh'; 
    Dilpl = Dilpl';    Pilpl = Pilpl';    Eilpl = Eilpl';    Milpl = Milpl'; 
    Ddhvh = Ddhvh';    Pdhvh = Pdhvh';    Edhvh = Edhvh';    Mdhvh = Mdhvh';
    Ddhpl = Ddhpl';    Pdhpl = Pdhpl';    Edhpl = Edhpl';    Mdhpl = Mdhpl';
    Dvhpl = Dvhpl';    Pvhpl = Pvhpl';    Evhpl = Evhpl';    Mvhpl = Mvhpl';  
end

% Plot mscohere: Effect of estrous stage, 0.5-50 Hz
[H1,ILDHstat] = PlotBoot_mscohereHormones(f,A,Dildh,Pildh,Eildh,Mildh);
    title('mPFCIL - dHPC')
[H2,ILVHstat] = PlotBoot_mscohereHormones(f,A,Dilvh,Pilvh,Eilvh,Milvh);
    title('mPFCIL - vHPC')
    legend off
[H3,ILPLstat] = PlotBoot_mscohereHormones(f,A,Dilpl,Pilpl,Eilpl,Milpl);
    title('mPFCIL - mPFCPL')
    legend off
[H4,DHVHstat] = PlotBoot_mscohereHormones(f,A,Ddhvh,Pdhvh,Edhvh,Mdhvh);
    title('dHPC - vHPC')
    legend off
[H5,DHPLstat] = PlotBoot_mscohereHormones(f,A,Ddhpl,Pdhpl,Edhpl,Mdhpl);
    title('dHPC - mPFCPL')
    legend off
[H6,VHPLstat] = PlotBoot_mscohereHormones(f,A,Dvhpl,Pvhpl,Evhpl,Mvhpl);
    title('vHPC - mPFCPL')
    legend off
    
    % Save figures
    fd = [figdrOut 'Cohereograms\FunctionalAnova\']; %output directory
    saveas(H1,[fd 'ILDHmscohere-Hormones-SubjSEM-5to15BL.tif'])
    saveas(H1,[fd 'ILDHmscohere-Hormones-SubjSEM-5to15BL.fig'])
        close(H1); clear H1
    saveas(H2,[fd 'ILVHmscohere-Hormones-SubjSEM-5to15BL.tif'])
    saveas(H2,[fd 'ILVHmscohere-Hormones-SubjSEM-5to15BL.fig'])
        close(H2); clear H2
    saveas(H3,[fd 'ILPLmscohere-Hormones-SubjSEM-5to15BL.tif'])
    saveas(H3,[fd 'ILPLmscohere-Hormones-SubjSEM-5to15BL.fig'])
        close(H3); clear H3
    saveas(H4,[fd 'DHVHmscohere-Hormones-SubjSEM-5to15BL.tif'])
    saveas(H4,[fd 'DHVHmscohere-Hormones-SubjSEM-5to15BL.fig'])
        close(H4); clear H4
    saveas(H5,[fd 'DHPLmscohere-Hormones-SubjSEM-5to15BL.tif'])
    saveas(H5,[fd 'DHPLmscohere-Hormones-SubjSEM-5to15BL.fig'])
        close(H5); clear H5
    saveas(H6,[fd 'VHPLmscohere-Hormones-SubjSEM-5to15BL.tif'])
    saveas(H6,[fd 'VHPLmscohere-Hormones-SubjSEM-5to15BL.fig'])
        close(H6); clear H6
         
        
% Plot mscohere/Hormones: Frequency bands of interest
[h1,ILDHstat] = PlotBoot_mscohereHormonesBands(f,Dildh,Pildh,Eildh,Mildh,ILDHstat,A);
[h2,ILVHstat] = PlotBoot_mscohereHormonesBands(f,Dilvh,Pilvh,Eilvh,Milvh,ILVHstat,A);
[h3,ILPLstat] = PlotBoot_mscohereHormonesBands(f,Dilpl,Pilpl,Eilpl,Milpl,ILPLstat,A);
[h4,DHVHstat] = PlotBoot_mscohereHormonesBands(f,Ddhvh,Pdhvh,Edhvh,Mdhvh,DHVHstat,A);
[h5,DHPLstat] = PlotBoot_mscohereHormonesBands(f,Ddhpl,Pdhpl,Edhpl,Mdhpl,DHPLstat,A);
[h6,VHPLstat] = PlotBoot_mscohereHormonesBands(f,Dvhpl,Pvhpl,Evhpl,Mvhpl,VHPLstat,A);
clear Di* Dd* Dv* E* M* P* A f
    % Save figures
    saveas(h1,[fd 'ILDHmscohere-HormonesBands-SubjSEM-5to15BL.tif'])
    saveas(h1,[fd 'ILDHmscohere-HormonesBands-SubjSEM-5to15BL.fig'])
        close(h1); clear h1
    saveas(h2,[fd 'ILVHmscohere-HormonesBands-SubjSEM-5to15BL.tif'])
    saveas(h2,[fd 'ILVHmscohere-HormonesBands-SubjSEM-5to15BL.fig'])
        close(h2); clear h2
    saveas(h3,[fd 'ILPLmscohere-HormonesBands-SubjSEM-5to15BL.tif'])
    saveas(h3,[fd 'ILPLmscohere-HormonesBands-SubjSEM-5to15BL.fig'])
        close(h3); clear h3
    saveas(h4,[fd 'DHVHmscohere-HormonesBands-SubjSEM-5to15BL.tif'])
    saveas(h4,[fd 'DHVHmscohere-HormonesBands-SubjSEM-5to15BL.fig'])
        close(h4); clear h4
    saveas(h5,[fd 'DHPLmscohere-HormonesBands-SubjSEM-5to15BL.tif'])
    saveas(h5,[fd 'DHPLmscohere-HormonesBands-SubjSEM-5to15BL.fig'])
        close(h5); clear h5
    saveas(h6,[fd 'VHPLmscohere-HormonesBands-SubjSEM-5to15BL.tif'])
    saveas(h6,[fd 'VHPLmscohere-HormonesBands-SubjSEM-5to15BL.fig'])
        close(h6); clear h6

% Save data: Functional f-tests
fn = 'FunctionalTestStatistics-mscohere_5to15_BL_Hormones.mat';
save([root_drIn '5to15' filesep fn],'subjs','*stat','-v7.3')
disp('Functional test outputs saved!')
clear fn fd 


disp('Thesis6_Format4Bootstrap_5to15.m is complete.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end of script
