function createCSV_tape(path1,P190,csv_location)
    files = dir(path1);
    parfor i = (1:length(files))
        file = files(i).name;
        if(endsWith(file,'raw','IgnoreCase',true) && strcmp(file,'EOT.RAW')==0)
            location = strcat(path1,file);
            createCSV(location,P190,csv_location);
        end
    end
end
