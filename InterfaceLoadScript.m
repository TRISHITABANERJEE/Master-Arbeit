
 %close all
 clear all
 clc
     
matfiles = dir('*audiointerface*.mat');%picks up matfiles of name beginning with audiointerface

N = numel(matfiles); %returns the number of elements in array matfiles, 
C = cell(N,3);

for k = 1:N
    
    data = load(matfiles(k).name);
    C{k,1} = matfiles(k).name;
    C{k,2} = data.measuredSystem_L;
    C{k,3} = data.measuredSystem_R;
   
end  


A=[C{1,2},C{2,2},C{3,2}];
B=[C{1,3},C{2,3},C{3,3}];


 Fs=44100;
 NFFT = 4096;
 fvec = (0:NFFT-1) /NFFT * Fs;
  YL1= 20* log10 (abs(fft(A(40000:end,1),NFFT) ));
  YL2= 20* log10 (abs(fft (A(40000:end,2),NFFT) ));
  YL3= 20* log10 (abs(fft(A(40500:end,3),NFFT) ));
  YR1= 20* log10 (abs(fft(B(40000:end,1),NFFT) ));
  YR2= 20* log10 (abs(fft(B(40500:end,2),NFFT) ));
  YR3= 20* log10 (abs(fft(B(40000:end,3),NFFT) ));

   figure;
   subplot(2,1,1);
 plot(fvec(1:NFFT/2+1),YL1(1:NFFT/2+1)); hold on;
xlabel('Frequency in Hz'); ylabel('Magnitude in dB')
plot(fvec(1:NFFT/2+1),YL2(1:NFFT/2+1)); hold on;
xlabel('Frequency in Hz'); ylabel('Magnitude in dB')
plot(fvec(1:NFFT/2+1),YL3(1:NFFT/2+1)); hold off;
title('LEFT EAR MEASUREMENT');
xlabel('Frequency in Hz'); ylabel('Magnitude in dB')
legend('AudioInterface12','AudioInterface13 ','AudioInterface15 ')
subplot(2,1,2);
plot(fvec(1:NFFT/2+1),YR1(1:NFFT/2+1)); hold on;
xlabel('Frequency in Hz'); ylabel('Magnitude in dB')
plot(fvec(1:NFFT/2+1),YR2(1:NFFT/2+1)); hold on;
xlabel('Frequency in Hz'); ylabel('Magnitude in dB')
plot(fvec(1:NFFT/2+1),YR3(1:NFFT/2+1)); hold off;
title('RIGHT EAR MEASUREMENT');
xlabel('Frequency in Hz'); ylabel('Magnitude in dB')
legend('AudioInterface12','AudioInterface13 ','AudioInterface15 ');
% figure
%       subplot(2,1,1);
%       spectrogram(YL1,1024,1000,1024,Fs,'yaxis');
%       title('Exponential Sine Sweep');
%        xlabel('Time in s'); ylabel('Frequency in kHz')
%       subplot(2,1,2);
%       spectrogram(YR1,1024,1000,1024,Fs,'yaxis');
%       title('Multiple Sine sweep with N=5');
%        xlabel('Time in s'); ylabel('Frequency in kHz')
       
figure;plot(B(40000:end,1)); hold on;
plot(B(40300:end,2)); hold on;
plot(B(40500:end,3)); hold off;
       
 figure;
plot(fvec(1:NFFT/2+1),YL1(1:NFFT/2+1)); hold on;
plot(fvec(1:NFFT/2+1),YR1(1:NFFT/2+1)); hold off;
title('LEFT vs Right Channel Measurement');
xlabel('Frequency in Hz'); ylabel('Magnitude in dB')
legend('Out1-In5','Out2-In6')

figure;
plot(fvec(1:NFFT/2+1),YL1(1:NFFT/2+1)-YR1(1:NFFT/2+1)); 
xlabel('Frequency in Hz'); ylabel('Magnitude in dB')
title('LEFT vs Right Channel Measurement');
legend('Left - Right')