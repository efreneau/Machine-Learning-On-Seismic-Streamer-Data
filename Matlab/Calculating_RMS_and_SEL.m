clear all; close all; clc;
fs = 500;

dataFile = 'R000179_1342879566.RAW';
P190 = 'MGL1212NTMCS01.mat';

readMCS(strcat('Data/Line AT/',dataFile),strcat('P190/',P190),'Results.mat');
load('Results.mat')

%f1 = flipud(Data1')*1e6;
f1 = Data1'*1e6;%unflipped
sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];

fData = sosfilt(sos,f1,2);%filter
fData = db2mag(6)*fData; %group length effect

squaredPressure = [];%squared pressure signal windowed around peaks
peak = [];
T90 = [];
RMS = [];
SEL = [];


%Find peaks, window around peaks and calculate T90.
for r=1:size(fData,1)
    row = fData(r,:);
    [val,peak1] = max(row);
    if peak1 <= 2*fs%Region 1: Peak is too close to the first index
        DATA = row(1:peak1+2*fs).^2;%from peak1
        DATA = [zeros(1,4*fs + 1 - length(DATA)),DATA];
        T90 = [T90,t90(DATA)];
    elseif peak1 > 2*fs && length(row) - peak1>=1000%Region 2: Peak has space on either side
        DATA = row(peak1-2*fs:peak1+2*fs).^2;
        T90 = [T90,t90(DATA)];
    else %Region 3: Peak is too close to the end
        DATA = row(peak1-2*fs:end).^2;%-2fs
        DATA = [DATA, zeros(1,4*fs + 1 - length(DATA))];
        T90 = [T90,t90(DATA)];
    end
    squaredPressure = [squaredPressure;DATA];
    peak = [peak,peak1];
end

for r=1:size(squaredPressure,1)%RMS
    row = squaredPressure(r,:);
    T90a = T90(r);
    RMS = [RMS,10*log10(sum(row)/(2*fs*T90a))];%extra fs
end

for r=1:size(RMS,2)%SEL
    sel = RMS(r)+10*log10(T90(r));
    SEL = [SEL,sel];
end 
%{
plot(peak)
figure
plot(T90)
figure;
plot(RMS)
figure;
plot(SEL)
%}

csv_file = strcat('CSV/',P190(1:end-4),'.csv');%create file name and directory for a specific recording

if ~exist('CSV', 'dir')%create directory if not present
    mkdir('CSV');
end

if exist(csv_file, 'file')%remove csv if present
    delete(csv_file)
end
fileID = fopen(csv_file,'w');
fprintf(fileID,'Water Depth (m),Date,Time,X Airgun,Y Airgun,Z Airgun,X_R1,Y_R1,Z_R1,SEL,RMS\n');%add column names
for i = 1:r %append rows
    s = strcat(string(Depth),',',string(JulianDay),',',string(Time),',',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(i)),',',string(Y_R1(i)),',',string(Z_R1(i)),',',string(SEL(i)),',',string(RMS(i)),'\n');
    fprintf(fileID,s);
end
fclose(fileID);

function tnin=t90(x);%t90 calculation for normal window
    fs = 500;
    tnin = -9999;
    total = sum(x);%calculate total
    peak = ceil(length(x)/2);%peak is in the middle of the window
    for i=(1:100000)
        if sum(x(peak-i:peak+i))>=0.9*total%iterate over window sizes untill it reaches 90%
            tnin = 2*i/fs;%return window sizes in seconds
            return;
        end
    end
end



