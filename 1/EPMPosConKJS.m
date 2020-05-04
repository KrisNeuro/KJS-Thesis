%% EPMPosConKJS.m                                                           %% HELP HERE *************************************************
%% This might need, like, a full reboot.   12/20/2019
%     Do not zone data using this approach, rather use the ZoneTranz
%     manually-entered timestamps
%   Also maybe save any figures (do we even need these?) outside of this
%   script, into ThesisDesign



function [pos,ExpKeys] = EPMPosConKJS(pos,sessID,subjID)
% USER MANUALLY SETS EPM X/Y LIMS FOR EACH ZONE %%%%
% init: KJS 3/28/2018, 
% edit 4/10/2018, 9/24/2018, 9/25/2018 (added velocity), 6.18.2019 (changed H: to P:)
% KJS edit: 2019-10-28: changed P: to K:
% 
% REQUIRED SCRIPTS:
%     - FMAToolbox: Diff, isdscalar, isdvector, LinearVelocity
%     - getd
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\toolboxes\FMAToolbox\Analyses')
addpath('K:\Personal Folders\Kristin Schoepfer\MATLAB\gitRepo\toolboxes\FMAToolbox\General')



YDir = 'normal'; % 'reverse' flips the y axis
%YDir = 'reverse';
XDir = 'normal'; % 'reverse' flips the x axis
rot = 0; % if user wants to change rotational orientation
% extract_varargin;

% if isempty(getd(pos,'x'))
    % return
% end

% Set color maps
color(1,:) = [0.2157    0.7178    0.9259]; %light blue          OPEN
color(2,:) = [0.5258    0.7223    0.4648]; %light forest green  CLOSED
color(3,:) = [0.9664    0.5651    0.4267]; %pastel red          CENTER

	%% CLOSED ARM BOX
	figure('units','normalized','outerposition',[0 0 1 1]);
	% plot(pos.coord(1,:), pos.coord(2,:),'.','Color',[0.7 0.7 0.7],'MarkerSize',4)
	plot(getd(pos,'x'),getd(pos,'y'),'.','Color',[0.7 0.7 0.7],'MarkerSize',4)
	title('Set CLOSED arm X boundaries with 2 mouse clicks');
	set(gca,'YDir',YDir,'XDir',XDir); 
    view(rot,90); % view(az,el) zaxis is rot and elevation is 90.
	xlabel('X data'); ylabel('Y data');
    axis square
	hold on

	[Cx,~] = ginput(2);

	xlims = get(gca,'xlim');
	ylims = get(gca,'ylim');

	plot([Cx(1) Cx(1)],ylims,'LineWidth',4,'Color','k');
	plot([Cx(2) Cx(2)],ylims,'LineWidth',4,'Color','k');
	pause(1);

	% title('Define Y boundary with two mouse clicks');
	title('Set CLOSED arm Y boundaries with 2 mouse clicks');

	[~,Cy] = ginput(2);

	plot(xlims,[Cy(1) Cy(1)],'LineWidth',4,'Color','k');
	plot(xlims,[Cy(2) Cy(2)],'LineWidth',4,'Color','k');
	pause(1);
	close

	Cx = sort(Cx); % we don't want negative conversion factors, right?
	Cy = sort(Cy);

% 	Cxdiff_cm = Cx(2) - Cx(1);
	% xConvFact = xdiff_pixel / realTrackDims(1); % conversion factor for x data
% 	Cydiff_cm = Cy(2) - Cy(1);
	% xConvFact = xdiff_pixel / realTrackDims(1);


	%% OPEN ARM BOX
	figure('units','normalized','outerposition',[0 0 1 1]);
	% plot(pos.coord(1,:), pos.coord(2,:),'.','Color',[0.7 0.7 0.7],'MarkerSize',4)
	plot(getd(pos,'x'),getd(pos,'y'),'.','Color',[0.7 0.7 0.7],'MarkerSize',4)
	title('Set OPEN arm X boundaries with 2 mouse clicks');
	set(gca,'YDir',YDir,'XDir',XDir); 
    view(rot,90); % view(az,el) zaxis is rot and elevation is 90.
	xlabel('X data'); ylabel('Y data');
    axis square
	hold on

	[Ox,~] = ginput(2);

	xlims = get(gca,'xlim');
	ylims = get(gca,'ylim');

	plot([Ox(1) Ox(1)],ylims,'LineWidth',4,'Color','k');
	plot([Ox(2) Ox(2)],ylims,'LineWidth',4,'Color','k');
	pause(1);

	% title('Define Y boundary with two mouse clicks');
	title('Set OPEN arm Y boundaries with 2 mouse clicks');

	[~,Oy] = ginput(2);

	plot(xlims,[Oy(1) Oy(1)],'LineWidth',4,'Color','k');
	plot(xlims,[Oy(2) Oy(2)],'LineWidth',4,'Color','k');
	pause(1);
	close

	Ox = sort(Ox); % we don't want negative conversion factors, right?
	Oy = sort(Oy);

