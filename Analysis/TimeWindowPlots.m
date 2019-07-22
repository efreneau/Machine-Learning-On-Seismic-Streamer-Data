clear all; close all; clc;
%createMAT('Z:\DATA\Line_AT\TAPE0106.REEL\R000179_1342879566.RAW','..\P190\MGL1212NTMCS01.mat','..\example_shots\shallow.mat')
%createMAT('Z:\DATA\Line_05\TAPE0028.REEL\R000028_1342408921.RAW','..\P190\MGL1212MCS05.mat','..\example_shots\deep.mat')
%createMAT('Z:\DATA\Line_07\TAPE0048.REEL\R000319_1342512128.RAW','..\P190\MGL1212MCS07.mat','..\example_shots\mid.mat')

start = 0.1;
stop = 16;
step = 0.5;

load('..\Example_Shots\shallow.mat');
[t90,rms,sel] = sim(Data1,start,stop,step,'(shallow)');
load('..\Example_Shots\mid.mat');
[t90,rms,sel] = sim(Data1,start,stop,step,'(mid)');
load('..\Example_Shots\deep.mat');
[t90,rms,sel] = sim(Data1,start,stop,step,'(deep)');

function [t90,rms,sel] = sim(x,start,stop,step,descriptor)
    [~,rms_ref,sel_ref] = metrics2(x,1);%reference to 1 second
    t = (start:step:stop);
    rms = zeros(1,length(t));
    sel = zeros(1,length(t));
    t90 = zeros(1,length(t));
    i = 1;
    for size = t
        [t90(i),rms(i),sel(i)] = metrics2(x,size);
        i = i + 1;
    end
    rms = rms - rms_ref;
    sel = sel - sel_ref;
    
    figure; hold on; grid on;
    plot(t,rms)
    plot(t,sel)
    legend('rms','sel');
    title(strcat('effects of window size ',descriptor))
    xlabel('Window Length (s)')
    ylabel('Normalized Power Level (dB)')
    
    figure; grid on;
    plot(t,t90)
    title(strcat('T90 over window size ',descriptor))
    xlabel('Time Window (s)')
    ylabel('T90 (s)')
end
function [t90,rms,sel] = metrics2(x,size1)%3 metrics calculated for an arbitrary window around peak, takes pressure as input, size of window in seconds
    fs = 500;
    recievernum = size(x,1);
    e = x.^2;
    [~,peak] = max(e,[],2);%loc of max energy
    T90 = zeros(1,recievernum);%Window size of 90% power
    RMS = zeros(1,recievernum);
    SEL = zeros(1,recievernum);
    win = round((size1)*fs);
    half_win = round((size1/2)*fs);
    for r=1:recievernum
        if peak(r) <= half_win %Region 1: Peak is too close to the first index
            e_windowed = [zeros(1, win + 1 - (peak(r)+ half_win)),e(r,1:peak(r)+half_win)];%make this more convenient later
        elseif peak(r) > half_win && length(e(r,:)) - peak(r)>=half_win %Region 2: Peak has space on either side
            e_windowed = e(r,peak(r)-half_win:peak(r)+half_win);
        else %Region 3: Peak is too close to the end
            e_windowed = [e(r,peak(r)-half_win:end), zeros(1,half_win - (size(e,2)-peak(r)))];%size1
            
        end
        T90(r) = comp_t90(e_windowed);
        RMS(r) = 10*log10(sum(e_windowed)/(2*fs*T90(r)));
        SEL(r) = RMS(r)+10*log10(T90(r));
    end
    %plot(T90)
    t90 = trimmean(T90,10);
    rms = trimmean(RMS,10);
    sel = trimmean(SEL,10);
    
end
function tnin = comp_t90(x)%t90 calculation for a arbitrary window, takes energy as input
    fs = 500;
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
    tnin = (n95-n05)/fs;%compute T90 = t95-t05
end