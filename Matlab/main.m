clear all; close all; clc;

path1 ='C:\Users\zomege\Documents\Machine Learning\Matlab\Data\Line 06\Tape 73\';
P190 = 'C:\Users\zomege\Documents\Machine Learning\Matlab\P190\MGL1212MCS06.mat';
csv_location = 'C:\Users\zomege\Documents\Machine Learning\Matlab';
%{
for i=(1:length(reels))
    name = reels(i).name;
    path = reels(i).folder;
    disp(name)
    if(startsWith(name,'tape','IgnoreCase',true))
       cd path
%}
files = dir(path1);
for i=(1:length(files))
    file = files(i).name;
    if(endsWith(file,'raw','IgnoreCase',true))
        location = strcat(path1,file);
        createCSV(location,P190,csv_location)
    end
end