% 	Oxdiff_cm = Ox(2) - Ox(1);
	% xConvFact = xdiff_pixel / realTrackDims(1); % conversion factor for x data
% 	Oydiff_cm = Oy(2) - Oy(1);
	% yConvFact = ydiff_pixel / realTrackDims(2); % conversion factor for y data
	% convFact = [xConvFact yConvFact];

	%% CENTER ZONE
	figure('units','normalized','outerposition',[0 0 1 1]);
	% plot(pos.coord(1,:), pos.coord(2,:),'.','Color',[0.7 0.7 0.7],'MarkerSize',4)
	plot(getd(pos,'x'),getd(pos,'y'),'.','Color',[0.7 0.7 0.7],'MarkerSize',4)
	title('Set CENTER ZONE X boundaries with 2 mouse clicks');
	set(gca,'YDir',YDir,'XDir',XDir); 
    view(rot,90); % view(az,el) zaxis is rot and elevation is 90.
	xlabel('X data'); ylabel('Y data');
	axis square
	hold on

	[Cenx,~] = ginput(2);

	xlims = get(gca,'xlim');
	ylims = get(gca,'ylim');

	plot([Cenx(1) Cenx(1)],ylims,'LineWidth',4,'Color','k');
	plot([Cenx(2) Cenx(2)],ylims,'LineWidth',4,'Color','k');
	pause(1);

	% title('Define Y boundary with two mouse clicks');
	title('Set CENTER ZONE Y boundaries with 2 mouse clicks');

	[~,Ceny] = ginput(2);

	plot(xlims,[Ceny(1) Ceny(1)],'LineWidth',4,'Color','k');
	plot(xlims,[Ceny(2) Ceny(2)],'LineWidth',4,'Color','k');
	pause(1);
	close

	Cenx = sort(Cenx); % we don't want negative conversion factors, right?
	Ceny = sort(Ceny);

% 	Cenxdiff_pix = Cenx(2) - Cenx(1);
	% xConvFact = xdiff_pixel / realTrackDims(1); % conversion factor for x data
% 	Cenydiff_pix = Ceny(2) - Ceny(1);
	% yConvFact = ydiff_pixel / realTrackDims(2); % conversion factor for y data
	% convFact = [xConvFact yConvFact];


