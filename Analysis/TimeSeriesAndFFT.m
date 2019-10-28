clear all; close all; clc;

%createMAT('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\deep.RAW','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\MGL1212MCS05.mat','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\deep.mat');
%createMAT('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\mid.RAW','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\MGL1212MCS07.mat','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\mid.mat');
%createMAT('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\shallow.RAW','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\MGL1212NTMCS01.mat','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\shallow.mat');

loc = {'..\example_shots\shallow.mat',...
       '..\example_shots\mid.mat',...
       '..\example_shots\deep.mat'};
titles1 = {'Acoustic Pressure Time Series (shallow)','Acoustic Pressure Time Series (intermediate)','Acoustic Pressure Time Series (deep)'};
titles2 = {'Amplitude Spectrum (shallow) [dB rel 1\muPa/Hz]','Amplitude Spectrum (intermediate) [dB rel 1\muPa/Hz]','Amplitude Spectrum (deep) [dB rel 1\muPa/Hz]'};

for it=(1:3)
    figure;
    load(loc{it});
    fs = 500;
    %Data1 = Data1.';
    Data2 = flip(Data1(:,1:15*fs));%window (5s)
    Data2 = Data2/1e6;%convert to pascal
    L = size(Data2,2);
    t = (0:L-1)/fs;%timebase
    p_t = Data2(2,:);
    fft_2 = fft(p_t);
    plot(t,p_t,'Color','k');
    grid on;
    hold on;
    title(titles1{it});
    xlabel('Time (Seconds)')
    ylabel('Acoustic Pressure (Pa)')
    
    %https://www.mathworks.com/help/matlab/ref/fft.html
    figure;
    P2 = abs(fft_2/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    f = fs*(0:(L/2))/L;
    
    P1 = 10*log10(1e6*P1);%convert to db rel uPa
    
    plot(f,P1,'Color','k') 
    title(titles2{it})
    xlabel('Frequency (Hz)')
    ylabel('Amplitude (dB rel 1\muPa/Hz)')
    
end