P190 = 'D:\Machine Learning\Matlab\P190\MGL1212MCS05.mat';
csv_location = 'D:\Machine Learning\Matlab\CSV2\Line_05_(MLM)\';
line = 'D:\Machine Learning\Matlab\Data\Line 05';


if ispc %Choose path deliminator
    delim = '\';
else
    delim = '/';
end

parpool

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV2_tape(path1,P190,csv_location)
    end
end
