function [] = AddScriptPaths()
%%AddScriptPaths
%
% Adds required function scripts and dependencies for KJS/Thesis data analysis.
%
%
% KJS init: 2020-04-07
%


% Full list of scripts called
sxpts = {'export_fig.m'
'Diff.m'
'HilbKJS.m' 
'ImportCSC2.m' 
'ImportVTBL.m' 
'ImportVTEPM.m' 
'LinearVelocity.m'
'PowSpec.m' 
'removePLI.m' 
'TotalDistanceTraveled.m' 
'VelDist.m' 
'VelCumDist.m'};


% if license == "731138" %user = KJS
    % Function scripts
	disp('Select gitRepo root folder for Thesis .m files')
	gitRepo = [uigetdir(pwd,'Select gitRepo root folder for Thesis .m files') filesep]; % Thesis scripts
		addpath(genpath(gitRepo)) 
		
	disp('Select root .m toolbox folder')
	tbox = [uigetdir(gitRepo,'Select root .m toolbox folder') filesep]; % toolboxes		
		addpath([tbox 'FMAToolbox\Analyses']) % contains LinearVelocity
		addpath([tbox 'FMAToolbox\General']) % contains Diff, a LinearVelocity dependency
		addpath(genpath([tbox 'MouseHPC\shared\io'])) % scripts called in VT import
        addpath([tbox 'MouseHPC\shared\util']) % scripts called in VT import
        addpath([tbox 'MouseHPC\shared\linearize']) % scripts called in VT import
		
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