if ispc %Choose path deliminator
    delim = '\';
else
    delim = '/';
end

P190 = '..\..\P190\MGL1212MCS01.mat';
csv_location = 'Z:\CSV\Line_01\';
line = 'Z:\DATA\Line_01';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end

P190 = '..\..\P190\MGL1212MCS02.mat';
csv_location = 'Z:\CSV\Line_02\';
line = 'Z:\DATA\Line_02';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end

P190 = '..\..\P190\MGL1212MCS03.mat';
csv_location = 'Z:\CSV\Line_03\';
line = 'Z:\DATA\Line_03';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end

P190 = '..\..\P190\MGL1212MCS04.mat';
csv_location = 'Z:\CSV\Line_04\';
line = 'Z:\DATA\Line_04';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end

P190 = '..\..\P190\MGL1212MCS05.mat';
csv_location = 'Z:\CSV\Line_05\';
line = 'Z:\DATA\Line_05';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end

P190 = '..\..\P190\MGL1212MCS06.mat';
csv_location = 'Z:\CSV\Line_06\';
line = 'Z:\DATA\Line_06';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end

P190 = '..\..\P190\MGL1212MCS07.mat';
csv_location = 'Z:\CSV\Line_07\';
line = 'Z:\DATA\Line_07';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end

P190 = '..\..\P190\MGL1212MCS08.mat';
csv_location = 'Z:\CSV\Line_08\';
line = 'Z:\DATA\Line_08';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end

P190 = '..\..\P190\MGL1212MCS09.mat';
csv_location = 'Z:\CSV\Line_09\';
line = 'Z:\DATA\Line_09';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end

P190 = '..\..\P190\MGL1212MCS10.mat';
csv_location = 'Z:\CSV\Line_10\';
line = 'Z:\DATA\Line_10';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end

P190 = '..\..\P190\MGL1212MCS11.mat';
csv_location = 'Z:\CSV\Line_11\';
line = 'Z:\DATA\Line_11';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end

P190 = '..\..\P190\MGL1212NTMCS01.mat';
csv_location = 'Z:\CSV\Line_AT\';
line = 'Z:\DATA\Line_AT';
tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV3_tape(path1,P190,csv_location)
    end
end