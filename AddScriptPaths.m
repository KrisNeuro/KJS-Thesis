function [] = AddScriptPaths()
%%AddScriptPaths
%
% Adds required function scripts and dependencies for KJS/Thesis data analysis.
%
% 	Open-source functions/packages:		SOURCE:
%	- chronux 				http://chronux.org/
%	- colorcet 				https://peterkovesi.com/projects/colourmaps/
%	- export_fig 				https://github.com/altmany/export_fig
%	- FMAToolbox				http://fmatoolbox.sourceforge.net/
%	- padcat				https://www.mathworks.com/matlabcentral/fileexchange/22909-padcat
%	- removePLI				https://github.com/mrezak/removePLI
%	- shadedErrorBar			https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar
%	- regoutliers 				https://www.mathworks.com/matlabcentral/fileexchange/37212-regression-outliers
%
%
% KJS init: 2020-04-07
%


% Full list of scripts called
sxpts = {'colorcet.m'
'Data.m' 
'EndTime.m'
'export_fig.m'
'Diff.m'
'HilbKJS.m' 
'ImportCSC2.m' 
'ImportVTBL.m' 
'ImportVTEPM.m' 
'LinearVelocity.m'
'NLXNameCheck.m'
'padcat.m'
'PowerEnvelope.m'
'PowSpec.m' 
'Range.m'
'ReadCSC_TF.m'
'ReadCSC_TF_tsd.m'
'regoutliers.m'
'removePLI.m' 
'StartTime.m'
'TotalDistanceTraveled.m' 
'VelDist.m' 
'VelCumDist.m'};


% Function scripts
disp('Select gitRepo root folder for Thesis .m files')
gitRepo = [uigetdir(pwd,'Select gitRepo root folder for Thesis .m files') filesep]; % Thesis scripts
	addpath(genpath(gitRepo)) 

% Toolboxes
disp('Select root .m toolbox folder')
tbox = [uigetdir(gitRepo,'Select root .m toolbox folder') filesep]; % toolboxes
addpath([tbox 'export_fig']) %contains export_fig.m
	addpath([tbox 'FMAToolbox\Analyses']) % contains LinearVelocity.m
	addpath([tbox 'FMAToolbox\General']) % contains Diff.m, dependency of LinearVelocity 
	addpath(genpath([tbox 'MouseHPC\shared\io'])) % VT import dependencies
addpath([tbox 'MouseHPC\shared\util']) % VT import dependencies
addpath([tbox 'MouseHPC\shared\linearize']) % VT import dependencies


% Check things were added
for i = 1:length(sxpts)
	fullFileName = sxpts{i};
	if ~exist(fullFileName, 'file') % File does not exist in path
	  warningMessage = sprintf('Warning: file does not exist in path:\n%s', fullFileName);
	  uiwait(msgbox(warningMessage));
	  fprintf('Please select folder containing: %s\n',fullFileName)
	  addpath(uigetdir(gitRepo,sprintf('Select folder containing: %s',fullFileName)))
	end
end
disp('Good to go!')

end %function
