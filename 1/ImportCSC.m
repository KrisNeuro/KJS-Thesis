%% ImportCSC.m 
% Imports and pre-cleans CSC files from NLX format from drIn.
% Also filters for theta band and does power analysis on the theta band.
%
% CALLS UPON:
% - NLXNameCheck.m
% - ReadCSC_TF_tsd.m
% - Data.m
% - Range.m
% - removePLI.m     (source: https://github.com/mrezak/removePLI)
% - PowerEnvelope.m
% - StartTime.m, EndTime.m
% 
% OUTPUTS:
%   - AllDat        Timeseries of pre-processed data for each (16) channel
%   - thetadata     Timeseries of theta-band data for each (16) channel
%   - Fs            Sampling frequency of downsampled data (2000 Hz)
% 
% KJS edit 2019-04-11: Flexibility for function input
% KJS edit 2019-10-28: Changed P: to K: (CoM IT server transfer)
% KJS edit 2019-12-20: Added flexibility to addpath at the beginning,shifted those addpaths to ThesisDesign
% 
function [EEG,thetadata,AllDat,Fs]= ImportCSC(drIn)
%% Setup

% Ensure drIn ends with a file separator
if ~strcmp(drIn(end),filesep)
    drIn = [drIn filesep];
end

tic;	%begin timer
list = dir([drIn '*.ncs']);	%get listing of .ncs files in drIn

% Check that CSC files exist in drIn
if ~isempty(list) 	
    disp('CSC files found.');
else
    fprintf('Error: CSC files not found. Press RETURN to continue.');
    fclose('all');
    return
end

%% Rename .ncs (CSC) files as needed
    %example: rename 'CSC1.ncs' to 'CSC01.ncs'
NLXNameCheck(drIn);
list = dir([drIn '*.ncs']);	%fix listing of file names

%% Read in CSC data
for i=1:length(list)    %loop thru channels (1-16)
	fileName = list(i).name;
    ch = fileName(1:5);
    %read CSC into tsd object 'eeg'
        disp('Reading CSC data...');
        [eeg, sFreq, ts] = ReadCSC_TF_tsd([drIn fileName]); 
        s = Data(eeg);	%samples
        t = Range(eeg);	%timestamps
        
    %% Highpass filter (cheby1)
        lowlimit = 0.5;
%         highlimit = inf('single');
        N = 8; %filter order
        Fpass1 = lowlimit;      % First Passband Frequency
%         Fpass2 = highlimit;     % Second Passband Frequency
        Apass  = 0.1;           % Passband Ripple (dB)

        % Construct an FDESIGN object and call its CHEBY1 method.
        h  = fdesign.highpass('N,Fp,Ap', N, Fpass1, Apass, sFreq);
        Hd = design(h, 'cheby1');

		% filter with filtfilt to correct phase
        sos = Hd.sosMatrix;
        g = Hd.ScaleValues;
        s = double(s);
        disp('Highpass filtering data...')
        F = filtfilt(sos,g,s);
        clear s sos g Apass Fpass1 Fpass2 h Hd lowlimit highlimit N ts      
        
%% 60Hz attenuation filter (removePLI.m)
    M = 6; 		% number of harmonics to remove
    B = [50 .05 1];		
    P = [0.1 4 1];  	
    W = 8;				
    f_ac = 60; %nominal AC frequency to be removed (in Hz)
    disp('Removing 60Hz PLI...')
    F = removePLI(F, sFreq, M, B, P, W, f_ac);
    clear M B P W f_ac
    
%% Downsample from 32kHz to 2kHz
    t = downsample(t, 16);		%%% 2kHz timestamps for unfiltered EEG data
    F = downsample(F, 16);  	%%% 2kHz unfiltered EEG data per channel           
    Fs = sFreq/16; %reduced sampling rate
    clear sFreq

%% Epoch to 10 mins (12*10^5 points)
if length(t)>1200001
    trim2 = 12*10^5; %desired length (in 2kHz Fs points)
    t = t(end-trim2:end);
    F = F(end-trim2:end);
    clear trim2
end
      
    %% Filter for theta
    binsize_sec = 0.4; %size of timebins in which to compute avg. theta power, in seconds
    disp('Filtering data for Theta');
    Fn = Fs/2;             % Nyquist Frequency
    Wp = [4  12]/Fn;         % Theta Passband
    Ws = [2.5 13.5]/(Fs/2);  %Theta StopBand
    Rp = 3;                 %ripple pass
    Rs = 40;                %ripple stop
    [n,Wn] = buttord(Wp,Ws,Rp,Rs);
    [z, p, k] = butter(n,Wn,'bandpass');
    [sos,g] = zp2sos(z,p,k);
    filt = dfilt.df2sos(sos,g);
    
    thetadata.(ch).s = [];
    thetadata.(ch).s = filter(filt,F);	% All data filtered for theta, downsampled to 2kHz
    clear Fn Wp Ws Rp Rs n Wn sos z p k filt g
    
    %% Theta Power vs Time 
    pow = (thetadata.(ch).s).^2;
    
         %% PowerEnvelope
        [ts_env,pow_env, PeaksIdx] = PowerEnvelope(t,pow);
            disp('Power Envelope ok.'); 
        
             tstart = StartTime(eeg);
             tend = EndTime(eeg);
             pow_ts_interp = tstart:100:tend;    % timestamp intervals corresponds to 100 Hz sampling rate
             pow_env_interp = interp1(ts_env,pow_env,pow_ts_interp);    

            % binsize in number of sample points at 100Hz sampling rate (downsampled from 32kHz)
             binsize = (binsize_sec)*100;

            % truncate end so that length is exactly a  multiple of binsize
            pow_ts_interp(end-mod(length(pow_ts_interp),binsize)+1:end) = [];  
            pow_env_interp(end-mod(length(pow_env_interp),binsize)+1:end) = [];

            %calculate averages over binsize by reshaping and averaging over columns
            av_pow_ts = mean(reshape(pow_ts_interp',binsize,length(pow_ts_interp)/binsize))';
            av_pow_env = mean(reshape(pow_env_interp',binsize,length(pow_env_interp)/binsize))';
			
            thetadata.(ch).Pow = pow;
			thetadata.(ch).PeaksIdx = PeaksIdx;	%index of theta power peaks
			thetadata.(ch).av_pow_env = av_pow_env;	%average theta power envelope
		
    disp('Power env and interp ok.');


% Place data in final output locations
EEG.(ch) = F;
AllDat(:,i) = F;

end	% end for loop
EEG.t = t; %time vector
thetadata.av_pow_env_ts = av_pow_ts;	%put the avg power envelope timestamps as its own independent vector within 'thetadata'

toc	%end timer

end	% function
