function createCSV_reel(path1,P190,csv_location)

maxNumCompThreads(512);

files = dir(path1);
for i=(1:length(files))
    file = files(i).name;
    if(endsWith(file,'raw','IgnoreCase',true))
        location = strcat(path1,file);
        createCSV(location,P190,csv_location)
    end
end
