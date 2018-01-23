clear all; close all; clc;
todB = @(x) 10*log10(abs(x));
amp = @(x) 10^(x/10);
fs = 500;

load('23B_121_86_FullGun.mat','-mat')
f1 = Data1;
f1 = fliplr(f1')*1e7;
sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];

fData = sosfilt(sos,f1,2);
fData = amp(6)*fData;

winData = [];
peak = [];

for r=1:size(fData,1)
    row = fData(r,:);
    [val,peak1] = max(row);
    disp(peak1)
    if peak1>1000
        DATA = row(peak1-2*fs:peak1+2*fs);
    else
        w = row(peak1:peak1+2*fs);
        DATA = cat(1,zeros(1,len(w)),w);
    end
    winData = cat(2,winData,DATA);
    peak = cat(1,peak,peak1);
end
plot(peak)

squaredPressure = winData.^2;
RMS = [];
T90 = [];

for r=1:size(squaredPressure,1)%RMS
    row = squaredPressure(r,:);
    t90a=t90(row);
    RMS = cat(1,RMS,10*log10(sum(row)/(fs*T90a)));
    T90 = cat(1,T90,T90a);
end

SEL = [];

for r=1:size(RMS,1)%SEL
    row = RMS(r,:);
    SEL = cat(1,SEL,row(r)+10*log10(T90(r)));
end 


function tnin=t90(x);
    tnin = -9999
    total = sum(x);
    peak = int(len(x)/2);
    for i=(1:100000)
        if sum(x(peak-i:peak+i))>=0.9*total
            tnin = 2*i/fs;
            return;
        end
    end
end

