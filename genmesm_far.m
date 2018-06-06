function [x, xinv, f_t]=genmesm_far(fs,T,f_start,f_end,writewav,A,e,L1,L2,N)
%Ein exp. Sweepgenerator.
j=5;
i=4;
W1=2*pi*f_start/fs;
W2=2*pi*f_end/fs;
 T_1=(((e-1)*L1)+L2).*log(W2/W1)./log(2);
 T_int=T_1+e*L1;
r=(T_1/log(W2/W1)).*log(j);
T_ov=T+((N-1)*(r+L1));
T_MESM=T_1+r*((N/e)-1)+N*L1;
siglen1=T*fs;
%siglen=T_int*fs;
%siglen=T_ov*fs;
siglen2=(T+(i-1)*L1)*fs;

x1 = A*sin(W1*siglen/log(W2/W1).*(exp(((0:siglen)./siglen)*log(W2/W1))-1));
% x2 = A*sin(W1*siglen2/log(W2/W1).*(exp(((0:siglen2)./siglen2)*log(W2/W1))-1));
% x=x1+x2;
f_t = f_start*exp(((0:siglen)./siglen)*log(W2/W1));

%freq_vec=[f_start+1:1:f_end];
%freq_index=[freq_vec;fix(siglen*log((f_start+1:1:f_end)./f_start)/log(W2/W1))];

% -------------
xinv = fliplr(x) .* (W2/W1).^(-(0:siglen)/siglen);
% -------------
% H=conj(fft(x))./(conj(fft(x)).*fft(x));% .* exp(2*pi*i*(0:N)*N/(N+1)));
% h=real(ifft(H));
% y=h;
% -------------
%   h=zeros(1,length(x));
%    h(end)=1;
%    H=fft(h);
%    X=fft(x);
%    Y=H./X;
%    y=(real(ifft(Y)));
  %y=y(length(x)+1:end);
% -------------  

if writewav==1
    wavwrite(x,fs,[sprintf('sweep_far_exp_%ihz_%1.1fs.wav',fs,T)]);
    wavwrite(xinv,fs,[sprintf('sweep_far_exp_%ihz_%1.1fs_inverse.wav',fs,T)]);
end;

