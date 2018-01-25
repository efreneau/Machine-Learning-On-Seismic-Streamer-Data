function [] = readMCS(Data_File,P190_File,ResultsFileName)
    % ************************* Import P190 File ******************************
%     P190_File = 'C:\Users\sabadi\Desktop\Line AT\P190\MGL1212NTMCS01.mat';
    load (P190_File);    % Choose a data file from the folder named "Data"
    % ************************* Import MCS File *******************************
%     Data_File = 'C:\Users\sabadi\Desktop\Line AT\TAPE0106.REEL\R000179_1342879566.RAW';
    [header, traces] = readSegd(Data_File); % Choose a P190 (navigation) file from the folder named "P190"

    JulianDay = header.julianDay;  % JulianDay
    Time = strcat(num2str(header.hour),':',num2str(header.minute),':',num2str(header.second));
    ShotPoint = nav.shotNumber(header.fileNumber); 
    Depth = nav.depth(header.fileNumber);
    X_Airgun = nav.sourceX(header.fileNumber); 
    Y_Airgun = nav.sourceY(header.fileNumber);
    Z_Airgun = 9; 
    X_Vessel = nav.vesselX(header.fileNumber)-X_Airgun; 
    Y_Vessel = nav.vesselY(header.fileNumber)-Y_Airgun;

    receivernum1 = header.channelSet1Channels; 
    % receivernum2 = header.channelSet2Channels;
    % ++++++ First Streamer
    x_r_utc1 = zeros(1,receivernum1); y_r_utc1 = zeros(1,receivernum1);
    X_R1 = zeros(1,receivernum1); Y_R1 = zeros(1,receivernum1); Z_R1 = zeros(1,receivernum1);
    for u = 1:receivernum1
        if sqrt((X_Airgun-nav.receiverX(112,header.fileNumber))^2+(Y_Airgun-nav.receiverY(112,header.fileNumber))^2) < sqrt((X_Airgun-nav.receiverX(111,header.fileNumber))^2+(Y_Airgun-nav.receiverY(111,header.fileNumber))^2)     
            x_r_utc1(u) = nav.receiverX(u,header.fileNumber);
            y_r_utc1(u) = nav.receiverY(u,header.fileNumber);
        else
            x_r_utc1(u) = nav.receiverX(receivernum1-u+1,header.fileNumber);
            y_r_utc1(u) = nav.receiverY(receivernum1-u+1,header.fileNumber);
        end
        if (all(x_r_utc1(u)) ~= 0) && (all(y_r_utc1(u)) ~= 0)
            X_R1(u) = x_r_utc1(u)-X_Airgun;
            Y_R1(u) = y_r_utc1(u)-Y_Airgun;
        else 
            X_R1(u) = 0;
            Y_R1(u) = 0;
        end       
        Z_R1(u) = 9;
    end
    x1 = traces.channelSet1; 
    Data1 = double(x1);

    L = length(Data1);
    Fs = L./header.recordLength;
    %% ***************************** SAVE DATA ********************************
    save(ResultsFileName,'Data1','receivernum1','X_Airgun','Y_Airgun','Z_Airgun','X_Vessel','Y_Vessel','X_R1','Y_R1','Z_R1','Depth','ShotPoint','Time','JulianDay')  