clear all; clc; close all;

%readMCS(dataFile,P190,resultFile);

loc = {'..\Example_Shots\shallow.mat',...
       '..\Example_Shots\mid.mat',...
       '..\Example_Shots\deep.mat'};

for it=(1:3)
    figure;
    load(loc{it});
    c = 1e9;    %offset, tune this
    fs = 500;
    p = plot(1,1); 
    plt = [p p p p p p p p p p p p p];%blank array of plots
    offset = c*(0:12);%offset array
    
    range = fliplr(sqrt(X_R1.^2+Y_R1.^2+Z_R1.^2));

    sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];
    Data1 = sosfilt(sos,Data1,2);%filter 

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
        set(plt(i), 'YData', get(plt(i), 'YData')+offset(13-i+1))%add offsets
    end

    %Red highlight of area within window
    %{
    for i = (1:13)%for each intended plot
        yt(i) = 50*(i-1);%convert index to channel #
        k = yt(i)+1;
        [n05,n95]=t90_2(Data2(k+d,:).^2);
        plt2(i) = plot(t(n05:n95), Data2(k+d,n05:n95),'r');
        set(plt2(i), 'YData', get(plt2(i), 'YData')+offset(13-i+1))%add offsets
    end
    %}

    yticks(offset)%create ticks
    yticklabels(round(range(yt+d)))%label with channel numbers
end


