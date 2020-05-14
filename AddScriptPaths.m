function [] = AddScriptPaths()
%%AddScriptPaths
%
% Adds required function scripts and dependencies for KJS/Thesis data analysis.
%
% 	Open-source functions/packages:		SOURCE:
%	- chronux 				http://chronux.org/
%	- colorcet 				https://peterkovesi.com/projects/colourmaps/
%	- export_fig 			https://github.com/altmany/export_fig
%	- FMAToolbox			http://fmatoolbox.sourceforge.net/
%   - NLX to MATLAB         https://neuralynx.com/software/category/matlab-netcom-utilities
%	- padcat				https://www.mathworks.com/matlabcentral/fileexchange/22909-padcat
%	- removePLI				https://github.com/mrezak/removePLI
%	- shadedErrorBar		https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar
%	- regoutliers 			https://www.mathworks.com/matlabcentral/fileexchange/37212-regression-outliers
%
%
% KJS init: 2020-04-07
%


% Full list of scripts called
sxpts = {'BandPowerCrossCorr.m'
'barPLV.m'
'ChanScreen.m'
'coherencyc.m'
'colorcet.m'
'DataViz_IndividualChannelPower.m'
'Diff.m'
'EndTime.m'
'EPMPosConKJS.m' 
'export_fig.m'
'FindFile.m' 
'FindFiles.m' 
'Format4Bootstrap_BandPower.m'
'Format4Bootstrap_coherency.m'
'Format4Bootstrap_LFP.m'
'Format4Bootstrap_mscohere.m'
'Format4Bootstrap_mscohereHormones.m'
'Format4Bootstrap_Rsq.m'
'Format4Bootstrap_thetaphaselagdH.m'
'get_direct_prob.m'
'get_bootstrapped_sample.m'
'getd.m' 
'GetDataDuration.m'
'HilbKJS.m' 
'ImportCSC.m' 
'ImportVTBL.m' 
'ImportVTEPM.m' 
'ksampL2.m'
'LinearVelocity.m'
'LoadPos2.m'
'MakeCoord.m' 
'MeanPowSpecFig.m'
'mtcsg.m'
'mtparam.m'
'Nlx2MatVt.m' 
'NLXNameCheck.m'
'padcat.m'
'PowerEnvelope.m'
'PowSpec.m' 
'PowSpec5to15Trials.m'
'PowSpec5to15_Hormones.m'
'PowSpec5to15.m'
'PlotBoot_PowSpecMvHormsBands.m'
'PlotBoot_PowSpecMvHorms.m'
'PlotBoot_PowSpecHormonesBands.m'
'PlotBoot_PowSpecHormones.m'
'PlotBoot_PowSpecBands.m'
'PlotBoot_PowSpec.m'
'PlotBoot_mscohereMvHormsBands.m'
'PlotBoot_mscohereMvHorms.m'
'PlotBoot_mscohereHormonesBands.m'
'PlotBoot_mscohereHormones.m'
'PlotBoot_mscohereBands.m'
'PlotBoot_mscohere.m'
'PlotBoot_Coherencyc.m'
'PosConKJS.m'
'ProcessConfig.m' 
'ReadCSC_TF.m'
'ReadCSC_TF_tsd.m'
'regoutliers.m'
'removePLI.m' 
'StartTime.m'
'ThetaPhaseLagdH.m'
'TotalDistanceTraveled.m' 
'tsd.m'
'twosampF.m'
'VelDist.m' 
'VelCumDist.m'
'ZscoreRsq_boot2.m'};


% Function scripts
disp('Select KJSThesis-master folder containing Thesis .m files')
gitRepo = [uigetdir(pwd,'Select KJSThesis-master folder containing Thesis .m files') filesep]; % Thesis scripts
addpath(genpath(gitRepo)) 

% Toolboxes
disp('Select root .m toolbox folder')
tbox = [uigetdir(gitRepo,'Select root .m toolbox folder') filesep]; % Toolboxes dir. Contains: colorcet.m, regoutliers.m
addpath([tbox 'chronux\spectral_analysis\continuous']) %contains coherencyc.m
addpath([tbox 'export_fig']) %contains export_fig.m
addpath([tbox 'FMAToolbox\Analyses']) % contains LinearVelocity.m
addpath([tbox 'FMAToolbox\General']) % contains Diff.m, dependency of LinearVelocity 
addpath([tbox 'padcat']) %contains padcat.m
addpath([tbox 'removePLI']) %contains removePLI.m
addpath([tbox 'shadedErrorBar']) %contains shadedErrorBar.m
addpath(genpath([tbox 'MouseHPC\shared\io'])) % VT import dependencies
addpath([tbox 'MouseHPC\util']) % VT import dependencies
addpath([tbox 'MouseHPC\linearize']) % VT import dependencies
addpath(genpath([tbox 'MouseHPC\io'])) % VT import dependencies



% Check things were added
for i = 1:length(sxpts)
	fullFileName = sxpts{i};
	if ~exist(fullFileName, 'file') % File does not exist in path
	  warningMessage = sprintf('Warning: file does not exist in path:\n%s', fullFileName);
	  uiwait(msgbox(warningMessage));
	  fprintf('Please select folder containing: %s\n',fullFileName)
	  addpath(uigetdir(tbox,sprintf('Select folder containing: %s',fullFileName)))
	end
end
disp('Good to go!')

end %function
