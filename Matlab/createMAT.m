%createMAT1('Z:\DATA\Line_AT\TAPE0106.REEL\R000179_1342879566.RAW','D:\Machine Learning\Matlab\P190\MGL1212NTMCS01.mat','D:\Machine Learning\out\shallow.mat')
%createMAT1('Z:\DATA\Line_05\TAPE0028.REEL\R000028_1342408921.RAW','D:\Machine Learning\Matlab\P190\MGL1212MCS05.mat','D:\Machine Learning\out\deep.mat')
%createMAT1('Z:\DATA\Line_07\TAPE0048.REEL\R000319_1342512128.RAW','D:\Machine Learning\Matlab\P190\MGL1212MCS07.mat','D:\Machine Learning\out\mid.mat')

function createMAT(dataFile,P190,resultFile)
    readMCS(dataFile,P190,'temp.mat');
    load('temp.mat');
    fs = 500;

    sos=[1,-2,1,1,-1.82570619168342,0.881881926844246;1,-2,1,1,-1.65627993129105,0.707242535896459;1,-2,1,1,-1.57205200320457,0.620422971870477];
    Data1 = sosfilt(sos,Data1',2);%filter

    %Data2 = flip(Data1(:,1:10*fs));%window
    save(resultFile,'Data1')   
end