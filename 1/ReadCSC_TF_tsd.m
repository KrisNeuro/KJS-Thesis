function [eeg, sFreq, ts] = ReadCSC_TF_tsd(fname, start_ts, end_ts, output_sFreq)

% ReadCR_tsd  Reads a CSC file (NT format) and returns a tsd
%
% [eeg, sFreq] = ReadCSC_tsd_TF(fname, start_ts, end_ts, output_sFreq)
%
% INPUTS:
%       fname = full filename of Cheetah_NT CSC*.dat file 
%       start_ts, end_ts (optional) = start and end timestamps of portion to read
%       output_sFreq (optional) = frequency at which to resample data
% OUTPUTS:
%       eeg = tsd of the csc data
%       sFreq = sampling frequency of data in eeg output (same as
%       10000/median(diff(Range(eeg,'ts'))) )
%
% IMPORTANT NOTE regarding CHEETAH SAMPLING FREQUENCIES:
%   older Cheetah versions report misleading sampling frequencies in the
%   EEG data files.  To be safe, ALWAYS compute the actual sampling rate from the data by a matlab line 
%   such as:
%   ts = Range(eeg,'ts');  % ts = array of timestamps in 0.1 msec units
%   sFreq = 10000/median(diff(ts));
%
%   The sampling frequency reported by ReadCR_tsd now uses this code to
%   compute sFreq. You don't have to do it again!
%
% ADR 1999, version 1.0, last modified June 24, 2013 by T. Forster
%
% status PROMOTED
% cowen Sat Jul  3 14:59:47 1999
% lipa  modified for NT   Jul 18 1999
% o Got rid of the diplay progress and rounded the timestamps
% o Fixed the dT to be in timestamps 
% o Added a dummy value to the end of cr.ts
% o Made the for look go to nBlocks and not nBlocks -1 
% cowen 2001
% o returns sampling freq.
%       ReadCR_nt returns 2 arrays and 1 double of the form...
%       ts = nrec x 1 array of the timestamps that start each block.
%       cr = nrec x 512 array of the data
%       sFreq = sampling frequency of the data in eeg
% cowen modified to use the partial load version of ReadCR_nt
%
% lipa Jan, 2010
% now returns a sFreq estimated from data, not the one reported by Cheetah.


if nargin >= 3
    [ts,csc,~] = ReadCSC_TF(fname,start_ts, end_ts);  %  timestamps ts are in 0.1 milliseconds units!!!!!
elseif nargin == 1
    [ts,csc,~] = ReadCSC_TF(fname);  %  timestamps ts are in 0.1 milliseconds units!!!!!
elseif nargin == 2
    error('Invalid number of inputs')
end

%overwrite sFreq with actual sampling freqency estimate from data (don't
%trust the value reported by cheetah)
sFreq = 512*10000/median(diff(ts));  

if nargin < 4
    output_sFreq = [];
end

%Does it make it here
nBlocks = size(csc,1);
% Reuse csc to save space.
csc=single(reshape(csc',1,length(csc(:))));
blockSize = 512;
dT = 10000/sFreq; % in tstamps
TIME = zeros(size(csc));
ts = [ts;ts(end) + 512*dT];     
for iBlock = 1:(nBlocks)
  %DisplayProgress(iBlock, nBlocks-1);
  TIME((blockSize * (iBlock-1) + 1):(blockSize * iBlock)) = ...
      linspace(ts(iBlock), ts(iBlock+1) - dT, blockSize);
end
%Create the tsd object. Perhaps a waste.
% output_sFreq is indeed empty because it was set empty. 
% The problem here is that the tsd function is not putting anything in.
if isempty(output_sFreq)
    eeg = tsd(TIME', csc');
else
%   resample data
    st = TIME(1);
    et = TIME(end);
    n_out = round(((et-st)/10000)*output_sFreq);
    sFreq = output_sFreq;
    eeg  = tsd(linspace(st,et,n_out)', interp1(TIME, csc, linspace(st,et,n_out))');
end
disp ('Reading Raw EEG Complete: A tsd object, "eeg", should have been made.');
end