function createMAT(dataFile,P190,resultFile)
    readMCS(dataFile,P190,'temp.mat');
    load('temp.mat');
    fs = 500;

    sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];
    Data1 = sosfilt(sos,Data1',2);%filter out ships noise
    Data1 = db2mag(6)*Data1*1e6;%convert to micropascals and adjust for group length effect (6 dB)
    Data1 = flip(Data1,1);%flip to closest reciever being first
    
    save(resultFile);%,'Data1')   
end