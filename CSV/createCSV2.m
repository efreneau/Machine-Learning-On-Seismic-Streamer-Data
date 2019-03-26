function createCSV2(dataFile,P190,csv_dir)
%createCSV2(dataFile,P190,csv_dir)
%
%createCSV2 computes the SEL and SPL at different bands for Minimum Level Metric (MLM)
%outputs those and the navigation data found in the P190 to a CSV file, similar to createCSV. 
%createCSV depends on readMCS, readP190 and readP190 being in the same
%directory as this function to work.
%
%datafile is the raw streamer data. P190 is the navigation file. csv_dir is
%the desired location for the output csv files.
%
%Example Usage:
%createCSV2('D:\Machine Learning\Matlab\Data\Line 05\TAPE0026.REEL\R000081_1342402331.RAW','D:\Machine Learning\Matlab\P190\MGL1212MCS05.mat','csvtest');
%
%For more information see github.com/efreneau/machinelearninguw
    
    fs = 500;
    
    if ispc %Choose path deliminator
        delim = '\';
    else
        delim = '/';
    end
    
    dataFileloc = strsplit(dataFile,delim);
    %csv_dir = strcat(csv_dir,strcat(delim,'CSV',delim));%Add csv to the end
    csv_file = strcat(csv_dir,strjoin(dataFileloc(end-2:end),'_'));%'Line_Tape_File Name.csv'
    csv_file = strcat(csv_file(1:end-3),'csv');
    
    if ~exist(csv_dir, 'dir')%create directory if not present
        mkdir(csv_dir);
    end

    if exist(csv_file, 'file')%return if present print message
        disp(strcat(csv_file,' is already present. File skipped.'))
        return;
    end
 
    fileID = fopen(csv_file,'w');
    
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
    
    N = 8192;
    freq = @(f) round(f*2*N/fs);%define frequencies
    f10 = freq(10);
    f40 = freq(40);
    f70 = freq(70);
    f100 = freq(100);
    f110 = freq(110);
    f140 = freq(140);
    f170 = freq(170);
    f200 = freq(200);

    parfor r=1:recievernum%Find SPL and SEL
        p_t = fData(r,:);
        p_k = fft(p_t);
        for band = (1:5)
            switch band
                case 1%1: 10-110 Hz
                    b1 = f10;
                    b2 = f110;
                    [SEL1(r),SPL1(r)] = MLM([zeros(1,b1-1),p_k(b1:b2),zeros(1,N-b2)]);
                case 2%2: 40-140 Hz
                    b1 = f40;
                    b2 = f140;
                    [SEL2(r),SPL2(r)] = MLM([zeros(1,b1-1),p_k(b1:b2),zeros(1,N-b2)]);
                case 3%3: 70-170 Hz
                    b1 = f70;
                    b2 = f170;
                    [SEL3(r),SPL3(r)] = MLM([zeros(1,b1-1),p_k(b1:b2),zeros(1,N-b2)]);
                case 4%4: 100-200 Hz
                    b1 = f100;
                    b2 = f200;
                    [SEL4(r),SPL4(r)] = MLM([zeros(1,b1-1),p_k(b1:b2),zeros(1,N-b2)]);
                case 5%full: full band
                    [SEL_full(r),SPL_full(r)] = MLMfull(p_t);
            end
        end
    end 
    
    fprintf(fileID,'Date,Time,Depth of Airgun(m),Depth of Reciever(m),X Airgun,Y Airgun,Z Airgun,X_R1,Y_R1,Z_R1,SPL1,SEL1,SPL2,SEL2,SPL3,SEL3,SPL4,SEL4,SEL_full,SPL_full\n');%column names
    for i = 1:recievernum %Append rows
        s = strcat(string(JulianDay),',',string(Time),',',string(Depth),',',string(receiver_depth(i)),',',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(i)),',',string(Y_R1(i)),',',string(Z_R1(i)),',',string(SPL1(i)),',',string(SEL1(i)),',',string(SPL2(i)),',',string(SEL2(i)),',',string(SPL3(i)),',',string(SEL3(i)),',',string(SPL4(i)),',',string(SEL4(i)),',',string(SPL_full(i)),',',string(SEL_full(i)),',','\n');
        fprintf(fileID,s);
    end
    fclose(fileID);
    disp(csv_file)
end

function [SEL,SPL] = MLM(p_k)
%returns minimum SPL and SEL given the FFT of pressure and a band
    N = 8192;
    ip_k2 = abs(ifft(fftshift(p_k))).^2;
    SEi = zeros(1,N);
    for i = (1:N-512)
        SEi(i) = sum(ip_k2(i:512+i));
    end
    SPi = sqrt(SEi/1.024);%1.024=512/fs
    b = ones(1,1000)/1000;
    SEi_bar = filter(b,1,SEi);
    SPi_bar = filter(b,1,SPi);
    SELi = 10*log10(SEi_bar)+120;%relative to micro
    SPLi = 10*log10(SPi_bar)+120;
    SEL = min(SELi);
    SPL = min(SPLi);
end
function [SEL,SPL] = MLMfull(p_t)
%returns minimum SPL and SEL given the FFT of pressure and a band
    N = 8192;
    ip_k2 = p_t.^2;
    SEi = zeros(1,N);
    for i = (1:N-512)
        SEi(i) = sum(ip_k2(i:512+i));
    end
    SPi = sqrt(SEi/1.024);%1.024=512/fs
    b = ones(1,1000)/1000;
    SEi_bar = filter(b,1,SEi);
    SPi_bar = filter(b,1,SPi);
    SELi = 10*log10(SEi_bar)+120;%relative to micro
    SPLi = 10*log10(SPi_bar)+120;
    SEL = min(SELi);
    SPL = min(SPLi);
end




