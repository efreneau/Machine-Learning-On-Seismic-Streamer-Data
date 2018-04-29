function createCSV2_tape(path1,P190,csv_location)
    files = dir(path1);
    parfor i = (1:length(files))
        file = files(i).name;
        if(endsWith(file,'raw','IgnoreCase',true) && strcmp(file,'EOT.RAW')==0)
            location = strcat(path1,file);
            try
                createCSV2(location,P190,csv_location);
            catch
                warning('Out of bounds shot number. File Ignored.');
                delete(location)
            end
        end
    end
end