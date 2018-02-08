%path1 ='C:\Users\zomege\Documents\Machine Learning\Matlab\Data\Line 06\Tape 73\';
P190 = 'C:\Users\zomege\Documents\Machine Learning\Matlab\P190\MGL1212MCS06.mat';
csv_location = 'C:\Users\zomege\Documents\Machine Learning\Matlab';
if ispc %Choose path deliminator
    delim = '\';
else
    delim = '/';
end
%tic
%createCSV_reel(path1,P190,csv_location)
%toc

%Tape 73 is 4.5 Gb and takes 25 minutes to complete and writes 10 mb of output CSVs,
%therefore processing takes about 0.2 gb/min
%
%100 Gb will take 8 hours.
%

line = 'C:\Users\zomege\Documents\Machine Learning\Matlab\Data\Line 06';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape(path1,P190,csv_location)
    end
end