clear all; clc;
P190 = 'D:\Machine Learning\Matlab\P190\MGL1212NTMCS01.mat';
resultFile = 'D:\Machine Learning\example.mat';
dataFile = 'Z:\DATA\Line_AT\TAPE0106.REEL\R000179_1342879566.RAW';

%readMCS(dataFile,P190,resultFile);
load(resultFile);

c = 750;%offset
fs = 500;
p = plot(1,1); 
plt = [p p p p p p p p p p p p p];%blank array of plots
offset = c*(1:13);%offset array

Data1 = Data1';

%[~,peak1] = max(Data1(1,:));%find fastest peak and slowest peak
%[~,peak2] = max(Data1(550,:));

Data2 = Data1(:,1:6*fs);%window
t = (0:size(Data2,2)-1)/fs;%timebase

grid on;
hold on;

yt = zeros(1,12);
for i = (1:13)%for each intended plot
    yt(i) = 50*(i-1);%convert index to channel #
    k = yt(i) + 1;
    plt(i) = plot(t,Data2(k,:),'k');%plot
    set(plt(i), 'YData', get(plt(i), 'YData')+offset(i))%add offsets
end

yticks(offset)%create ticks
yticklabels(yt)%label with channel numbers
xlabel('Time (s)')
ylabel('Channel #')