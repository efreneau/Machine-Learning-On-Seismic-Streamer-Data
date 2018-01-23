clear all; close all; clc;
todB = @(x) 10*log10(abs(x));
amp = @(x) 10^(x/10);
fs = 500;

load('MGL1212_Line_AT.mat','-mat')
f1 = flipud(Data1')*1e7;
sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];

fData = sosfilt(sos,f1,2);%2
fData = amp(6)*fData;

winData = [];
peak = [];

for r=1:size(fData,1)
    row = fData(r,:);
    [val,peak1] = max(row);
    %disp(peak1)
    if peak1>2*fs && length(row)-peak1>2*fs
        DATA = row(peak1-2*fs:peak1+2*fs);
    elseif length(row)-peak1<2*fs
        DATA = row(peak1:end);
        DATA = [DATA,zeros(1,4*fs+1-length(DATA))];
    else
        w = row(peak1:peak1+2*fs);
        %DATA = cat(1,zeros(1,len(w)),w);
        DATA = [zeros(1,4*fs+1-length(w)),w]
    end
    winData = [winData;DATA];
    peak = [peak,peak1];
end
plot(peak)

squaredPressure = winData.*winData;
RMS = [];
T90 = [];

for r=1:size(squaredPressure,1)%RMS
    row = squaredPressure(r,:);
    T90a=t90(row);
    RMS = [RMS,10*log10(sum(row)/(fs*T90a))];
    T90 = [T90,T90a];
end

SEL = [];

for r=1:size(RMS,2)%SEL
    sel = RMS(r)+10*log10(T90(r));
    SEL = [SEL,sel];
end 

plot(RMS)

function tnin=t90(x);
    fs = 500;
    tnin = -9999;
    total = sum(x);
    peak = floor(length(x)/2);
    for i=(1:100000)
        if sum(x(peak-i:peak+i))>=0.9*total
            tnin = 2*i/fs;
            return;
        end
    end
end

