%path1 = 'C:\Users\zomege\Documents\Machine Learning\Matlab\Data\Line 06\TAPE0076.REEL\';

P190 = 'D:\Machine Learning\Matlab\P190\MGL1212MCS05.mat';
csv_location = 'D:\Machine Learning\Matlab\Testing_Data_(Line_05)';
line = 'D:\Machine Learning\Matlab\Data\Line 05';


if ispc %Choose path deliminator
    delim = '\';
else
    delim = '/';
end

%tic
%createCSV2_tape(path1,P190,csv_location)
%toc

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV2_tape(path1,P190,csv_location)
    end
end
