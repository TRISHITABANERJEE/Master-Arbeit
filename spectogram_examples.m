%   t=0:0.001:2;                    % 2 secs @ 1kHz sample rate
%       y=chirp(t,100,1,200,'q');       % Start @ 100Hz, cross 200Hz at t=1sec
%       spectrogram(y,kaiser(128,18),120,128,1E3,'yaxis');
%       title('Quadratic Chirp: start at 100Hz and cross 200Hz at t=1sec');
%  
%     EXAMPLE 2: Reassigned spectrogram of quadratic chirp
%       t=0:0.001:2;                    % 2 secs @ 1kHz sample rate
%       y=chirp(t,100,1,200,'q');       % Start @ 100Hz, cross 200Hz at t=1sec
%       spectrogram(y,kaiser(128,18),120,128,1E3,'reassigned','yaxis');
%       title('Quadratic Chirp: start at 100Hz and cross 200Hz at t=1sec');
%  
%     EXAMPLE 3:  Plot instantaneous frequency of quadratic chirp
%       t=0:0.001:2;                    % 2 secs @ 1kHz sample rate
%       y=chirp(t,100,1,200,'q');       % Start @ 100Hz, cross 200Hz at t=1sec
%       % remove estimates less than -30 dB
%       [~,~,~,P,Fc,Tc] = spectrogram(y,kaiser(128,18),120,128,1E3,'minthreshold',-30);
%       plot(Tc(P>0),Fc(P>0),'. ')
%       title('Quadratic Chirp: start at 100Hz and cross 200Hz at t=1sec');
%       xlabel('Time (s)')
%       ylabel('Frequency (Hz)')
 
%     EXAMPLE 4: Waterfall display of the PSD of each segment of a VCO
      Fs = 10e3;
      t = 0:1/Fs:2;
      x1 = vco(sawtooth(2*pi*t,0.5),[0.1 0.4]*Fs,Fs);
      spectrogram(x1,kaiser(256,5),220,512,Fs);
%       view(-45,65)
%       colormap bone
 
   