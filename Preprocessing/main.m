if ispc %Choose path deliminator
    delim = '\';
else
    delim = '/';
end

reverb_window = 9;%tune based on shot size

P190 = '..\..\P190\MGL1212MCS01.mat';
csv_location = 'Z:\CSV\Line_01\';
line = 'Z:\DATA\Line_01';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape(path1,P190,csv_location,reverb_window)
    end
end