function [d,h,dh] = TotalDistanceTraveled(subjID,Rxlist)
% [d,dh] = TotalDistanceTraveled(subjID,BLlist)
%Compiles total distance traveled for all trials one one arena type(BL/EPM)
% 
% Calls 'pos.totaldist' from each 'subjID_BLlist{i}_AllDat.mat'
% Scatter plots total distance across sessions (days), does not save figure
% 
% Outputs:
%   - d     pos.totaldist across trials (in meters)
%   - h     Cumulative distribution of velocities. Each cell contains data
%           from 1 trial. 
%           h{trial}(1,:) = velocities
%           h{trial}(2,:) = cumulative distribution values
%
%   CALLED BY:
%   - TotalDistanceTraveled_batch.m
%   - ThesisDesign.m
%
% 
% KJS init 5/9/2019
% KJS edit 2019-12-19: Changed BLlist to Rxlist
% KJS edit 2020-01-17: Added cumulative distribution output 'h'
 
%%  
% Preallocate space
d = zeros(size(Rxlist));
h = cell(size(Rxlist));

%% Compile all total distances traveled
for i=1:length(Rxlist)
    fprintf('VT %i of %i\n',i,length(Rxlist))
    load([Rxlist{i} '.mat'],'pos')
    d(i) = deal(pos.totaldist); %total distance traveled
    j = cdfplot(pos.V(2,:)); %cumulative distribution of velocities
    h{i} = [j.XData; j.YData]; % X = velocities, Y = cumulative distribution
    clear pos j
end
clear i
close all

%% Plot
dh = figure;
    scatter(1:length(Rxlist),d,'ko','filled')
    xlabel('Recording session #')
    ylabel('meters (10min)')
    title([subjID ' Total distance traveled, Familiar arena'])
    ax=gca;
    ax.TickLabelInterpreter = 'none';
    ax.XTickLabelMode = 'manual';
    ax.XTickMode = 'manual';
    box off
    xticks(1:length(Rxlist))
    xticklabels(1:length(Rxlist))
    xtickangle(45)
    set(ax,'fontsize',10,'TitleFontSizeMultiplier',2)
    ax.YLabel.FontSize = 16;
    ax.XLabel.FontSize = 16;
    set(gcf,'Position',[135 367 989 390])
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KJS notes to self:
% 
% Upsampled VT (2kHz) BL completed: 
    % A201 done on 
    % A202 done on 
    % A301 done on 
    % E105 done on 
    % E106 done on 
    % E107 done on 
    % E108 done on 
    % A602 done on
    % E201 done on
% 
% BL total distance traveled finished sets:  (30 fps VT)
    % A201 done on 2/21/2019
    % A202 done on 2/26/2019
    % E105 done on 3/11/2019
    % E106 done on 3/11/2019    #14 is high
    % E107 done on 3/12/2019    #1 is high
    % E108 done on 3/12/2019    #1, 4, 16 are high
    % A102 done on 3/12/2019    only 2/4 BL VT files are present. Recommended not to use
    % A301 done on 5/8/2019