%% Exclusive-ize open and closed arm data
	% CENTER ZONE
		cenxdat = find((pos.data(1,:)>Cenx(1)) & (pos.data(1,:)<Cenx(2)));
		cenydat = find((pos.data(2,:)>Ceny(1)) & (pos.data(2,:)<Ceny(2)));
		cendat_idx = intersect(cenxdat,cenydat,'stable'); %INDEX of all center zone positions
		
	% CLOSED ZONE
		% index all pos.data that are within closed arm xlims and ylims
		cxdat = find((pos.data(1,:)>Cx(1)) & (pos.data(1,:)<Cx(2)));
		cydat = find((pos.data(2,:)>Cy(1)) & (pos.data(2,:)<Cy(2)));
		cdat_idx = intersect(cxdat,cydat,'stable');	% INDEX of all closed arm w/in X-Y ranges (includes center zone points)
 
		%exclude center coordinates that are within center zone
			deleteThese = intersect(cdat_idx,cendat_idx,'stable'); %INDEX of where closed and center points overlap
			KeepIdx = [1:length(pos.data)]; %INDEX template for exclusion points
			KeepIdx(:,deleteThese) = [];	%all points without center/closed zone overlaps
		cdat_keepidx = intersect(cdat_idx,KeepIdx,'stable'); %INDEX of closed zone points only
    clear KeepIdx
     
	% OPEN ZONE
		oxdat = find((pos.data(1,:)>Ox(1)) & (pos.data(1,:)<Ox(2)));
		oydat = find((pos.data(2,:)>Oy(1)) & (pos.data(2,:)<Oy(2)));
		odat_idx = intersect(oxdat,oydat,'stable');	%ALL open arm points within range (includes center zone points)   
        
		%exclude center coordinates that are within center zone
        deleteThese2 = intersect(odat_idx,cendat_idx,'stable'); %exclusive INDEX of where open and center points overlap
        deleteThese3 = intersect(odat_idx,cdat_keepidx,'stable'); %exclusive INDEX of where open and closed points overlap
        deleteThese23 = union(deleteThese2, deleteThese3,'stable'); %inclusive INDEX of all non-open points that overlap with odat_idx
        KeepIdx = [1:length(pos.data)];
        KeepIdx(:,deleteThese23) = [];	%all points without center zone
        odat_keepidx = intersect(odat_idx,KeepIdx,'stable'); %INDEX of good points
        clear KeepIdx deleteThese deleteThese2 deleteThese3 deleteThese23
  
    % index of non-outlier points (to keep)
    newidx = [cendat_idx cdat_keepidx odat_keepidx];
    newidx = sort(newidx);
    
    % index of outlier points (to remove)
    oldidx = 1:length(pos.data);
    outies = setdiff(oldidx,newidx); %index of outlier points in original pos.data
     
    % assign zone to time and data points
    [pos.center.pixdat] = pos.data(:,cendat_idx); %PIXELS of center zone
    [pos.center.tvec] = pos.tvec(:,cendat_idx); %TIMES in center zone
    [pos.center.index] = cendat_idx;  %INDEX of all center zone positions
    
    [pos.closed.pixdat] = pos.data(:,cdat_keepidx);	% PIXELS of closed zone points only
    [pos.closed.tvec] = pos.tvec(:,cdat_keepidx); %TIMES in closed zone
    [pos.closed.index] = cdat_keepidx; %INDEX of closed zone points only
    
    [pos.open.pixdat] = pos.data(:,odat_keepidx); %PIXELS of open zone points only
    [pos.open.tvec] = pos.tvec(:,odat_keepidx); %TIMES in open zone
    [pos.open.index] = odat_keepidx;  %INDEX of all open zone positions

%------------------------------------------------------------------    
%% Figure: identify outlier points to be removed
outfig = figure('units','normalized','outerposition',[0 0 1 1]);
    plot(pos.data(1,:),pos.data(2,:),'k.')
    axis square
    hold on
    plot(pos.data(1,outies),pos.data(2,outies),'ro','MarkerSize',10)
    legend Original 'Outliers excluded'
    title(sessID,'interpreter','none')
    xlabel('X data (pixels)')
    ylabel('Y data (pixels)')
pause(1);
	%save figure as .png
    cd('K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\figs\VT\EPM')
    if ~exist([pwd filesep subjID],'dir')
        mkdir([pwd filesep subjID])
    end
    cd(subjID)
	outfigsave = [sessID deal('_OutliersExcluded')];
	saveas(outfig,outfigsave,'png')
	disp('Outlier exclusion image saved as .png')
	close(outfig)
    clear outfigsave outfig
%------------------------------------------------------------------
    
%% Remove outlier points: zoneidx
    pos.data(:,outies) = NaN; %from pixel data. testing vs '[]'
    pos.tvec(outies) = NaN; %from time vector
    
    % align zone indices into one logical vector
    [pos.zoneidx] = false(3,length(oldidx)); %initialize vector
%     [pos.zoneidx(1,pos.center.index)] = 1; %center zone
%     [pos.zoneidx(2,pos.closed.index)] = 1; %closed zone
%     [pos.zoneidx(3,pos.open.index)] = 1; %open zone
    [pos.zoneidx(1,pos.open.index)] = 1; % open zone
    [pos.zoneidx(2,pos.closed.index)] = 1; %closed zone
    [pos.zoneidx(3,pos.center.index)] = 1; %center zone
	
