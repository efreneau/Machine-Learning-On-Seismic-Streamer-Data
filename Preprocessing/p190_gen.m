clear all;

process_p190('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\MGL1110\')

function process_p190(path)
    files = dir(path);
    for i = (1:length(files))
        file = files(i).name;
        if(endsWith(file,'p190','IgnoreCase',true))
            location = strcat(path,file);
            new_location = append(location(1:end-4),'mat');%remember to tweak number
            nav = readP190(location)
            save(new_location)
        end
    end
end

function struct2vars(s)
%STRUCT2VARS Extract values from struct fields to workspace variables
    names = fieldnames(s);
    for i = 1:numel(names)
        assignin('caller', names{i}, s.(names{i}));
    end
end