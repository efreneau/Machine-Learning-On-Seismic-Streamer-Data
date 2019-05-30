clear all; clc; close all;
%P190 = 'D:\Machine Learning\Matlab\P190\MGL1212NTMCS01.mat';
resultFile = 'D:\Machine Learning\shallow.mat';
%dataFile = 'Z:\DATA\Line_AT\TAPE0106.REEL\R000179_1342879566.RAW';%shallow

%P190 = 'D:\Machine Learning\Matlab\P190\MGL1212MCS05.mat';
%resultFile = 'D:\Machine Learning\deep.mat';
%dataFile = 'Z:\DATA\Line_05\TAPE0028.REEL\R000028_1342408921.RAW';%deep

%P190 = 'D:\Machine Learning\Matlab\P190\MGL1212MCS07.mat';
%resultFile = 'D:\Machine Learning\mid.mat';
%dataFile = 'Z:\DATA\Line_07\TAPE0048.REEL\R000319_1342512128.RAW';%mid
%readMCS(dataFile,P190,resultFile);
load(resultFile);

c = 750;%offset
fs = 500;
p = plot(1,1); 
plt = [p p p p p p p p p p p p p];%blank array of plots
plt2 = [p p p p p p p p p p p p p];
offset = c*(0:12);%offset array

range = fliplr(sqrt(X_R1.^2+Y_R1.^2+Z_R1.^2));

sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];
Data1 = sosfilt(sos,Data1',2);%filter

Data2 = flip(Data1(:,1:10*fs));%window
t = (0:size(Data2,2)-1)/fs;%timebase

grid on;
hold on;

xlabel('Time (sec)')
ylabel('Range (m)')
d = 1;
yt = zeros(1,13);
for i = (1:13)%for each intended plot
    yt(i) = 50*(i-1);%convert index to channel #
    k = yt(i)+1;
    plt(i) = plot(t,Data2(k+d,:),'k');%plot
    set(plt(i), 'YData', get(plt(i), 'YData')+offset(i))%add offsets
end

for i = (1:13)%for each intended plot
    yt(i) = 50*(i-1);%convert index to channel #
    k = yt(i)+1;
    [n05,n95]=t90_2(Data2(k+d,:).^2);
    plt2(i) = plot(t(n05:n95), Data2(k+d,n05:n95),'r');
    set(plt2(i), 'YData', get(plt2(i), 'YData')+offset(i))%add offsets
end


yticks(offset)%create ticks
yticklabels(round(range(yt+d)))%label with channel numbers

function [n05,n95]=t90_2(x)%t90 calculation for a 4s window
    index = 1;
    xsum = sum(x);
    e05 = 0.05*xsum;% 5% energy point
    e95 = 0.95*xsum;% 95% energy point
    n05 = 1;%index of 5% energy point
    n95 = 1;%index of 95% energy point
    ex = 0;%running sum for energy
    while(n95==1)%iterate over window untill an n95 is reached
        ex = ex + x(index);
        if(n05==1 && ex>=e05)%at first instance of energy above e05 record the index
            n05 = index;
        end
        if(ex>=e95)
            n95 = index;
        end
        index = index + 1;
    end
end