clear all; close all; clc;
%dataFile = 'R000179_1342879566.RAW';
%P190 = 'MGL1212NTMCS01.mat';
%readMCS(strcat('Data/Line AT/',dataFile),strcat('P190/',P190),'Results.mat');
%createCSV('R000179_1342879566.RAW','MGL1212NTMCS01.mat')

%createCSV('C:\Users\zomege\Desktop\Machine Learning\Matlab\Data\Line AT\R000179_1342879566.RAW','C:\Users\zomege\Desktop\Machine Learning\Matlab\P190\MGL1212NTMCS01.mat')
%createCSV('C:\Users\zomege\Desktop\Machine Learning\Matlab\Data\Line 06\Tape 73\R001462_1342715827.RAW','C:\Users\zomege\Desktop\Machine Learning\Matlab\P190\MGL1212NTMCS01.mat')
%Line 06\Tape 73\R001462_1342715827.RAW error
%Line 06\Tape 73\R001467_1342715934.RAW error
%Line 06\Tape 74\R001682_1342721117.RAW error
readMCS('Data\Line 06\Tape 73\R001462_1342715827.RAW','P190\MGL1212NTMCS01.mat','results.mat');