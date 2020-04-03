function [Vrex,Vall,h1] = VelDist(subjID,rt,Rxlist,root_drIn)
%% [Vrex,Vall] = VelDist(subjID,rextype)
% Collects and plots the distribution of a subject's linear velocity for all recordings of a certain type (BL/EPM)
% 
%   Called by fxns: VelocityDistribution.m, Thesis1_ImportPreprocess.m
% 
%   Calls upon:
%   - BLlistCheck.m
%   - EPMlistcheck.m
% 
% KJS init: 2019/03/13
% KJS edit 2019-10-28: Changed P: to K: (CoM IT server transfer)
% KJS edit 2019-11-14: Added Vall as output. Edited saved file names (figure and data) to append '-upsampledVT' for 2kHz-sampled VT files
% KJS edit 2020-02-17: Adapted for Thesis1_ImportPreprocess.m. Moved saving figure and data outside function.

%% Get linear velocity vectors for each recording

% Preallocate output space
Vrex = cell(1,length(Rxlist)); 

% Loop thru recordings
for ri=1:length(Rxlist)
    fprintf('Loading VT data: %d of %d\n',ri,length(Rxlist))
    load([root_drIn subjID filesep subjID '_' Rxlist{ri} '_AllDat.mat'],'pos') %Load pos and LFP timestamp vector
    Vrex{ri} = deal(pos.V); %Linear velocity for each recording. Vectors vary in length
    clear pos
end
clear ri

% Concatenate all velocities into a single vector
Vall = cat(2,Vrex{1,:});
Vall = Vall(2,:); %velocities only, don't want timestamps for histogram

% Find min and max velocity of all recordings for this subject
% minV = min(cellfun(@min,Vrex));
% maxV = max(cellfun(@max,Vrex));
% minV = min(Vall);
% maxV = max(Vall);

%% Plot histogram of velocity distribution
h1 = histogram(Vall);
    h1.Normalization = 'probability';
    h1.FaceColor = [0 0 0];
    xlabel('Velocity (cm/s)')
    ylabel('Probability')
    title([subjID ' ' rt ' velocity distribution'])

end %function