%DummyHeadMic
close all
clear all;
clc

% pause(25);

for k = 1:1

% pause on;
% pause(5);   %time for leaving the room!
% pause off;

%% TEST INPUT SIGNAL GENERATION %%
ctrl_fadein     = true;
ctrl_fadeout    = true;
% Generation of sine sweep
fs = 44100;
sweeplength = 3; %sweep length in seconds
fstart      = 55;%55;
fend        = fs/2;%24100;    %Possible values 20k and 24k
A           = 0.9;%0.025; for 0.6m%0.6;%for 1m distance%0.7;%for1.5m

[x_original, xinv, f_t]=gensweep_far(fs,sweeplength,fstart,fend,0,A);

%a = linspace(0,1,sweeplength*fs+1);
%x_original = x_original.*a;

x_original = x_original';
xinv = xinv';

%correlation factor 
CorrFac = A^2*sweeplength*fs*pi*(fstart/fend-1)/...
        (2 * (2*pi*fend/fs - 2*pi*fstart/fs) * log(fstart/fend));

if ctrl_fadein
    % fadein for avoiding overshoots at the beginning
    nsin = 0.2*fs;%62500;                                       
    t = 0:1/2*pi/(nsin-1):1/2*pi;
    fadein = flipud(cos(t)');

    x_original(1:nsin)      = x_original(1:nsin)          .*fadein;
    xinv((end-nsin+1):end)  = xinv      ((end-nsin+1):end).*flipud(fadein);

%     figure;
%     plot(x_original(1:nsin),'k');
%     title('Fade-in of x_{original}')
end

if ctrl_fadeout
    % fadeout for avoiding undershoots at the end
    nsout = 625;                                       
    t = 0:1/2*pi/(nsout-1):1/2*pi;
    fadeout = cos(t)';

    x_original((end-nsout+1):end) = x_original((end-nsout+1):end).*fadeout;
    xinv(1:nsout)                 = xinv(1:nsout)                .*flipud(fadeout);

%     figure;
%     plot(x_original((end-nsout+1):end),'k');
%     title('Fade-out of x_{original}')
else
%     figure;stem(f_t(end-2000:end),x_original(end-2000:end));
    
    n_last          = fs;       % last second
    x_sqrt          = x_original(end-n_last:end).^2;
    x_peak          = 1./x_sqrt;
    [pk_val,pk_idx] = findpeaks(x_peak);
    
    f_t_last        = f_t(end-n_last:end);
    pk_idx_short    = pk_idx(f_t_last(pk_idx)<24000);
    idx_cut         = n_last + 1 - max(pk_idx_short);
    f_vec = f_t_last(pk_idx);
    
    x_original(end-idx_cut+1:end)                   = zeros(length(x_original(end-idx_cut+1:end)),1);
    xinv(1:length(x_original(end-idx_cut+1:end)))   = zeros(length(x_original(end-idx_cut+1:end)),1);
end

% figure;freqz(linconv(x_original,xinv),1,8192,48000);
% figure;stem(x_original(end-2000:end));
% figure;stem(f_t(end-2000:end),x_original(end-2000:end));
% figure;stem(xinv(1:2000));

%zero-padding
zero_pad    = zeros(fs,1);
x           = [zero_pad;x_original;zero_pad];

%%-->Play&Record
nBits = 24;
playOBJ = audioplayer(x,fs,nBits,-1); 
recOBJ = audiorecorder(fs,nBits,2,-1);
play(playOBJ);
recordblocking(recOBJ,1.1*length(x)/fs);

recordedData = getaudiodata(recOBJ, 'double');   
recordedData1 = recordedData(:,1); 
recordedData2 = recordedData(:,2); 
%%<--Play&Record

%delete record and play objects to save memory
delete(playOBJ);clear OBJ;
delete(recOBJ);clear recOBJ;

% see recorded signals %
figure;
plot(x,'k.');
hold on;
plot(recordedData2,'r.');
plot(recordedData1,'b.');
title('Raw Inputs and Output Signals');
legend('toLoudspeaker','recordedData2','recordedData1','Location','North');
hold off;

% Start the data handling
measuredSystemL  =  recordedData1; % Left Ear
measuredSystemR          =  recordedData2; % Right Ear
clear recordedData1 recordedData2

%identify the delay of the recording trigger
xc          = xcorr(x,measuredSystemR);
len_diff    = length(x)-length(measuredSystemR);
% figure
% stem(xc)
[~,indx ]   = max(xc);
c           = floor((length(xc)+1)/2);
delay       = c-indx;

%delete cross-correlation to save memory
clear xc;

% see recorded signals %
% figure;
% plot(x(1:fs),'k.');
% hold on;
% plot(ioLoop(1:fs),'r.');
% title('Raw Inputs and ioLoop');
% legend('x','ioLoop','Location','NorthEast');
% hold off;

%extract the tail of zeros
measuredSystemR_trimmed         = measuredSystemR(1:delay+length(x));
measuredSystemL_trimmed         = measuredSystemL(1:delay+length(x));


save('Measurements/Parameters_back_right', 'measuredSystemL','measuredSystemL_trimmed','measuredSystemR','measuredSystemR_trimmed','fstart', 'fend', 'fs', 'x', 'x_original', 'xinv','sweeplength', 'CorrFac');

% figure;spectrogram(measuredSystemTrimmed,1024,1000,1024,48000)
% figure;spectrogram(ioLoopTrimmed,1024,1000,1024,48000)

end