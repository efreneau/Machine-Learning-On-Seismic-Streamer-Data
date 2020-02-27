function createCSV_tape_no_MLM(path1,P190,csv_location)
    if ispc %Choose path deliminator
        delim = '\';
    else
        delim = '/';
    end
    
    files = dir(path1);
    for i = (1:length(files))
        file = files(i).name;
        if(endsWith(file,'raw','IgnoreCase',true) && strcmp(file,'EOT.RAW')==0)
            location = strcat(path1,file);
            try
                createCSV_no_MLM(location,P190,csv_location);
            catch er
                %rethrow(er)
                warning("It's likely that there is an out of bound shot number. File Ignored.");
            end
        end
        try
            rmdir(strcat(csv_location,delim,'MatlabData'),'s'); %clean up mat files
        catch
            %This folder might be empty
        end
    end
end