% 	
%------------------------------------------------------------------
%% Figure: All XY data in pixels, outliers removed
pixzones = figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,2,1) %OPEN
	plot(pos.open.pixdat(1,:), pos.open.pixdat(2,:),'.','color',color(1,:));
	title('open','fontsize',14)
	xlim([min(pos.data(1,:)-10) max(pos.data(1,:)+10)])
	ylim([min(pos.data(2,:)-10) max(pos.data(2,:)+10)])
	axis square
subplot(2,2,2) %CLOSED
	plot(pos.closed.pixdat(1,:), pos.closed.pixdat(2,:),'.','color',color(2,:));
	title('closed','fontsize',14)
xlim([min(pos.data(1,:)-10) max(pos.data(1,:)+10)])
	ylim([min(pos.data(2,:)-10) max(pos.data(2,:)+10)])
	axis square
subplot(2,2,3) %CENTER
	plot(pos.center.pixdat(1,:), pos.center.pixdat(2,:),'.','color',color(3,:));	
	title('center','fontsize',14)
    xlim([min(pos.data(1,:)-10) max(pos.data(1,:)+10)])
	ylim([min(pos.data(2,:)-10) max(pos.data(2,:)+10)])
	axis square
subplot(2,2,4) %ALLDAT
	plot(pos.open.pixdat(1,:), pos.open.pixdat(2,:),'.','color',color(1,:));
	hold on
	plot(pos.closed.pixdat(1,:), pos.closed.pixdat(2,:),'.','color',color(2,:));
	plot(pos.center.pixdat(1,:), pos.center.pixdat(2,:),'.','color',color(3,:));	
    xlim([min(pos.data(1,:)-10) max(pos.data(1,:)+10)])
	ylim([min(pos.data(2,:)-10) max(pos.data(2,:)+10)])
	legend open closed center
	axis square 
	xlabel('X data (pixels)')
	ylabel('Y data (pixels)')
    set(gca,'fontsize',14)
pause(1); 

	%save figure as .png
    cd('K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\figs\VT\EPM')
    cd(subjID)
	pixsave = [sessID deal('_pix')];
	saveas(pixzones,pixsave,'png')
	disp('Pixel EPM image saved as .png')
	close(pixzones)
%------------------------------------------------------------------

%% Convert pixel location -> cm coordinates
% centimeter dimensions of behavior chamber
EPM_L = 44 *2.54; %EPM total length in inches (same for open and closed arms, end-to-end interior walls) = 44 inches -> cm conversion
realTrackDims = [EPM_L EPM_L]; % true x width and y width of Kabbaj lab rat EPM, in centimeters
    clear EPM_L
	
% data-based x width and y width
	xWidth = range(pos.open.pixdat(1,:));	%open arms = X axis
	yWidth = range(pos.closed.pixdat(2,:)); %closed arms = Y axis
	ExpKeys.realTrackDims = [xWidth yWidth];	%data X-Y dimensions in pixels
% pixel -> cm conversion factors
	xConvFact = xWidth / realTrackDims(1); % conversion factor for x data
	yConvFact = yWidth / realTrackDims(2);% conversion factor for y data
	convFact = [xConvFact yConvFact];
	ExpKeys.convFact = [convFact];	%dimension conversion factor
% Convert from pixels -> cm using ConvFact
    [pos.center.coord] = [pos.center.pixdat(1,:)./ExpKeys.convFact(1); pos.center.pixdat(2,:)./ExpKeys.convFact(2)];
    [pos.closed.coord] = [pos.closed.pixdat(1,:)./ExpKeys.convFact(1); pos.closed.pixdat(2,:)./ExpKeys.convFact(2)];
    [pos.open.coord] = [pos.open.pixdat(1,:)./ExpKeys.convFact(1); pos.open.pixdat(2,:)./ExpKeys.convFact(2)];
%EPM zone outlines: conversion to cm
    [Cenx] = Cenx./ExpKeys.convFact(1); %center zone
    [Ceny] = Ceny./ExpKeys.convFact(2);
    [Ox] = Ox./ExpKeys.convFact(1); %open zone
    [Oy] = Oy./ExpKeys.convFact(2); 
    [Cx] = Cx./ExpKeys.convFact(1); %closed zone
    [Cy] = Cy./ExpKeys.convFact(2); 

