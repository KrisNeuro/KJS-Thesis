%% PowSpec
%PowSpec. Computes and plots Fourier coefficients from all channels in a recording
%   Uses MATLAB functions 'fft' and 'pwelch'
function [fourierCoefs,frex,Pxx,f,powspecfig,powspecfig2] = PowSpec(AllDat,Fs)

nyquist = Fs/2; %Nyquist frequency
nS = size(AllDat,2); % # of channels 
N = size(AllDat,1); 

window = Fs*0.4; %size of window
overlap = window *0.9; %window overlap
nfft = Fs*2;

% initialize Fourier output matrix
fourierCoefs = zeros(size(AllDat)); 

% These are the actual frequencies in Hz that will be returned by the
% Fourier transform. The number of unique frequencies we can measure is
% exactly 1/2 of the number of data points in the time series (plus DC).
    frex = linspace(0,nyquist,floor(N/2)+1);

%% Discrete Fourier transform
% for ci = 1:nS %loop thru CSCs
%     disp(['Computing PowSpec for channel: ', num2str(ci)]);
%     csc = AllDat(:,ci);
%     [fourierCoefs(:,ci)] = fft(csc)/N;
% %     [dbnorm(:,ci)] = 10*log10( bsxfun(@rdivide,AllPowSpec(:,ci),mean(AllPowSpec(:,ci),2)));
% end
fourierCoefs = fft(AllDat)./N;
disp('fourierCoefs complete.');

%% Power spectra: Welch method
[Pxx,f] = pwelch(AllDat,window,overlap,nfft,Fs); % [2001 x nS]

% Limit frequency vector data: 0.5-100 Hz
% f
    if max(f)>100
        fidx = find(f==100);
        f = f(1:fidx)';
        Pxx = Pxx(1:fidx,:);
    end
    if min(f)<0.5
        fidx = find(f==0.5);
        f = f(fidx:end);
        Pxx = Pxx(fidx:end,:);
    end
% frex
    if max(frex)>100
        fidx = find(frex==100);
        frex = frex(1:fidx);
        fourierCoefs = fourierCoefs(1:fidx,:);
    end
clear fidx



% Plot
disp('Plotting fourierCoefs...')
powspecfig = figure('units','normalized','outerposition',[0 0 1 1]);
for ci = 1:nS
    subplot(4,4,ci)
    plot(frex,(abs(fourierCoefs(1:length(frex),ci))*2));
%     plot(frex,10*log10(real(fourierCoefs(1:length(frex),ci))));
    xlim([0.5 100])
    xticks(0:20:100)
    xlabel('Frequency (Hz)'); 
    ylabel('Fourier coeff. (\muV)')
    title(['CSC: ' num2str(ci)])
end
pause(2);

% Welch method (edited 2018-12-18, KJS)
disp('Computing and plotting power spectra (Welch method)...')
powspecfig2 = figure('units','normalized','outerposition',[0 0 1 1]);
for ci = 1:nS
    subplot(4,4,ci)
%     [Pxx(:,ci)] = pwelch(AllDat(:,ci),window,overlap,nfft,Fs);
    plot(10*log10(Pxx(:,ci)),'linew',1);
    xlim([0.5 100])
    axis square
    xticks(0:20:100)
    xlabel('Frequency (Hz)'); 
    ylabel('Power (dB/Hz)')
    title(['CSC: ' num2str(ci)])
end
pause(2);



end