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
    f1 = Data1'*1e6;%pascal to micropascal
    f1 = flip(f1,1);%flip to closest reciever being first
    f1 = db2mag(6)*f1; %Group length effect +6dB
    
    sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];
    fData = sosfilt(sos,f1,2);%filter
     
    recievernum = size(fData,1);
    T90 = zeros(14,recievernum);%Window size of 90% power
    RMS = zeros(14,recievernum);
    SEL = zeros(14,recievernum);
    SPL = zeros(14,recievernum);
    SEL_MLM = zeros(14,recievernum);
    peak = zeros(14,recievernum);
    
    parfor r=1:recievernum%Find RMS and SEL
        for band = 1:14%for each frequency band
            switch band% 1/3-octave bands
                case 1% 11.2-14.1 Hz
                    energy = bandpass(fData(r,:),[11.2, 14.1],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 2% 14.1-17.8 Hz
                    energy = bandpass(fData(r,:),[14.1, 17.8],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 3% 17.8-22.4 Hz
                    energy = bandpass(fData(r,:),[17.8, 22.4],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 4% 22.4-28.2 Hz
                    energy = bandpass(fData(r,:),[22.4, 28.2],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 5% 28.2-35.5 Hz
                    energy = bandpass(fData(r,:),[28.2, 35.5],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 6% 35.5-44.7 Hz
                    energy = bandpass(fData(r,:),[35.5, 44.7],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 7% 44.7-56.2 Hz
                    energy = bandpass(fData(r,:),[44.7, 56.2],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 8% 56.2-70.8 Hz
                    energy = bandpass(fData(r,:),[56.2, 70.8],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 9% 70.8-89.1 Hz
                    energy = bandpass(fData(r,:),[70.8, 89.1],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 10% 89.1-112 Hz
                    energy = bandpass(fData(r,:),[89.1, 112],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 11% 112-141 Hz
                    energy = bandpass(fData(r,:),[112, 141],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 12% 141-178 Hz
                    energy = bandpass(fData(r,:),[141, 178],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 13% 178-224 Hz
                    energy = bandpass(fData(r,:),[178, 224],fs).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
                case 14%full: full band
                    energy = fData(r,:).^2;
                    [~,peak(band,r)] = max(energy(1:7*fs),[],2);%no filtering
                    [T90(band,r),RMS(band,r),SEL(band,r)] = metrics(energy,peak(band,r));
                    [SEL_MLM(band,r),SPL(band,r)] = MLM(energy, peak(band,r));
            end
        end
    end 
    try
        fileID = fopen(csv_file,'w');
        fprintf(fileID,strcat('Line,Tape,File,Date,Time,Depth of Airgun(m),Depth of Reciever(m),X Airgun,Y Airgun,Z Airgun,X_R1,Y_R1,Z_R1,',...%column names
                               'Peak_Index,Peak_1,Peak_2,Peak_3,Peak_4,Peak_5,Peak_6,Peak_7,Peak_8,Peak_9,Peak_10,Peak_11,Peak_12,Peak_13,',...
                               'T90_1,T90_2,T90_3,T90_4,T90_5,T90_6,T90_7,T90_8,T90_9,T90_10,T90_11,T90_12,T90_13,T90_full,',...
                               'RMS_1,RMS_2,RMS_3,RMS_4,RMS_5,RMS_6,RMS_7,RMS_8,RMS_9,RMS_10,RMS_11,RMS_12,RMS_13,RMS_full,',...
                               'SEL_1,SEL_2,SEL_3,SEL_4,SEL_5,SEL_6,SEL_7,SEL_8,SEL_9,SEL_10,SEL_11,SEL_12,SEL_13,SEL_full,',...
                               'SPL_MLM_1,SPL_MLM_2,SPL_MLM_3,SPL_MLM_4,SPL_MLM_5,SPL_MLM_6,SPL_MLM_7,SPL_MLM_8,SPL_MLM_9,SPL_MLM_10,SPL_MLM_11,SPL_MLM_12,SPL_MLM_13,SPL_MLM_full,',...
                               'SEL_MLM_1,SEL_MLM_2,SEL_MLM_3,SEL_MLM_4,SEL_MLM_5,SEL_MLM_6,SEL_MLM_7,SEL_MLM_8,SEL_MLM_9,SEL_MLM_10,SEL_MLM_11,SEL_MLM_12,SEL_MLM_13,SEL_MLM_full\n'));
        for i = 1:recievernum %Append rows
            fprintf(fileID,strcat(string(linename),',',string(tapename),',',string(filename),',',string(JulianDay),',',string(Time),',',string(Depth),',',string(receiver_depth(i)),',',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(i)),',',string(Y_R1(i)),',',string(Z_R1(i)),',',string(peak(14,i))));
            for j=(1:13)
                fprintf(fileID,strcat(',',string(peak(j,i))));
            end
            for j=(1:14)
                fprintf(fileID,strcat(',',string(T90(j,i))));
            end
            for j=(1:14)
                fprintf(fileID,strcat(',',string(RMS(j,i))));
            end
            for j=(1:14)
                fprintf(fileID,strcat(',',string(SEL(j,i))));
            end
            for j=(1:14)
                fprintf(fileID,strcat(',',string(SPL(j,i))));
            end
            for j=(1:14)
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
    SELi = 10*log10(SEi_bar);
    SPLi = 20*log10(SPi_bar);
    SEL = min(SELi(peak:peak+9*fs));%Look for minimum up to 9s away from peak
    SPL = min(SPLi(peak:peak+9*fs));
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

