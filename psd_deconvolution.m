function [IR_PSD_based] = psd_deconvolution(h1,h2,Lp,Lh1,Lh2)
%% derivation of impulse response based on cross- and auto-correlation FFTs 
L       = Lh1+Lh2-1;
H1      = fft(h1(1:Lh1),L);
H2      = fft(h2(1:Lh2),L);
h       = ifft(   (H2.*conj(H1))  ./   (H1.*conj(H1))   );

IR_PSD_based = h;%(1:Lp);
end