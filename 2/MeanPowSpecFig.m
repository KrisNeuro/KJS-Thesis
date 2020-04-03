%% MeanPowSpecFig
% Computes & plots mean power spectra across recordings for each channel (pwelch)
%
% KJS edit 2019-10-28: Changed P: to K: (CoM IT server transfer)
% KJS edits 2019-12-30, 2020-01-02: Made compatible with ThesisDesign.m
% 
function [h1,PX,mPxx] = MeanPowSpecFig(files)

% Preallocate space
PX = zeros(200,16,length(files));

% Load first recording Pxx and frequency vector (f)
load(files{1}, 'Pxx','f');

[PX(:,:,1)] = Pxx(:,:);
clear Pxx

for i = 2:length(files)
    fprintf('Loading Pxx from file %d of %d\n', i, length(files))
    load(files{i}, 'Pxx')
    [PX(:,:,i)] = Pxx(:,:);
    clear Pxx
end

% Average Pxx across recordings (3rd dimension)
mPxx = mean(PX,3);

%% Plot avg. power spectra per channel, 0-100 Hz
nS = size(mPxx,2);    % number of channels (==16)

h1 = figure('units','normalized','outerposition',[0 0 1 1]);
for ci = 1:nS
    subplot(4,4,ci)
    plot(f,10*log10(mPxx(:,ci)),'k')
    xlim([0 100])
    xlabel('Frequency (Hz)'); 
    ylabel('Avg. Power (dB)')
    title(['CSC: ' num2str(ci)])
    axis square
end

end