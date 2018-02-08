path1 ='C:\Users\zomege\Documents\Machine Learning\Matlab\Data\Line 06\Tape 73\';
P190 = 'C:\Users\zomege\Documents\Machine Learning\Matlab\P190\MGL1212MCS06.mat';
csv_location = 'C:\Users\zomege\Documents\Machine Learning\Matlab';

tic
createCSV_reel(path1,P190,csv_location)
toc

%Tape 73 is 4.5 Gb and takes X to complete and writes 10 mb of output CSVs,
%therefore processing takes about gb/s
%
%
%
%{
line =;
reels = dir(line)
for i=(1:length(reels))
    name = reels(i).name;
    if(startsWith(name,'tape','IgnoreCase',true))
       path1 = strcat(line,name);
       createCSV_reel(path1,P190,csv_location)
%}