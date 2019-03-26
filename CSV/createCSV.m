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

    T90 = zeros(5,recievernum);%Window size of 90% power
    RMS = zeros(5,recievernum);%RMS Power
    SEL = zeros(5,recievernum);%SEL Power
    
    N = 2001;
    freq = @(f) round(f*2*N/fs);%define frequencies
    f10 = freq(10);
    f40 = freq(40);
    f70 = freq(70);
    f100 = freq(100);
    f110 = freq(110);
    f140 = freq(140);
    f170 = freq(170);
    f200 = freq(200);

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
        e_f = fft(DATA);
        e = DATA;
        for band = 1:5%for each frequency band
            switch band
                case 1%1: 10-110 Hz
                    b1 = f10;
                    b2 = f110;
                    e = abs(ifft(fftshift([zeros(1,b1-1),e_f(b1:b2),zeros(1,N-b2)])));
                case 2%2: 40-140 Hz
                    b1 = f40;
                    b2 = f140;
                    e = abs(ifft(fftshift([zeros(1,b1-1),e_f(b1:b2),zeros(1,N-b2)])));
                case 3%3: 70-170 Hz
                    b1 = f70;
                    b2 = f170;
                    e = abs(ifft(fftshift([zeros(1,b1-1),e_f(b1:b2),zeros(1,N-b2)])));
                case 4%4: 100-200 Hz
                    b1 = f100;
                    b2 = f200;
                    e = abs(ifft(fftshift([zeros(1,b1-1),e_f(b1:b2),zeros(1,N-b2)])));
                case 5%full: full band
                    e=DATA;
            end
            T90(band,r) = t90(e);
            RMS(band,r) = 10*log10(sum(e)/(2*fs*T90(band,r)));
            SEL(band,r) = RMS(band,r)+10*log10(T90(band,r)); 
        end
    end 
    
    fprintf(fileID,'Date,Time,Depth of Airgun(m),Depth of Reciever(m),X Airgun,Y Airgun,Z Airgun,X_R1,Y_R1,Z_R1,SEL1,RMS1,SEL2,RMS2,SEL3,RMS3,SEL4,RMS4,SEL_full,RMS_full,T90_1,T90_2,T90_3,T90_4,T90_full\n');%column names
    for i = 1:recievernum %Append rows
        s = strcat(string(JulianDay),',',string(Time),',',string(Depth),',',string(receiver_depth(i)),',',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(i)),',',string(Y_R1(i)),',',string(Z_R1(i)),',',string(SEL(1,i)),',',string(RMS(1,i)),',',string(SEL(2,i)),',',string(RMS(2,i)),',',string(SEL(3,i)),',',string(RMS(3,i)),',',string(SEL(4,i)),',',string(RMS(4,i)),',',string(SEL(5,i)),',',string(RMS(5,i)),',',string(T90(1,i)),',',string(T90(2,i)),',',string(T90(3,i)),',',string(T90(4,i)),',',string(T90(5,i)),'\n');
        fprintf(fileID,s);
    end
    fclose(fileID);
    disp(csv_file)
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
    tnin = (n95-n05)/fs;%compute T90 = t95-t05
end
%createCSV('C:\Users\admin\Desktop\Machine Learning\Matlab\R000540_1342888533.RAW','C:\Users\admin\Desktop\Machine Learning\Matlab\P190\MGL1212NTMCS01.mat','C:\Users\admin\Desktop\Machine Learning\Matlab\test')
%createCSV('C:\Users\admin\Desktop\Machine Learning\Matlab\R000095_1342877588.RAW','C:\Users\admin\Desktop\Machine Learning\Matlab\P190\MGL1212NTMCS01.mat','C:\Users\admin\Desktop\Machine Learning\Matlab\test2')


