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
      e=4; j=10;T=10;
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
      siglen_ov=T_ov*Fs;
     
 
      %x = A*sin(W1*siglen/log(W2/W1).*(exp(((0:siglen)./siglen)*log(W2/W1))-1));
 x_m= A*sin(W1*siglen_MESM/log(W2/W1).*(exp(((0:siglen_MESM)./siglen_MESM)*log(W2/W1))-1));
%       x_o= A*sin(W1*siglen_ov/log(W2/W1).*(exp(((0:siglen_ov)./siglen_ov)*log(W2/W1))-1));
%       x = A*sin(W1*siglen/log(W2/W1).*(exp(((0:siglen)./siglen)*log(W2/W1))-1));
%       zero_pad   = zeros(1*Fs,1);
%       y1      = [x1';zero_pad]; 
%       y2        = [zero_pad; x1'];   
%       y=y1+y2;
%       y3=   [y;zero_pad];
%       y4=   [zero_pad;y];
%       y5=y3+y4;
%       y6=[y5;zero_pad];
%       y7=[zero_pad;y5];
%       y8=y6+y7;
%       y9=[y8;zero_pad];
%       y10=[zero_pad;y8];
%       y11=y9+y10;
      
%       p1      = [x2';zero_pad]; 
%       p2        = [zero_pad; x2'];   
%       p=p1+p2;
%       p3=   [p;zero_pad];
%       p4=   [zero_pad;y];
%       p5=p3+p4;
%       p6=[p5;zero_pad];
%       p7=[zero_pad;y5];
%       p8=p6+p7;
      
      
% figure
%        spectrogram(x,1024,1000,1024,Fs,'yaxis');
%     set(gca,'FontSize',22)
%         xlabel('Time in s'); ylabel('Frequency in kHz')
  
     
    %sound(x_m,Fs);  
%     filename='mesm.wav';
%    audiowrite('mesm.wav',x_m,Fs);

x_m_inv = fliplr(x_m) .* (W2/W1).^(-(0:siglen_MESM)/siglen_MESM);

figure
      subplot(2,1,1);
      spectrogram(x_m,1024,1000,1024,Fs,'yaxis');
      %title('Exponential Sine Sweep');
       xlabel('Time in s'); ylabel('Frequency in kHz')
      subplot(2,1,2);
      spectrogram(x_m_inv,1024,1000,1024,Fs,'yaxis');
      %title('Multiple Sine sweep with N=5');
       xlabel('Time in s'); ylabel('Frequency in kHz')
       
       sound(x_m,44100);


      
      
      