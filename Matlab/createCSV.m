function c = createCSV(dataFile,P190,csv_dir)
%createCSV(dataFile,P190)
%
%createCSV computes the RMS and SEL power for the siesmic streamer data and
%outputs those and the navigation data found in the P190 to a CSV file. 
%createCSV depends on readMCS, readP190 and readP190 being in the same
%directory as this function to work.
%
%datafile is the raw streamer data. P190 is the navigation file. csv_dir is
%the desired location for the output csv files. Leave off the slash from
%the end of csv_dir as it will cause an error.
%
%Example Usage:
%createCSV('Matlab/Data/Line AT/R000179_1342879566.RAW','Matlab/P190/MGL1212NTMCS01.mat','Matlab');
%
%For more information see github.com/efreneau/machinelearninguw
    if ispc %Choose path deliminator
        delim = '\';
    else
        delim = '/';
    end
    fs = 500;
    dataFileloc = strsplit(dataFile,delim);
    readMCS(dataFile,P190,'Results.mat');
    load('Results.mat');
    f1 = Data1'*1e6;%unflipped
    
    sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];
    fData = sosfilt(sos,f1,2);%filter
    
    fData = db2mag(6)*fData; %Group length effect +6dB

    squaredPressure = [];%Squared pressure signal windowed around peaks
    peak = [];%Index of peaks
    T90 = [];%Window size of 90% power
    RMS = [];%RMS Power
    SEL = [];%SEL Power


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

    csv_dir = strcat(csv_dir,strcat(delim,'CSV',delim));
    csv_file = strcat(csv_dir,delim,strjoin(dataFileloc(end-2:end),'_'));
    csv_file = strcat(csv_file(1:end-3),'csv');
    
    
    if ~exist(csv_dir, 'dir')%create directory if not present
        mkdir(csv_dir);
    end
    
    if exist(csv_file, 'file')%remove csv if present
        delete(csv_file)
    end
    fileID = fopen(csv_file,'w');
    fprintf(fileID,'Water Depth (m),Date,Time,X Airgun,Y Airgun,Z Airgun,X_R1,Y_R1,Z_R1,SEL,RMS\n');%add column names
    %fprintf(fileID,'Time_UTC,Ocean_Depth_at_Airgun_meter,Ocean_Depth_at_Receivern_meter,X_Airgun,Y_Airgun,Z_Airgun,X_R1,Y_R1,Z_R1,SEL,RMS');
    for i = 1:r %Append rows
        s = strcat(string(Depth),',',string(JulianDay),',',string(Time),',',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(i)),',',string(Y_R1(i)),',',string(Z_R1(i)),',',string(SEL(i)),',',string(RMS(i)),'\n');
        fprintf(fileID,s);
    end
    fclose(fileID);
    disp(csv_file)
end

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


