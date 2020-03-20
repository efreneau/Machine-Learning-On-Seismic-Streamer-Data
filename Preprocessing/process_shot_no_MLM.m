function process_shot_no_MLM(dataFile,P190,csv_dir)    
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
    SEL = zeros(14,recievernum);%SEL(band,r)
    
    parfor r=1:recievernum%Find SEL over the whole time window
        for band = 1:14%for each frequency band
            switch band% 1/3-octave bands
                case 1% 11.2-14.1 Hz
                    mag = bandpass(fData(r,:),[11.2, 14.1],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 2% 14.1-17.8 Hz
                    mag = bandpass(fData(r,:),[14.1, 17.8],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 3% 17.8-22.4 Hz
                    mag = bandpass(fData(r,:),[17.8, 22.4],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 4% 22.4-28.2 Hz
                    mag = bandpass(fData(r,:),[22.4, 28.2],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 5% 28.2-35.5 Hz
                    mag = bandpass(fData(r,:),[28.2, 35.5],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 6% 35.5-44.7 Hz
                    mag = bandpass(fData(r,:),[35.5, 44.7],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 7% 44.7-56.2 Hz
                    mag = bandpass(fData(r,:),[44.7, 56.2],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 8% 56.2-70.8 Hz
                    mag = bandpass(fData(r,:),[56.2, 70.8],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 9% 70.8-89.1 Hz
                    mag = bandpass(fData(r,:),[70.8, 89.1],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 10% 89.1-112 Hz
                    mag = bandpass(fData(r,:),[89.1, 112],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 11% 112-141 Hz
                    mag = bandpass(fData(r,:),[112, 141],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 12% 141-178 Hz
                    mag = bandpass(fData(r,:),[141, 178],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 13% 178-224 Hz
                    mag = bandpass(fData(r,:),[178, 224],fs);
                    SEL(band,r) = 10*log10(dot(mag,mag));
                case 14%full: full band
                    mag = fData(r,:);
                    SEL(band,r) = 10*log10(dot(mag,mag));
            end
        end
    end
    try
        fileID = fopen(csv_file,'w');
        fprintf(fileID,strcat('Line,Tape,File,Date,Time,Depth_at_Airgun(m),Depth_at_Reciever(m),X_Airgun,Y_Airgun,Z_Airgun,X_R1,Y_R1,Z_R1,',...%column names
                               'SEL_1,SEL_2,SEL_3,SEL_4,SEL_5,SEL_6,SEL_7,SEL_8,SEL_9,SEL_10,SEL_11,SEL_12,SEL_13,SEL_full\n'));
        for i = 1:recievernum %Append rows
            fprintf(fileID,strcat(string(linename),',',string(tapename),',',string(filename),',',string(JulianDay),',',string(Time),',',string(Depth),',',string(receiver_depth(i)),',',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(recievernum-i+1)),',',string(Y_R1(recievernum-i+1)),',',string(Z_R1(recievernum-i+1))));
            for j=(1:14)
                fprintf(fileID,strcat(',',string(SEL(j,i))));
            end
            fprintf(fileID,'\n');
        end 
        fclose(fileID);
    catch er
        fclose(fileID);
        delete(sprintf('%s',csv_file))
        %disp(['ID: ' ME.identifier])
        %rethrow(er);
    end
end


