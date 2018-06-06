function [x_m,y_m, xinv, f_t]=mesm5_far(fs,T,f_start,f_end,writewav,A,e,K,L1,L2)
%Ein exp.Multiple Sweepgenerator.
  
      
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


if writewav==1
    audiowrite(sprintf('sweep_far_exp_%ihz_%1.1fs.wav',fs,T),x_m,fs);
    audiowrite(sprintf('sweep_far_exp_%ihz_%1.1fs_overlapped_interleaved.wav',fs,T),y_m,fs);
    audiowrite(sprintf('sweep_far_exp_%ihz_%1.1fs_inverse.wav',fs,T),xinv,fs);
end


