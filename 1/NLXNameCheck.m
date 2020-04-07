%% NLXNameCheck.m 
%	Checks that raw NLX data files for a certain drIn are titled appropriately
%	ie: Raw file comes out as 'CSC1.ncs'. But we need it to be 'CSC01.ncs' for ImportCSC.m to register appropriately
%	
%	Call as:  NLXNameCheck(drIn);
%
%	init: KJS 3/29/2018
% 	edit 3/30/2018 KJS: Changed lines 22 and 34, added disp
%	edit 4/3/18 KJS: Fixed for timestamped filenames, + switch
%   edit 4/11/2019 KJS: Commented out line 13
function NLXNameCheck(drIn)

% 	cd(drIn)
	
	%CSC files
		files = dir('*.ncs');
		for id = 1:length(files)
			[~, f] = fileparts(files(id).name); %get file name minus extension
			len = length(f);
			switch len
				case 4 %if it's a single-digit filename (ex: 'CSC1.ncs')
					num = str2double(f(4)); %get the channel starting #
					movefile(files(id).name, sprintf('CSC%02d.ncs', num)); %pad single-digit with a 0, cut timestamps, etc
					disp(sprintf('CSC%02d was renamed.', num))
				case 5 %ok double-digit name (ex: 'CSC10.ncs')
					disp(f); disp(' File name ok.')
				otherwise %if it's a timestamped filename (ex: 'CSC1_24468987:1359087.ncs')
					num = (f(4:5)); %get the channel starting # (char)
					if num(end)~='_' %double-digit CSC with timestamp tag ending
						num = str2double(f(4:5));
						newname = sprintf('CSC%d',num); %'CSC##'
						movefile(files(id).name, sprintf('%s.ncs', newname)); %rename as 'CSC##.ncs'
						disp(sprintf('CSC%d was renamed.', num))
					else %if single-digit CSC with timestamp tag ending
						num = str2double(f(4));
						movefile(files(id).name, sprintf('CSC%02d.ncs', num)); %pad single-digit with a 0, cut timestamps, etc
						disp(sprintf('CSC%02d was renamed.', num))
					end
			end %switch
		end %for
		
	%SE files
		files = dir('*.nse');
		for id = 1:length(files)
			[~, f] = fileparts(files(id).name); %get file name minus extension
			if length(f)~=3 %if it's not named: 'SE#.nse'
				num = str2double(f(3)); %get the channel starting #
				movefile(files(id).name, sprintf('SE%d.nse', num)); %cut timestamps, etc from file name
				disp(sprintf('SE%d was renamed.', num))
			else
				disp(f); disp(' File name ok.')
			end
		end
		
	% VT file (only 1. Needs modification for more than 1 VT in drIn)
		files = dir('*.nvt');
		[~, f] = fileparts(files(1).name); %get file name minus extension
		if length(f)~=3 %if it's not named: 'SE#.nse'
			num = str2double(f(3)); %get the channel starting #
			movefile(files(1).name, sprintf('VT%d.nvt', num)); %cut timestamps, etc from file name
			disp('VT was renamed.')
		else
			disp(f); disp(' File name ok.')
		end

		
end