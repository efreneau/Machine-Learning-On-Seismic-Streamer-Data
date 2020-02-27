function process_line(line_dir,csv_location,P190,line_name,reverb_window)
    if ispc %Choose path deliminator
        delim = '\';
    else
        delim = '/';
    end
    
    %scan through compressed files
    files = dir(line_dir);
    for i = (1:length(files))
        file = files(i).name;
        if(endsWith(file,'tar.gz','IgnoreCase',true))
            %unzip a tar.gz file
            tar_location = strcat(line_dir,file)
            temp_loc = strcat(line_dir,delim,'temp');
            temp = strcat(temp_loc,delim,line_name);
            untar(tar_location,temp);
            
            %scan through tapes
            tapes = dir(temp);
            for i=(1:length(tapes))
                name = tapes(i).name;
                if(startsWith(name,'Tape','IgnoreCase',true))
                   path1 = strcat(temp,delim,name,delim);
                   createCSV_tape(path1,P190,csv_location,reverb_window)
                end
            end
            
            rmdir(temp_loc,'s'); %clean up extracted files
        end
    end
end