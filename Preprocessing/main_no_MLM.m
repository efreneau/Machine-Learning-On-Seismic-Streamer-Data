if ispc %Choose path deliminator
    delim = '\';
else
    delim = '/';
end

%{
P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS01.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_01_no_MLM\';
line = 'E:\Cascadia\Line_01\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end

rmdir('C:\Users\zomege\Documents\Csv\Line_01_no_MLM\MatlabData','s')

%}

P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS02.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_02_no_MLM\';
line = 'E:\Cascadia\Line_02\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end

rmdir('C:\Users\zomege\Documents\Csv\Line_02_no_MLM\MatlabData','s')

P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS03.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_03_no_MLM\';
line = 'E:\Cascadia\Line_03\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end

rmdir('C:\Users\zomege\Documents\Csv\Line_03_no_MLM\MatlabData','s')

P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS04.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_04_no_MLM\';
line = 'E:\Cascadia\Line_04\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end

rmdir('C:\Users\zomege\Documents\Csv\Line_04_no_MLM\MatlabData','s')

P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS06.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_06_no_MLM\';
line = 'E:\Cascadia\Line_06\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end

rmdir('C:\Users\zomege\Documents\Csv\Line_06_no_MLM\MatlabData','s')

P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS07.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_07_no_MLM\';
line = 'E:\Cascadia\Line_07\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end

rmdir('C:\Users\zomege\Documents\Csv\Line_07_no_MLM\MatlabData','s')

P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS08.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_08_no_MLM\';
line = 'E:\Cascadia\Line_08\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end

rmdir('C:\Users\zomege\Documents\Csv\Line_08_no_MLM\MatlabData','s')

P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS09.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_09_no_MLM\';
line = 'E:\Cascadia\Line_09\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end

rmdir('C:\Users\zomege\Documents\Csv\Line_09_no_MLM\MatlabData','s')

P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS10.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_10_no_MLM\';
line = 'E:\Cascadia\Line_10\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end

rmdir('C:\Users\zomege\Documents\Csv\Line_10_no_MLM\MatlabData','s')

P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS11.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_11_no_MLM\';
line = 'E:\Cascadia\Line_11\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end

rmdir('C:\Users\zomege\Documents\Csv\Line_11_no_MLM\MatlabData','s')

P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212NTMCS01.mat';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_AT_no_MLM\';
line = 'E:\Cascadia\Line_AT\';

tapes = dir(line);
for i=(1:length(tapes))
    name = tapes(i).name;
    if(startsWith(name,'Tape','IgnoreCase',true))
       path1 = strcat(line,delim,name,delim);
       createCSV_tape_no_MLM(path1,P190,csv_location)
    end
end

rmdir('C:\Users\zomege\Documents\Csv\Line_AT_no_MLM\MatlabData','s')