if ispc %Choose path deliminator
    delim = '\';
else
    delim = '/';
end

P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS05.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_05\';
line = 'C:\Users\zomege\Documents\Data\Line_05\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end