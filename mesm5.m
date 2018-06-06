close all
clear all;
clc


      fs = 48000;
      e=3;
      K=10;
      f_start      = 55;%55;
      f_end        = fs/2;%24100;    %Possible values 20k and 24k
            
      T           =3; 
      A           = 0.02;%0.025; for 0.6m%0.6;%for 1m distance%0.7;%for1.5m
      L1          =.500;
      L2          =.150;
      
      W1=2*pi*f_start/fs;
      W2=2*pi*f_end/fs;
      
      T_1 =(((e-1)*L1)+L2).*log(W2/W1)./log(2);
      siglen_MESM = T_1*fs;
     
      x_m = A*sin(W1*siglen_MESM/log(W2/W1).*(exp(((0:siglen_MESM)./siglen_MESM)*log(W2/W1))-1)); %Multiple Sine Sweep
      
      t_i = ceil(L1*fs);
      t_o = ceil((T_1/log(W2/W1)).*log(K)*fs);
      
      % Two overlapped groups of 3 interleaved sweeps
      x1      = [x_m';zeros(t_i+t_o,1)]; 
      x2      = [zeros(t_i,1);x_m';zeros(t_o,1)];
      x3      = [zeros(2*t_i,1);x_m';zeros(t_o-t_i,1)];
      x4      = [zeros(t_o,1);x_m';zeros(t_i,1)];
      x5      = [zeros(t_i+t_o,1); x_m'];
      y_m = x1+x2+x3+x4+x5;% Simulated Measurement
      y_m=y_m';
      
      
      
      xinv = fliplr(x_m) .* (W2/W1).^(-(0:siglen_MESM)/siglen_MESM); %Inverse sweep

      
      f_t = f_start*exp(((0:siglen_MESM)./siglen_MESM)*log(W2/W1));

     
      %correlation factor 
       CorrFac = A^2*T*fs*pi*(f_start/f_end-1)/...
        (2 * (2*pi*f_end/fs - 2*pi*f_start/fs) * log(f_start/f_end));
        
     [h1, h2, h1_nl, h2_nl] = farina_deconvolution(x_m,y_m,xinv,CorrFac,1 );

figure
      subplot(2,1,1);
      spectrogram(h1_nl,1024,1000,1024,Fs,'yaxis');
      title('Linear Impulse Response H1');ylabel('h1 \rightarrow dB')
      subplot(2,1,2);
      spectrogram(h2_n2,1024,1000,1024,Fs,'yaxis');
      title('Linear Impulse Response H2');ylabel('h2 \rightarrow dB')
      
% figure
%         spectrogram(y,1024,1000,1024,Fs,'yaxis')
%         set(gca,'FontSize',22)
%         xlabel('Time in s'); ylabel('Frequency in kHz')
      
      
      
      