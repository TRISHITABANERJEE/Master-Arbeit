close all
clear all;
clc


      Fs = 48000;
      t = 0:1/Fs:2;
      fstart      = 55;%55;
      fend        = Fs/2;%24100;    %Possible values 20k and 24k
            
        
      A           = 0.2;%0.025; for 0.6m%0.6;%for 1m distance%0.7;%for1.5m
      L1=.1;
      L2=.2*L1;
      e=4; j=10;T=3;
      W1=2*pi*fstart/Fs;
      W2=2*pi*fend/Fs;
      N=5;
      T_1=(((e-1)*L1)+L2).*log(W2/W1)./log(2);
      T_int=N*(T_1+e*L1)/e;
      r=(T_1/log(W2/W1)).*log(j);
      T_ov=T+((N-1)*(r+L1));
      T_MESM=T_1+r*((N/e)-1)+N*L1;
      siglen=T*Fs;
      siglen_MESM=T_MESM*Fs;
     
     
 
  x1 = A*sin(W1*siglen/log(W2/W1).*(exp(((0:siglen)./siglen)*log(W2/W1))-1));
%       
%   
      xinv = fliplr(x1) .* (W2/W1).^(-(0:siglen)/siglen);

%       x1= A*sin(W1*siglen_MESM/log(W2/W1).*(exp(((0:siglen_MESM)./siglen_MESM)*log(W2/W1))-1));
%         xinv = fliplr(x1) .* (W2/W1).^(-(0:siglen_MESM)/siglen_MESM);
     
      zero_pad   = zeros(1*Fs,1);
      y1      = [x1';zero_pad]; 
      y2        = [zero_pad; x1'];   
      y=y1+y2;
      y3=   [y;zero_pad];
      y4=   [zero_pad;y];
      y5=y3+y4;
      
      load('Fromntal_Dummy_L2.mat','measuredSystemTrimmed','ioLoopTrimmed','xinv','CorrFac');
      
%       ioLoopTrimmed           = ioLoop(1:delay+length(x1));
%       measuredSystemTrimmed   = measuredSystem(1:delay+length(x1));
%       y_m=y(1:length(x1));
%      load('Fromntal_Dummy_L2.mat','CorrFac');
%      xinv = fliplr(x1) .* (W2/W1).^(-(0:siglen_MESM)/siglen_MESM);
%     [h1, h2, h1_nl, h2_nl] = farina_deconvolution(y,x1,xinv,CorrFac,1 );
    
  [h1, h2, h1_nl, h2_nl] = farina_deconvolution(measuredSystemTrimmed,ioLoopTrimmed,xinv,CorrFac,1 );
      
      
% figure
%       subplot(2,1,1);
%       spectrogram(h1,1024,1000,1024,Fs,'yaxis');
%       title('Linear Impulse Response H1');ylabel('h1 \rightarrow dB');
%       subplot(2,1,2);
%       spectrogram(h2,1024,1000,1024,Fs,'yaxis');
%       title('Linear Impulse Response H1');ylabel('h1 \rightarrow dB');

figure
      subplot(2,1,1);
      spectrogram(h1,1024,1000,1024,Fs,'yaxis');
      title('Linear Impulse Response H1');ylabel('h1 \rightarrow dB')
      subplot(2,1,2);
      spectrogram(h2,1024,1000,1024,Fs,'yaxis');
      title('Linear Impulse Response H1');ylabel('h2 \rightarrow dB')
      
      
      
      