%% Coord figures (2)
	%set axes limits
	x1 = min(pos.open.coord(1,:) -10);
	x2 = max(pos.open.coord(1,:) +10);
	y1 = min(pos.closed.coord(2,:) -10);
	y2 = max(pos.closed.coord(2,:) +10);

cmzones = figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,2,1)
	plot(pos.open.coord(1,:), pos.open.coord(2,:),'.','color',color(1,:));
	title('open','fontsize',14)
	xlim([x1 x2])
	ylim([y1 y2])
	axis square
subplot(2,2,2)
	plot(pos.closed.coord(1,:), pos.closed.coord(2,:),'.','color',color(2,:));
	title('closed','fontsize',14)
	xlim([x1 x2])
	ylim([y1 y2])
	axis square
subplot(2,2,3)
	plot(pos.center.coord(1,:), pos.center.coord(2,:),'.','color',color(3,:));	
	title('center','fontsize',14)
	xlim([x1 x2])
	ylim([y1 y2])
	axis square
subplot(2,2,4)
	plot(pos.open.coord(1,:), pos.open.coord(2,:),'.','color',color(1,:));
	hold on
	plot(pos.closed.coord(1,:), pos.closed.coord(2,:),'.','color',color(2,:));
	plot(pos.center.coord(1,:), pos.center.coord(2,:),'.','color',color(3,:));	
	xlim([x1 x2])
	ylim([y1 y2])
	legend open closed center
	axis square 
	xlabel('X data (cm)')
	ylabel('Y data (cm)')
    set(gca,'fontsize',14)
pause(2); 

%save figure as .png
	cmsave = [sessID deal('_coord')];
	saveas(cmzones,cmsave,'png')
	disp('XY adjustment image saved as .png')
	close(cmzones)
    clear cmzones
%------------------------------------------------------------------
cmall = figure('units','normalized','outerposition',[0 0 1 1]);
    plot(pos.open.coord(1,:), pos.open.coord(2,:),'.','color',color(1,:));
	hold on
	plot(pos.closed.coord(1,:), pos.closed.coord(2,:),'.','color',color(2,:));
	plot(pos.center.coord(1,:), pos.center.coord(2,:),'.','color',color(3,:));
	xlim([x1 x2])
	ylim([y1 y2])
	legend open closed center
	axis square 
	xlabel('X data (cm)')
	ylabel('Y data (cm)')
    sessid2 = strrep(sessID,'_',' ');
	title(sessid2)
    set(gca,'fontsize',14)
pause(2); 

%save figure as .png
	cmsave = [sessID deal('_zoned')];
	saveas(cmall,cmsave,'png')
	disp('XY adjustment image saved as .png')
	close(cmall)
    clear cmall cmsave
%------------------------------------------------------------------

