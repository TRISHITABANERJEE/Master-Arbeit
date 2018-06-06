
close all
clear all;
clc

fs = 44100;
duration = 60; %secs

Audio1 = audioread('drumloop.wav');
Audio2 = audioread('popsong.wav');
Audio3 = audioread('vocals.wav');
Audio4 = audioread('funk.wav');

s = daq.createSession('directsound');
s.DurationInSeconds = duration;
s.UseStandardSampleRates = true;
s.Rate = fs;

devs = daq.getDevices;
 [ch12, idx12] = addAudioOutputChannel(s,devs(22).ID,1:2); %balancedlineoutput_1&2
 [ch34, idx34] = addAudioOutputChannel(s,devs(18).ID,1:2); %balancedlineoutput_3&4
 [ch56, idx56] = addAudioOutputChannel(s,devs(15).ID,1:2); %balancedlineoutput_5&6
 
 %[ch56, idx56] = addAudioInputChannel(s,devs(12).ID,1:2);
 %[ch12, idx12] = addAudioInputChannel(s,devs(11).ID,1:2);
 %[ch78, idx78] = addAudioInputChannel(s,devs(5).ID,1:2);
 %queueOutputData(s, [Audio1 zeros(size(Audio1))]);
%queueOutputData(s, [Audio1 Audio2 Audio3 Audio4]);
  N=min((length(Audio1)),length(Audio2));
  zero_pad   = zeros(1*fs,1); 
  y0=Audio1(1:N);
  p0=[zero_pad; y0];
  y1=Audio2(1:N);
   p1=[zero_pad; y1];
  y2=Audio3(1:N);
   p2=[zero_pad; y2];
  y3=Audio4(1:N);
   p3=[zero_pad; y3];
  %y=y0+y1+y2+y3;
 queueOutputData(s, [p0 p1 p2 p3 p0 p1]); 
 
startBackground(s);

% r = daq.createSession('directsound');
% r.DurationInSeconds = duration;
% r.UseStandardSampleRates = true;
% r.Rate = fs;
% 
% addAudioInputChannel(r,devs(12).ID, 1:2);
% r.IsContinuous = true;
% startBackground(r);
% stop(r);
% r.IsContinuous = false;

 nBits = 24;
% playOBJ = audioplayer(y0,fs,nBits,22); 
 recOBJ = audiorecorder(fs,nBits,2,-1);
 %play(playOBJ);
 recordblocking(recOBJ,1.1*length(p0)/fs);
 
 recordedData = getaudiodata(recOBJ, 'double');   
recordedData1 = recordedData(:,1);
recordedData2 = recordedData(:,2); 
%%<--Play&Record

%delete record and play objects to save memory
%delete(playOBJ);clear OBJ;
delete(recOBJ);clear recOBJ;

% Start the data handling
measuredSystem_L  =  recordedData1;
measuredSystem_R  =  recordedData2;
clear recordedData1 recordedData2
 %pause(duration);
 stop(s);
 
 save('C:\Users\TRISHITA BANERJEE\Documents\MATLAB/audiointerface12.mat','measuredSystem_L', 'measuredSystem_R', 'fs', 'y0', 'y1', 'y2','y3');
 
%%% archived%%%% 
 
 %[ch78, idx78] = addAudioInputChannel(s,devs(5).ID,1:2);
   %[ch56, idx56] = addAudioInputChannel(s,devs(12).ID,1:2);
   %[ch78, idx78] = addAudioInputChannel(s,devs(5).ID,1:2);
 