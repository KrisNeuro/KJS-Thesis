%% HilbKJS
%HilbKJS: Apply Hilbert transform to theta-filtered LFP data
% function [thetadata,itpc,prefAngle] = HilbKJS(thetadata)
function [thetadata,prefAngle] = HilbKJS(thetadata)
disp('Applying Hilbert transform to thetadata...')
apet = getfield(thetadata,'av_pow_env_ts'); 
thetadata = rmfield(thetadata,'av_pow_env_ts'); %remove avg power envelope timestamps
names = fieldnames(thetadata); 

prefAngle = zeros(length(names),1);
for ci = 1:length(names)    %loop thru channels
    [thetadata.(names{ci}).hilb] = hilbert(thetadata.(names{ci}).s); %apply hilbert transform
    [thetadata.(names{ci}).ang] = angle(thetadata.(names{ci}).hilb); %get angles from hilbert
%     [thetadata.(names{ci}).itpc] = abs(mean(exp(1i*thetadata.(names{ci}).ang))); %inter-trial phase clustering....not yet used
%     itpc(ci,1) = thetadata.(names{ci}).itpc;
    prefAngle(ci,1) = angle(mean(exp(1i*thetadata.(names{ci}).ang))); %preferred phase angle
end
[thetadata.av_pow_env_ts] = apet; %replace avg power envelope timestamps
disp('Hilbert complete.')
end