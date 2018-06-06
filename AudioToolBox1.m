
close all
clear all;
clc

fs = 44100;
duration = 60; %secs

Audio1 = audioread('mesm.wav');


s = daq.createSession('directsound'); %create seassion
s.DurationInSeconds = duration;
s.UseStandardSampleRates = true;
s.Rate = fs;

  devs = daq.getDevices; %list audio devices in system

 [ch12, idx12] = addAudioOutputChannel(s,devs(22).ID,1:2); %balancedlineoutput_1&2
 [ch34, idx34] = addAudioOutputChannel(s,devs(18).ID,1:2); %balancedlineoutput_3&4
 [ch56, idx56] = addAudioOutputChannel(s,devs(15).ID,1:2); %balancedlineoutput_5&6
   
    N=length(Audio1);
    zero_pad =zeros(1*fs,1); 
    y0=Audio1(1:N);
    p0=[zero_pad; y0];
       %zero padding to avoid data loss at the start of session
    
   queueOutputData(s, [p0 p0 p0 p0 p0 p0]); 
 
   startBackground(s);
   
   nBits = 24;
   recOBJ = audiorecorder(fs,nBits,2,-1);
   recordblocking(recOBJ,5.1*length(p0)/fs);
   
   %startForeground(s);
 
 recordedData = getaudiodata(recOBJ, 'double');   
 recordedData1 = recordedData(:,1);
 recordedData2 = recordedData(:,2); 
  %<--Record

%delete record  objects to save memorywe
delete(recOBJ);clear recOBJ;

%Start the data handling
measuredSystem_L  =  recordedData1;
measuredSystem_R  =  recordedData2;
clear recordedData1 recordedData2

 stop(s);
 
 %save('E:\Study materials\Farina\AudioInterfaces\audiointerface12.mat','measuredSystem_L', 'measuredSystem_R', 'fs',  'Audio1', 'p0');
 %save('E:\Study materials\Farina\AudioInterfaces\audiointerface13.mat','measuredSystem_L', 'measuredSystem_R', 'fs',  'Audio1', 'p0');
 %save('E:\Study materials\Farina\AudioInterfaces\audiointerface15.mat','measuredSystem_L', 'measuredSystem_R', 'fs',  'Audio1', 'p0');
 