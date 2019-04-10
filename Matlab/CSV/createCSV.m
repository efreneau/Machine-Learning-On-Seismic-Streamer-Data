function createCSV(dataFile,P190,csv_dir)
%createCSV('Z:\DATA\Line_05\TAPE0026.REEL\R000081_1342402331.RAW','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\P190\MGL1212MCS05.mat','csvtest');
%For more information see github.com/efreneau/machinelearninguw
    
    fs = 500;
    
    if ispc %Choose path deliminator
        delim = '\';
    else
        delim = '/';
    end
    
    dataFileloc = strsplit(dataFile,delim);
    csv_file = strcat(csv_dir,strjoin(dataFileloc(end-2:end),'_'));%'Line_Tape_File Name.csv'
    csv_file = strcat(csv_file(1:end-3),'csv');
    
    if ~exist(csv_dir, 'dir')%create directory if not present
        mkdir(csv_dir);
    end

    if exist(csv_file, 'file')%return if present print message
        disp(strcat(csv_file,' is already present. File skipped.'))
        return;
    end
 
    result = strjoin(dataFileloc(end-2:end),'_');
    result = strcat(result(1:end-3),'mat');%Make name for matlab data
    
    result_dir = strcat(csv_dir,strcat(delim,'MatlabData',delim));%create folder for matlab converted data
    if ~exist(result_dir, 'dir')%create directory if not present
        mkdir(result_dir);
    end
    
    resultFile = strcat(result_dir,delim,result);
    disp(dataFile)
    readMCS(dataFile,P190,resultFile);
    load(resultFile);
    f1 = Data1'*1e6;
    f1 = flip(f1,1);
    
    sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];
    fData = sosfilt(sos,f1,2);%filter
    
    fData = db2mag(6)*fData; %Group length effect +6dB
    recievernum = size(fData,1);
    
    T90 = zeros(5,recievernum);%Window size of 90% power
    RMS = zeros(5,recievernum);
    SEL = zeros(5,recievernum);
    peak = zeros(1,recievernum);
    ts_windowed = zeros(recievernum,4*fs+1);
    e = zeros(recievernum,4*fs+1);%energy after filtering, windowed
    
    parfor r=1:recievernum%Find RMS and SEL
        %row = fData(r,:);
        [~,peak(r)] = max(fData(r,:));
        if peak(r) <= 2*fs%Region 1: Peak is too close to the first index
            ts_windowed(r,:) = [zeros(1,4*fs + 1 - (peak(r)+2*fs)),fData(r,1:peak(r)+2*fs)];
        elseif peak(r) > 2*fs && length(fData(r,:)) - peak(r)>=2*fs%Region 2: Peak has space on either side
            ts_windowed(r,:) = fData(r,peak(r)-2*fs:peak(r)+2*fs);
        else%Region 3: Peak is too close to the end
            ts_windowed(r,:) = [fData(r,peak(r)-2*fs:end), zeros(1,2*fs - (size(fData,2)-peak(r)))];
        end

        for band = 1:5%for each frequency band
            switch band
                case 1%1: 10-110 Hz
                    e(r,:) = bandpass(ts_windowed(r,:),[10, 110],fs).^2;
                case 2%2: 40-140 Hz
                    e(r,:) = bandpass(ts_windowed(r,:),[40, 140],fs).^2;
                case 3%3: 70-170 Hz
                    e(r,:) = bandpass(ts_windowed(r,:),[70, 170],fs).^2;
                case 4%4: 100-200 Hz
                    e(r,:) = bandpass(ts_windowed(r,:),[100, 200],fs).^2;
                case 5%full: full band
                    e(r,:) = ts_windowed(r,:).^2;
            end
            T90(band,r) = t90(e(r,:));
            RMS(band,r) = 10*log10(sum(e(r,:))/(2*fs*T90(band,r)));
            SEL(band,r) = RMS(band,r)+10*log10(T90(band,r)); 
        end
    end 
    
    fileID = fopen(csv_file,'w');
    fprintf(fileID,'Date,Time,Depth of Airgun(m),Depth of Reciever(m),X Airgun,Y Airgun,Z Airgun,X_R1,Y_R1,Z_R1,SEL1,RMS1,SEL2,RMS2,SEL3,RMS3,SEL4,RMS4,SEL_full,RMS_full,T90_1,T90_2,T90_3,T90_4,T90_full\n');%column names
    for i = 1:recievernum %Append rows
        s = strcat(string(JulianDay),',',string(Time),',',string(Depth),',',string(receiver_depth(i)),',',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(i)),',',string(Y_R1(i)),',',string(Z_R1(i)),',',string(SEL(1,i)),',',string(RMS(1,i)),',',string(SEL(2,i)),',',string(RMS(2,i)),',',string(SEL(3,i)),',',string(RMS(3,i)),',',string(SEL(4,i)),',',string(RMS(4,i)),',',string(SEL(5,i)),',',string(RMS(5,i)),',',string(T90(1,i)),',',string(T90(2,i)),',',string(T90(3,i)),',',string(T90(4,i)),',',string(T90(5,i)),'\n');
        fprintf(fileID,s);
    end
    fclose(fileID);
    disp(csv_file)
end

function tnin=t90(x)%t90 calculation for a 4s window, takes energy as input
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

