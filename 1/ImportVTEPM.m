%ImportVTEPM
% imports EPM Video Tracker file in drIn

% INPUTS:
	% drIn		Input directory containing CSC files, trimmed for the session (if applicable). Set in ImportPrep.m

% OUTPUTS: 
	%[pos]		Animal X-Y positional information
	%[coord] 	Animal location coordinates
	%h1			Plot of X-Y location for whole recording

% REQUIRED SCRIPTS:
	% LoadPos2.m
	% PosCon.m
	% MakeCoord.m
	% getd.m
	% EPMPosConKJS.m
	
% Created by KJS with assistance from NS&B2017, Youki Tanaka (vdMeer lab).
% KJS edit 8.15.2018: Trim length of pos to range of LFP ts
% KJS edit 2019-12-20: Re-organize, added upsampling to 2kHz portion like ImportVTBL
%
function [pos,ExpKeys] = ImportVTEPM(drInvid,sessID,subjID,eegtsec,Fs)

tic; 	% start timer

%% Read in Position Data
cd(drInvid)

% Read positional data from NLX format
disp('Reading video data...');
cfg_in = [];	% using an empty config loads the position data in the default units of pixels:
pos = LoadPos2(cfg_in);	% load the position data using LoadPos2(). Automatically detects .NVT file in drIn
    %LoadPos2.m was edited from LoadPos.m; 'pos' is no longer in a tsd object

disp('Video tracking import ok')
toc;	%end VT import timer

% %% Trim length of recording to match LFP data
% if length(pos.tvec)>18100 %10 mins @ 30Hz frame rate (+3.3s wiggle room)
% %     trim2 = 30*60*10; %desired length (in 30Hz timepoints)
%     [c index] = min(abs(pos.tvec-eegtsec(1)));
%     pos.tvec = pos.tvec(index:end);
%     pos.data = pos.data(:,index:end);
%     [pos.index] = index; 
%     clear trim2 c index 
% end

%% Plot position data
	% position data is accessed using the function getd()
	% if you want the x data points, x = getd(pos,'x');
figure;
	plot(getd(pos,'x'),getd(pos,'y'),'.','Color',[0.7 0.7 0.7],'MarkerSize',4); 
	xlabel('x data'); ylabel('y data');
    axis square;
	title('X-Y data; press any key to continue');
	pause;	close;

    %% Convert location in pixels to centimeters, Set zone boundaries, calculate linear velocity
    % This function auto-saves figures.
    [pos,ExpKeys] = EPMPosConKJS(pos,sessID,subjID);    %% HELP HERE *************************************************
    

     %% Pad pos.data with repeats of last sample and extend pos.tvec
    % This will remove oscillator ring at end of data created from 'upsample' below
    pad = pos.tvec(end) + median(diff(pos.tvec))*(1:2000); %time vector pad of 2000 frames (at 30 fps)
    pos.tvec = [pos.tvec pad]; %padded time vector
    pos.data = padarray(pos.data,[0 2000],'replicate','post'); %padded positional data: repeat end coordinates for 2000 more samples

    %% Upsample pos to match LFP sampling frequency
    [pos.data,pos.tvec] = resample(pos.data',pos.tvec,Fs);
    pos.data = pos.data';

    %% Trim length of recording to match LFP data
    if range(pos.tvec)>600 %10 mins length (600 sec)
        [~, index1] = min(abs(pos.tvec-eegtsec(1)));
        [~, index2] = min(abs(pos.tvec-eegtsec(end)));
        pos.tvec = pos.tvec(index1:index2);
        pos.data = pos.data(:,index1:index2);
        clear index*
    end
	
    % EDIT HERE DOWN
    
     % Getting Position Data Conversion Factors	
    % data-based x width and y width
        xWidth = range(pos.data(1,:));
        yWidth = range(pos.data(2,:));
        ExpKeys.realTrackDims = [xWidth yWidth];	%data dimensions in pixels

    % Making a Coord File: Converting pixels to cm units
        % See MakeCoord.m for more information
    [pos.coord] = [pos.data(1,:)/ExpKeys.convFact(1); pos.data(2,:)/ExpKeys.convFact(2)];

    % Calculate Linear Velocity
    t0 = pos.tvec-(min(pos.tvec)); %start time from 0
    X = [t0; pos.coord(1,:); pos.coord(2,:)];
    smoov = round(1/(median(diff(pos.tvec),'omitnan'))); %window for smoothing=1s, in # of samples per sec (should be 2000)
    X=X'; %flip arrangement so LinearVelocity can read the data as: [t x y]
    V = LinearVelocity(X,smoov); % (:,1) = smoothed time vector; (:,2) = linear velocity(cm/s)
        %for LinearVelocity to run, the optional tests at the bottom of 'isdvector' need to be commented out
    [pos.V] = V';

    %% Total distance traveled
    [pos.totaldist] = sum(pos.V(2,:))/range(pos.V(1,:))/100; %total distance traveled in 600sec (in meters)

end


