P190 = 'C:\Users\zomege\Documents\Machine Learning\Matlab\P190\MGL1212MCS06.mat';
csv_location = 'C:\Users\zomege\Documents\Machine Learning\Matlab';
line = 'C:\Users\zomege\Documents\Machine Learning\Matlab\Data\Line 06';
path1 = 'C:\Users\zomege\Documents\Machine Learning\Matlab\Data\Line 06\TAPE0076.REEL\';

if ispc %Choose path deliminator
    delim = '\';
else
    delim = '/';
end


tic
createCSV_tape(path1,P190,csv_location)
toc

%{
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape(path1,P190,csv_location)
    end
end
%}