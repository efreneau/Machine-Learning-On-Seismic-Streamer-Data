function createCSV3(dataFile,P190,csv_dir)
%createCSV3('Z:\DATA\Line_05\TAPE0026.REEL\R000081_1342402331.RAW','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\P190\MGL1212MCS05.mat','csvtest');
%For more information see github.com/efreneau/machinelearninguw
    
    fs = 500;
    
    if ispc %Choose path deliminator
        delim = '\';
    else
        delim = '/';
    end
    
    dataFileloc = strsplit(dataFile,delim);
    filename = dataFileloc(end);
    tapename = dataFileloc(end-1);
    linename = dataFileloc(end-2);
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
    SPL = zeros(5,recievernum);
    SEL_MLM = zeros(5,recievernum);
    e = zeros(size(fData));%energy after filtering, windowed
    [~,peak] = max(fData,[],2);
    
    parfor r=1:recievernum%Find RMS and SEL
        for band = 1:5%for each frequency band
            switch band
                case 1%1: 10-110 Hz
                    e(r,:) = bandpass(fData(r,:),[10, 110],fs).^2;
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(e(r,:),peak(r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(e(r,:), peak(r));
                case 2%2: 40-140 Hz
                    e(r,:) = bandpass(fData(r,:),[40, 140],fs).^2;
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(e(r,:),peak(r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(e(r,:), peak(r));
                case 3%3: 70-170 Hz
                    e(r,:) = bandpass(fData(r,:),[70, 170],fs).^2;
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(e(r,:),peak(r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(e(r,:), peak(r));
                case 4%4: 100-200 Hz
                    e(r,:) = bandpass(fData(r,:),[100, 200],fs).^2;
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(e(r,:),peak(r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(e(r,:), peak(r));
                case 5%full: full band
                    e(r,:) = fData(r,:).^2;%no filtering
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(e(r,:),peak(r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(e(r,:), peak(r));
            end
        end
    end 
    try
        fileID = fopen(csv_file,'w');
        %add line tape and file
        fprintf(fileID,'Line,Tape,File,Date,Time,Depth of Airgun(m),Depth of Reciever(m),X Airgun,Y Airgun,Z Airgun,X_R1,Y_R1,Z_R1,Peak_Index,T90_1,T90_2,T90_3,T90_4,T90_5,RMS_1,RMS_2,RMS_3,RMS_4,RMS_5,SEL_1,SEL_2,SEL_3,SEL_4,SEL_5,SPL_MLM_1,SPL_MLM_2,SPL_MLM_3,SPL_MLM_4,SPL_MLM_5,SEL_MLM_1,SEL_MLM_2,SEL_MLM_3,SEL_MLM_4,SEL_MLM_5\n');%column names
        for i = 1:recievernum %Append rows
            fprintf(fileID,strcat(string(linename),',',string(tapename),',',string(filename),',',string(JulianDay),',',string(Time),',',string(Depth),',',string(receiver_depth(i)),',',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(i)),',',string(Y_R1(i)),',',string(Z_R1(i)),',',string(peak(i))));
            for j=(1:5)
                fprintf(fileID,strcat(',',string(T90(j,i))));
            end
            for j=(1:5)
                fprintf(fileID,strcat(',',string(RMS(j,i))));
            end
            for j=(1:5)
                fprintf(fileID,strcat(',',string(SEL(j,i))));
            end
            for j=(1:5)
                fprintf(fileID,strcat(',',string(SPL(j,i))));
            end
            for j=(1:5)
                fprintf(fileID,strcat(',',string(SEL_MLM(j,i))));
            end
            fprintf(fileID,'\n');
        end 
        fclose(fileID);
    catch er
        fclose(fileID);
        del csv_file;
        disp(['ID: ' ME.identifier])
        rethrow(er);
    end
end

function [SEL,SPL] = MLM(energy, peak)
%returns minimum SPL and SEL given the FFT of pressure and a band
    fs = 500;
    N = size(energy,2);
    SEi = zeros(1,N);
    for i = (1:N-512)
        SEi(i) = sum(energy(i:512+i))/fs;%index offset
    end
    SPi = sqrt(SEi/1.024);%1.024=512/fs
    b = ones(1,1000)/1000;
    SEi_bar = filter(b,1,SEi);
    SPi_bar = filter(b,1,SPi);
    SELi = 10*log10(SEi_bar);%clarify
    SPLi = 10*log10(SPi_bar);
    SEL = min(SELi(peak:end));
    SPL = min(SPLi(peak:end));
end

function [t90,rms,sel] = metrics(e,peak)
    fs = 500;
    if peak <= 2*fs %Region 1: Peak is too close to the first index
        e_windowed = [zeros(1,4*fs + 1 - (peak+2*fs)),e(1:peak+2*fs)];
    elseif peak > 2*fs && length(e) - peak>=2*fs %Region 2: Peak has space on either side
        e_windowed = e(peak-2*fs:peak+2*fs);
    else %Region 3: Peak is too close to the end
        e_windowed = [e(peak-2*fs:end), zeros(1,2*fs - (size(e,2)-peak))];
    end
    t90 = comp_t90(e_windowed);
    rms = 10*log10(sum(e_windowed)/(2*fs*t90));
    sel = rms+10*log10(t90);
    
        function tnin = comp_t90(x)%t90 calculation for a 4s window, takes energy as input
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
end

