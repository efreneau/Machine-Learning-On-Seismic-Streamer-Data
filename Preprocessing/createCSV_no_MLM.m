function createCSV_no_MLM(dataFile,P190,csv_dir)    
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
    RMS = zeros(recievernum);
    SEL = zeros(recievernum);
    
    st = 10*log10(size(fData,2)/fs);%Window size effect in SEL calculation
    
    parfor r=1:recievernum%Find RMS and SEL
        energy = fData(r,:).^2;
        RMS(r) = 10*log10(mean(energy));
        SEL(r) = RMS(r) + st;     
    end 
    try
        fileID = fopen(csv_file,'w');
        fprintf(fileID,strcat('Line,Tape,File,Date,Time,Depth_at_Airgun(m),Depth_at_Reciever(m),X_Airgun,Y_Airgun,Z_Airgun,X_R1,Y_R1,Z_R1,',...%column names
                               'RMS,SEL\n'));
        for i = 1:recievernum %Append rows
            fprintf(fileID,strcat(string(linename),',',string(tapename),',',string(filename),',',string(JulianDay),',',string(Time),',',string(Depth),',',string(receiver_depth(i)),',',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(recievernum-i+1)),',',string(Y_R1(recievernum-i+1)),',',string(Z_R1(recievernum-i+1))));
            fprintf(fileID,strcat(',',string(RMS(i))));
            fprintf(fileID,strcat(',',string(SEL(i))));
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


