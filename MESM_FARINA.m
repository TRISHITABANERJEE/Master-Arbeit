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
sweeplength = 30; %sweep length in seconds
fstart      = 55;%55;
fend        = fs/2;%24100;    %Possible values 20k and 24k
A           = 0.2;%0.025; for 0.6m%0.6;%for 1m distance%0.7;%for1.5m
L1=.1;
L2=.2*L1;
e=4;

[x_original, xinv, f_t]=genmesm_far(fs,sweeplength,fstart,fend,0,A,e,L1,L2,5);


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
%<--Play&Record

%delete record and play objects to save memory
delete(playOBJ);clear OBJ;
delete(recOBJ);clear recOBJ;

% see recorded signals %
% figure;
% plot(x,'k.');
% hold on;
% plot(recordedData2,'r.');
% plot(recordedData1,'b.');
% title('Raw Inputs and Output Signals');
% legend('toLoudspeaker','recordedData2','recordedData1','Location','North');
% hold off;

% Start the data handling
measuredSystem  =  recordedData1;
ioLoop          =  recordedData2;
clear recordedData1 recordedData2

%identify the delay of the recording trigger
xc          = xcorr(x,ioLoop);
len_diff    = length(x)-length(ioLoop);
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
% ioLoopTrimmed           = ioLoop(1:delay+length(x));
% measuredSystemTrimmed   = measuredSystem(1:delay+length(x));

% %% Farina Deconvolution
    % Convolves the measured signals y1 and y2 with xinv and separates
    % their linear and non-linear impulse responses
    
    [h1, h2, h1_nl, h2_nl] = farina_deconvolution(measuredSystem,ioLoop,xinv,CorrFac,1 );
    
     if ctrl_plot_var
    figure
        subplot(2,1,1);
        plot(20*log10(abs(h1_complete)))
        title('Complete Impulse Responses')
        grid on
        ylabel('h1 \rightarrow dB')
        subplot(2,1,2);
        plot(20*log10(abs(h2_complete)))
        ylabel('h2 \rightarrow dB')
        grid on
        
        figure
        subplot(2,1,1);
        plot(20*log10(abs(h1)))
        title('Linear Impulse Responses')
        grid on
        ylabel('h1 \rightarrow dB')
        subplot(2,1,2);
        plot(20*log10(abs(h2)))
        ylabel('h2 \rightarrow dB')
        grid on
        
        figure
        subplot(2,1,1);
        plot(h1)
        title('Linear Impulse Responses')
        grid on
        ylabel('h1 \rightarrow dB')
        subplot(2,1,2);
        plot(h2)
        ylabel('h2 \rightarrow dB')
        grid on
     end 


save('Measurements/headphone_L', 'measuredSystem','measuredSystemTrimmed','ioLoop','ioLoopTrimmed','fstart', 'fend', 'fs', 'x', 'x_original', 'xinv','sweeplength', 'CorrFac');

 figure;spectrogram(measuredSystemTrimmed,1024,1000,1024,48000)
 figure;spectrogram(ioLoopTrimmed,1024,1000,1024,48000)

end