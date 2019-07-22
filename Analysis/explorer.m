clear all; clc;
fileID = fopen('../Lists/full.txt','w');
path = 'Z:\CSV\';
lines = dir(path)

for i = (1:length(lines))
    if(startsWith(lines(i).name,'Line','IgnoreCase',true))
        strcat(path,lines(i).name)
        line = dir(strcat(path,lines(i).name));
        for i=(1:length(line))
            if(startsWith(line(i).name,'Line','IgnoreCase',true))
                name = line(i).name;
                fprintf(fileID, name);
                fprintf(fileID, '\n');
            end
        end
    end
end

fclose(fileID);