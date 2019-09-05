if (exist('Data1','var')) ~= 0
    close all;
else
    clear all; clc; close all;
    load("C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\tf_test.mat");
end
%readMCS("C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\R000339_1342415803.RAW","C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\MGL1110MCS05.mat","C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\tf_test.mat");

%c = 2e2; %constant offset
d = 1.0; %scaling factor to c

line = 5;
shot = "R000339";

num_bands = 100; 
num_ticks = 10; 
element_num = 50;%636;
BW = 5; 
f_max = 210;

fs = 500;

p = plot(1,1);
plt = [p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,...%blank array of plots
       p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,...
       p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,...
       p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,...
       p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,...
       p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,...
       p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,...
       p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,...
       p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,...
       p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p,p];
plt = plt(1:num_bands);

pressure_trace = Data1(:,element_num);
sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];
pressure_trace = sosfilt(sos,pressure_trace);

pressure_trace = flip(pressure_trace);
t = (0:size(pressure_trace,1)-1)/fs;

grid on;
hold on;
xlabel('Frequency (Hz)')
ylabel('Time (S)')
title(strcat({'Line '},int2str(line),{',  '},shot,{' (Element #'},int2str(element_num),{', Trace BW: '},int2str(BW),{' Hz)'}))

yt = zeros(1,num_bands);
bottom = linspace(1,f_max,num_bands);
top = bottom+BW;

traces_f = zeros(num_bands,size(t,2));

parfor i = (1:num_bands)
    traces_f(i,:) = bandpass(pressure_trace,[bottom(i),top(i)],fs);
end

c = d*max(max(traces_f));%automatic offset logic
offset = c*(0:num_bands-1);

for i = (1:num_bands)%for each intended trace
    plt(i) = plot(traces_f(i,:),t,'k');
    set(plt(i), 'XData', get(plt(i), 'XData')+offset(num_bands-i+1))%add offsets
end

ticks_offset = linspace(offset(1),offset(end),num_ticks);
xticks(ticks_offset);%create ticks
f = f_max*(1:num_bands)/num_bands;
ticks_f = linspace(f(1),f(end),num_ticks);
xticklabels(ticks_f);%label with frequency