%% Heatmap of EPM location
% %listing of all coord spots
% [pos.allcoord] = zeros(2,length(oldidx));
% [pos.allcoord(:,cendat_idx)] = pos.center.coord; %center zone data
% [pos.allcoord(:,cdat_keepidx)] = pos.closed.coord; %center zone data
% [pos.allcoord(:,odat_keepidx)] = pos.open.coord; %open zone data
% [pos.allcoord(:,outies)] = NaN;
% epmheat = hist3(pos.allcoord',[round(EPM_L) round(EPM_L)]);
% [pos.epmheat] = epmheat';
% 
% eheat = figure('units','normalized','outerposition',[0 0 1 1]);
% 	image(epmheat');
% 	axis square;
% 	axis xy;
% 	colorbar; 
% 	colormap('jet')
% 	title(sessid2)
% 	xlabel('X data (cm)')
% 	ylabel('Y data (cm)')
% pause(2);
% 
% %save figure as .png
% 	esave = [sessID deal('_heat')];
% 	saveas(eheat,esave,'png')
% 	disp('EPM heatmap image saved as .png')
% 	close(eheat)
%     clear esave eheat

%% Logical zoning figure
%above: open, closed, center 1-2-3 
t0 = pos.tvec - min(pos.tvec); %start time from 0
zoneidx = figure('position',[40 300 1860 670]);
barz = pos.zoneidx*1; %convert from logical values to double values
ax(1) = subplot(411); %OPEN
    bar(t0,barz(1,:),'stacked','facecolor',color(1,:))
    set(gca,'ytick',[],'xtick',[],'fontsize',14)
    title('open zone')
ax(2) = subplot(412); %CENTER
    bar(t0,barz(3,:),'stacked','facecolor',color(3,:))
    set(gca,'ytick',[],'xtick',[],'fontsize',14)
    title('center zone')
ax(3) = subplot(413); %CLOSED
    bar(t0,barz(2,:),'stacked','facecolor',color(2,:))
    set(gca,'ytick',[],'xtick',[],'fontsize',14)
    title('closed zone')
ax(4) = subplot(414);
    bar(t0,barz(1,:),'stacked','facecolor',color(1,:))
    hold on
    bar(t0,barz(2,:),'stacked','facecolor',color(2,:))
    bar(t0,barz(3,:),'stacked','facecolor',color(3,:))
    legend open closed center
    legend('location','best')
linkaxes(ax,'x');
    title('All zone indices')
    xlabel('time (min)')
    set(gca,'ytick',[],'fontsize',14)
% adjust X ticks to reflect time in seconds
xlim([0 600])
xticks([0:30:600])
xticklabels([0:0.5:10])
box off
pause(1);

%save figure as .png
	zsave = [sessID deal('_ZoneIdx')];
	saveas(zoneidx,zsave,'png')
	disp('EPM zone index figure saved as .png')
	close(zoneidx)
    clear zsave barz
%------------------------------------------------------------------

%% Calculate linear velocity
t0 = pos.tvec-(min(pos.tvec)); %start time from 0
X = [t0; pos.allcoord(1,:); pos.allcoord(2,:)];
X(:,outies) = []; %remove NaNs
smoov = round(1/(median(diff(pos.tvec),'omitnan'))); %number of samples per sec
X=X'; %flip arrangement so LinearVelocity can read the data as: [t x y]
V = LinearVelocity(X,smoov); % (:,1) = smoothed time vector; (:,2) = linear velocity(cm/s)
    %for LinearVelocity to run, the optional tests at the bottom of 'isdvector' need to be commented out
[pos.V] = V';

[pos.totaldist] = sum(pos.V(2,:))/range(pos.V(1,:))/100; %total distance traveled in 600sec (in meters)
%------------------------------------------------------------------
%% Linear velocity plot
h2 = figure('position',[15 560 1880 420]); 	

	plot(V(:,1),V(:,2),'k','linewidth',1)	    
	xlabel('Time (s)'); 
	ylabel('Linear velocity (cm/s)');
	title([subjID ' ' sessid2]);
    set(gca,'fontsize',14)
    pause(1);
    
%save figure as .png
	vsave = [sessID deal('_LinearVelocity')];
	saveas(h2,vsave,'png')
	disp('Linear Velocity figure saved as .png')
	close(h2)
    clear h2 vsave V
%------------------------------------------------------------------

% %% Movie figure: coordinates and EPM zone index
% zoname = {'open', 'closed', 'center'}; %zone names for title in movie
% moviezones = pos.zoneidx.*1; %change from logical to double values
% moviezones(:,outies) = [];
% h = figure('units','normalized','outerposition',[0 0 1 1]);
% moviename = [subjID '_' sessID '.gif'];
%     subplot(421) %OPEN ZONE
%         b1 = bar(X(1,1),moviezones(1,1),'stacked','facecolor',color(1,:),'edgecolor',color(1,:));
%         set(gca,'xlim',[min(X(:,1)) max(X(:,1))],'xtick',[],'ylim',[0 1],'ytick',[],'fontsize',14)
%         title('open zone idx')
%     subplot(423) %CENTER ZONE
%         b2 = bar(X(1,1),moviezones(3,1),'stacked','facecolor',color(3,:),'edgecolor',color(3,:));
%         set(gca,'xlim',[min(X(:,1)) max(X(:,1))],'xtick',[],'ylim',[0 1],'ytick',[],'fontsize',14)
%         title('center zone idx')
%     subplot(425) %CLOSED ZONE
%         b3 = bar(X(1,1),moviezones(2,1),'stacked','facecolor',color(2,:),'edgecolor',color(2,:));
%         set(gca,'xlim',[min(X(:,1)) max(X(:,1))],'xtick',[],'ylim',[0 1],'ytick',[],'fontsize',14)
%         title('closed zone idx')
%     subplot(427) %LINEAR VELOCITY
%         vplot = plot(X(1,1),pos.V(2,1),'k');
%         set(gca,'xlim',[min(X(:,1)) max(X(:,1))],'ylim',[0 round(max(pos.V(2,:))+3)],'fontsize',14)
%         ylabel('cm/s')
%         title('Linear velocity')
%     subplot(122)
%         allscat = scatter(X(1,2),X(1,3),'.k');  
%         hold on
%         epmscat = scatter(X(1,2),X(1,3),'xr','linewidth',3,'sizedata',100);
%         set(gca,'xlim',[min(Ox)-5 max(Ox)+5],'ylim',[min(Cy)-5 max(Cy)+5],'fontsize',14)
%         axis square
%         xlabel('X data (cm)')
%         ylabel('Y data (cm)')
%         tit = zoname{find(moviezones(:,1)==1)};
%         title(tit,'color',color(:,find(moviezones(:,1)==1)))
%         hold on;
%         %open zone box
%             openboxX = [Ox(1), Ox(2), Ox(2), Ox(1), Ox(1)];
%             openboxY = [Oy(1), Oy(1), Oy(2), Oy(2), Oy(1)];
%         %closed zone box
%             closedboxX = [Cx(1), Cx(2), Cx(2), Cx(1), Cx(1)];
%             closedboxY = [Cy(1), Cy(1), Cy(2), Cy(2), Cy(1)];
%         %center zone box
%             centerboxX = [Cenx(1), Cenx(2), Cenx(2), Cenx(1), Cenx(1)];
%             centerboxY = [Ceny(1), Ceny(1), Ceny(2), Ceny(2), Ceny(1)];
%         
%         plot(openboxX,openboxY,'linewidth',2,'color',color(1,:));
%         plot(closedboxX,closedboxY,'linewidth',2,'color',color(2,:));
%         plot(centerboxX,centerboxY,'linewidth',2,'color',color(3,:));
%         hold off;
%         
% % Play movie, write to .gif file
% tn = 1:smoov:length(moviezones);
% nImages = length(tn);
% 
% for ti=1:smoov:length(moviezones)
%         subplot(421) %OPEN ZONE
%             set(b1,'xdata',X(1:ti,1),'ydata',moviezones(1,1:ti))
%         subplot(423) %CENTER ZONE
%             set(b2,'xdata',X(1:ti,1),'ydata',moviezones(3,1:ti))
%         subplot(425) %CLOSED ZONE
%             set(b3,'xdata',X(1:ti,1),'ydata',moviezones(2,1:ti))
%         subplot(427) %VELOCITY
%             set(vplot,'xdata',pos.V(1,1:ti),'ydata',pos.V(2,1:ti))
%         subplot(122) %XY SCATTER
%             set(allscat,'xdata',X(1:ti,2),'ydata',X(1:ti,3))
%             set(epmscat,'xdata',X(ti,2),'ydata',X(ti,3))
%             tit = zoname{find(moviezones(:,ti)==1)};
%         title(tit,'color',color(find(moviezones(:,ti)==1),:))
%          
%       drawnow
% 
%     % capture plot as an image
%       frame = getframe(h);
%       im = frame2im(frame);
%       [imind,cm] = rgb2ind(im,256);
%       
%     % write to the gif file
%       if ti==1
%           imwrite(imind,cm,moviename,'gif','delaytime',0.1)
%       else
%           imwrite(imind,cm,moviename,'gif','WriteMode','append','delaytime',0.2); %gif will playback at 5X speed
%       end
% end %gif movie
% 
% disp('gif movie complete!')
% close(h)       


%% Wrap up any useful variables into ExpKeys or pos
% [ExpKeys.outies] = outies; %save outlier index in 'pos'
[ExpKeys.fps] = smoov; %frames per second
	
end %function 