function [x, xinv, f_t]=gensweep_far(fs,T,f_start,f_end,writewav,A)
%Ein exp. Sweepgenerator. 

W1=2*pi*f_start/fs;
W2=2*pi*f_end/fs;
siglen=T*fs;

x = A*sin(W1*siglen/log(W2/W1).*(exp(((0:siglen)./siglen)*log(W2/W1))-1));
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

