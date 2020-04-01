%% ImportVTBL.m 
% imports baseline Video Tracker file from drIn
% INPUTS:
	% drIn/drInvid		Input directory containing VT1.nvt file (already
	% adjusted)
%
% OUTPUTS: 
	%[pos]		Animal X-Y positional information
	%[coord] 	Animal location coordinates
	%h1			Plot of X-Y location for the whole recording
%
% REQUIRED SCRIPTS:
	% LoadPos2
	% PosConKJS
	% getd
	% LinearVelocity
%
% Created by KJS with assistance from NS&B2017, Youki Tanaka (vdMeer lab).
% 
% KJS edit: 2019-10-31: Adjusted sequence of events, added padding and
% upsampling to 'Trim to LFP' portion
% KJS edit: 2019-11-10: Divide pos.totaldist by 100 to convert cm -> m (duh)
%
%% function [pos,ExpKeys] = ImportVT(drInvid,eegtsec)
function [pos,ExpKeys] = ImportVTBL(drInvid,eegtsec,Fs)
% Add paths to functions if necessary
if ~exist('LoadPos2.m','file')
    addpath(uigetdir(pwd,'Select file path containing LoadPos2.m'))
end
if ~exist('getd.m','file')
    addpath(uigetdir(pwd,'Select file path containing getd.m  (util)'))
end
if ~exist('PosConKJS.m','file')
    addpath(uigetdir(pwd,'Select file path containing PosConKJS.m'))
end
if ~exist('LinearVelocity.m','file')
    a = uigetdir(pwd,'Select file path containing LinearVelocity.m  (\Analyses)');
    addpath(a)
    addpath([a(1:end-8) 'General']) % contains Diff, used in LinearVelocity
    clear a
end

tic; 	% start timer

%% Load and Linearize Position Data
cd(drInvid) %set working directory to drIn.

% Read positional data from NLX format
disp('Reading video data...');
cfg_in = [];	% using an empty config loads the position data in the default units of pixels:
pos = LoadPos2(cfg_in);	% load the position data using LoadPos2(). Automatically detects .NVT file in drIn
    %LoadPos2.m was edited from LoadPos.m; 'pos' is no longer in a tsd object

disp('Video tracking import ok')
toc;	%end VT import timer

%% Plot position data
    % position data is accessed using the function getd()
    % if you want the x data points, x = getd(pos,'x');
figure;
    plot(getd(pos,'x'),getd(pos,'y'),'.','Color',[0.7 0.7 0.7],...
        'MarkerSize',4); 
    xlabel('x data'); 
    ylabel('y data');
    axis square;
    title('X-Y data; press any key to continue');
    pause; close;

    % centimeter dimensions of behavior chambers
    realTrackDims = [46 46]; % true x width and y width of Kabbaj Lab BL box, in centimeters

    %% Convert location in pixels to centimeters & Set box boundaries
       %important in PosCon.m: no mirroring or rotation is necessary!
    [convFact,x,y] = PosConKJS(pos,realTrackDims);
    ExpKeys.convFact = convFact;	%dimension conversion factor

    %% Exclude parallaxed datapoints in pos.data
    % copy x and ylims into ExpKeys
    ExpKeys.xlims = x;
    ExpKeys.ylims = y;

    % index all pos.data that are within xlims and ylims
    xidx = find((pos.data(1,:)>ExpKeys.xlims(1)) & (pos.data(1,:)<ExpKeys.xlims(2)));
    yidx = find((pos.data(2,:)>ExpKeys.ylims(1)) & (pos.data(2,:)<ExpKeys.ylims(2)));
    keepidx = intersect(xidx,yidx); %elements common to both x and y indices

    [pos.data] = pos.data(:,keepidx); 	% adjusted XY vals
    [pos.tvec] = pos.tvec(:,keepidx);	% corresponding time vector

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

    %% Getting Position Data Conversion Factors	
    % data-based x width and y width
        xWidth = range(pos.data(1,:));
        yWidth = range(pos.data(2,:));
        ExpKeys.realTrackDims = [xWidth yWidth];	%data dimensions in pixels

    % Making a Coord File: Converting pixels to cm units
        % See MakeCoord.m for more information
    [pos.coord] = [pos.data(1,:)/ExpKeys.convFact(1); pos.data(2,:)/ExpKeys.convFact(2)];

    %% Calculate Linear Velocity
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