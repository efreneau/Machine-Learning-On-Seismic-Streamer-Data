function process_tape(path1,P190,csv_location,reverb_window,sel_window)
    if ispc %Choose path deliminator
        delim = '\';
    else
        delim = '/';
    end
    
    files = dir(path1);
    parfor i = (1:length(files))
        file = files(i).name;
        if(endsWith(file,'raw','IgnoreCase',true) && strcmp(file,'EOT.RAW')==0)
            location = strcat(path1,file);
            try
                process_shot(location,P190,csv_location,reverb_window,sel_window);
            catch er
                %rethrow(er)
                warning("It's likely that there is an out of bound shot number. File Ignored.");
            end
        end
    end
    try
        rmdir(strcat(csv_location,delim,'MatlabData'),'s'); %clean up mat files
    catch
        %This folder might be empty
    end
end
