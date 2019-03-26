P190 = 'D:\Machine Learning\Matlab\P190\MGL1212MCS11.mat';
csv_location = 'D:\Machine Learning\Matlab\CSV1\Line_11_(RMS_and_SEL)\';%Testing_Data_(Line_05)
%line = 'Y:\line4';
%line = 'D:\Machine Learning\Matlab\Data\Line 06';
line = 'Y:\machinelearninguw-master\Matlab\Data\Line 11';

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
       createCSV_tape(path1,P190,csv_location)
    end
end

