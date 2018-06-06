close all
clear all;
clc
% load Fromntal_Dummy_L2.mat;
fs = 44100;
load('Parameters_back_right3.mat','measuredSystemL_trimmed','measuredSystemR_trimmed','xinv','CorrFac','measuredSystemR','measuredSystemL');



[h1, h2, h1_nl, h2_nl] = farina_deconvolution(measuredSystemL_trimmed,measuredSystemR_trimmed,xinv,CorrFac,1 );

figure
      subplot(2,1,1);
      spectrogram(h1,1024,1000,1024,fs,'yaxis');
      title('Linear Impulse Response H1');ylabel('h1 \rightarrow dB')
      subplot(2,1,2);
      spectrogram(h2,1024,1000,1024,fs,'yaxis');
      title('Linear Impulse Response H2');ylabel('h2 \rightarrow dB')