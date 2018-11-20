function createCSV(dataFile,P190,csv_dir)
%createCSV(dataFile,P190,csv_dir)
%
%createCSV computes the RMS and SEL power for the siesmic streamer data and
%outputs those and the navigation data found in the P190 to a CSV file. 
%createCSV depends on readMCS, readP190 and readP190 being in the same
%directory as this function to work.
%
%datafile is the raw streamer data. P190 is the navigation file. csv_dir is
%the desired location for the output csv files.
%
%Example Usage:
%createCSV('Matlab/Data/Line AT/R000179_1342879566.RAW','Matlab/P190/MGL1212NTMCS01.mat','Matlab');
%createCSV('Matlab/Data/Line AT/R000179_1342879566.RAW','Matlab/P190/MGL1212NTMCS01.mat','Matlab');
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
    f1 = Data1'*1e6;%unflipped
    
    sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];
    fData = sosfilt(sos,f1,2);%filter
    
    fData = db2mag(6)*fData; %Group length effect +6dB
    recievernum = size(fData,1);

    T90 = zeros(1,recievernum);%Window size of 90% power
    RMS = zeros(1,recievernum);%RMS Power
    SEL = zeros(1,recievernum);%SEL Power

    parfor r=1:recievernum%Find RMS and SEL
        row = fData(r,:);
        [~,peak1] = max(row);
        if peak1 <= 2*fs%Region 1: Peak is too close to the first index
            DATA = row(1:peak1+2*fs).^2;%from peak1
            DATA = [zeros(1,4*fs + 1 - length(DATA)),DATA];
        elseif peak1 > 2*fs && length(row) - peak1>=2*fs%Region 2: Peak has space on either side
            DATA = row(peak1-2*fs:peak1+2*fs).^2;
        else %Region 3: Peak is too close to the end
            DATA = row(peak1-2*fs:end).^2;
            DATA = [DATA, zeros(1,4*fs + 1 - length(DATA))];
        end
        T90(r) = t90(DATA);
        RMS(r) = 10*log10(sum(DATA)/(2*fs*T90(r)));
        SEL(r) = RMS(r)+10*log10(T90(r)); 
    end 
    
    fprintf(fileID,'Date,Time,Depth of Airgun(m),Depth of Reciever(m),X Airgun,Y Airgun,Z Airgun,X_R1,Y_R1,Z_R1,SEL,RMS,T90\n');%column names
    for i = 1:recievernum %Append rows
        s = strcat(string(JulianDay),',',string(Time),',',string(Depth),',',string(receiver_depth(i)),',',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(i)),',',string(Y_R1(i)),',',string(Z_R1(i)),',',string(SEL(i)),',',string(RMS(i)),',',string(T90(i)),'\n');
        fprintf(fileID,s);
    end
    fclose(fileID);
    disp(csv_file)
    close all;
    plot(T90)%%%
    figure;
    plot(SEL)
    hold on;
    plot(RMS)
end

function tnin=t90(x)%t90 calculation for a 4s window
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
    tnin = (n95-n05)/fs%compute T90 = t95-t05
end
%createCSV('C:\Users\admin\Desktop\Machine Learning\Matlab\R000540_1342888533.RAW','C:\Users\admin\Desktop\Machine Learning\Matlab\P190\MGL1212NTMCS01.mat','C:\Users\admin\Desktop\Machine Learning\Matlab\test')
%createCSV('C:\Users\admin\Desktop\Machine Learning\Matlab\R000095_1342877588.RAW','C:\Users\admin\Desktop\Machine Learning\Matlab\P190\MGL1212NTMCS01.mat','C:\Users\admin\Desktop\Machine Learning\Matlab\test2')


