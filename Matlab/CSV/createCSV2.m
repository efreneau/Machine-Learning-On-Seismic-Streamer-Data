function createCSV2(dataFile,P190,csv_dir)
%Example Usage:
%createCSV2('Z:\DATA\Line_05\TAPE0026.REEL\R000081_1342402331.RAW','D:\Machine Learning\Matlab\P190\MGL1212MCS05.mat','csvtest');
%
%For more information see github.com/efreneau/machinelearninguw
    
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
    fData = Data1';%unflipped
    fData = flip(fData,1);
    
    fs = 500;
    recievernum = size(fData,1);
    SPL1 = zeros(1,recievernum);%preallocate
    SPL2 = zeros(1,recievernum);
    SPL3 = zeros(1,recievernum);
    SPL4 = zeros(1,recievernum);
    SPL_full = zeros(1,recievernum);
    SEL1 = zeros(1,recievernum);
    SEL2 = zeros(1,recievernum);
    SEL3 = zeros(1,recievernum);
    SEL4 = zeros(1,recievernum);
    SEL_full = zeros(1,recievernum);
    peak = zeros(1,recievernum);
    
    parfor r=1:recievernum%Find SPL and SEL
        %p_t = fData(r,:);
        [~,peak(r)] = max(fData(r,:));
        
        for band = (1:5)
            switch band
                case 1%1: 10-110 Hz
                    [SEL1(r),SPL1(r)] = MLM(bandpass(fData(r,:),[10, 110],fs),peak(r));
                case 2%2: 40-140 Hz
                    [SEL2(r),SPL2(r)] = MLM(bandpass(fData(r,:),[40, 140],fs),peak(r));
                case 3%3: 70-170 Hz
                    [SEL3(r),SPL3(r)] = MLM(bandpass(fData(r,:),[70, 170],fs),peak(r));
                case 4%4: 100-200 Hz
                    [SEL4(r),SPL4(r)] = MLM(bandpass(fData(r,:),[100, 200],fs),peak(r));
                case 5%full: full band
                    [SEL_full(r),SPL_full(r)] = MLM(fData(r,:),peak(r));
            end
        end
    end 

    fileID = fopen(csv_file,'w');
    fprintf(fileID,'Date,Time,Depth of Airgun(m),Depth of Reciever(m),X Airgun,Y Airgun,Z Airgun,X_R1,Y_R1,Z_R1,SPL1,SEL1,SPL2,SEL2,SPL3,SEL3,SPL4,SEL4,SEL_full,SPL_full,Peak_Index\n');%column names
    for i = 1:recievernum %Append rows
        s = strcat(string(JulianDay),',',string(Time),',',string(Depth),',',string(receiver_depth(i)),',',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(i)),',',string(Y_R1(i)),',',string(Z_R1(i)),',',string(SPL1(i)),',',string(SEL1(i)),',',string(SPL2(i)),',',string(SEL2(i)),',',string(SPL3(i)),',',string(SEL3(i)),',',string(SPL4(i)),',',string(SEL4(i)),',',string(SPL_full(i)),',',string(SEL_full(i)),',',string(peak(i)),',','\n');
        fprintf(fileID,s);
    end
    fclose(fileID);
    disp(csv_file)
end

function [SEL,SPL] = MLM(p_t, peak)
%returns minimum SPL and SEL given the FFT of pressure and a band
    N = size(p_t,2);
    SEi = zeros(1,N);
    energy = p_t.^2;
    for i = (1:N-512)
        SEi(i) = sum(energy(i:512+i));%index offset
    end
    SPi = sqrt(SEi/1.024);%1.024=512/fs
    b = ones(1,1000)/1000;
    SEi_bar = filter(b,1,SEi);
    SPi_bar = filter(b,1,SPi);
    SELi = 10*log10(SEi_bar)+120;%relative to micro
    SPLi = 10*log10(SPi_bar)+120;
    SEL = min(SELi(peak:end));
    SPL = min(SPLi(peak:end));
end




