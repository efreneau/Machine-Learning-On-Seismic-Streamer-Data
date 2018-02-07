clear all; close all; clc;
%readMCS('Data/Line 06/Tape 73/R001462_1342715827.RAW','P190/MGL1212NTMCS01.mat','results.mat');
%readMCS('Data/Line AT/R000179_1342879566.RAW','P190/MGL1212NTMCS01.mat','results.mat');
%createCSV('/home/zomege/Desktop/machinelearninguw-master/Matlab/Data/Line 06/Tape 73/R001462_1342715827.RAW','/home/zomege/Desktop/machinelearninguw-master/Matlab/P190/MGL1212MCS06.mat','/home/zomege/Desktop/machinelearninguw-master/Matlab/')
cd /home/zomege/Desktop/machinelearninguw-master/Matlab/Data/Line 06
P190 = '/home/zomege/Desktop/machinelearninguw-master/Matlab/P190/MGL1212MCS06.mat'
reels = dir;
for i=(1:length(reels))
    name = reels(i).name;
    path = reals(i).folder;
    if(startsWith(str,'tape','IgnoreCase',true))
       cd path
       files = dir
       for i=(1:length(line))
           file = files(i).name;
           if(endsWith(file,'raw','IgnoreCase',true))
           %Add code
           end
       end
    end
end