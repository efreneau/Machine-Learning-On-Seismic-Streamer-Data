%{
readP190('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Matlab\CSV\MGL1110MCS02.p190')
struct2vars(ans);
clear ans;
save('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\P190\MGL1110MCS02.mat')
clear all;
%}

readP190('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Matlab\CSV\MGL1110MCS03.p190')
struct2vars(ans);
clear ans;
save('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\P190\MGL1110MCS03.mat')
clear all;
readP190('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Matlab\CSV\MGL1110MCS04.p190')
struct2vars(ans);
clear ans;
save('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\P190\MGL1110MCS04.mat')
clear all;
readP190('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Matlab\CSV\MGL1110MCS05.p190')
struct2vars(ans);
clear ans;
save('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\P190\MGL1110MCS05.mat')
clear all;
readP190('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Matlab\CSV\MGL1110MCS06.p190')
struct2vars(ans);
clear ans;
save('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\P190\MGL1110MCS06.mat')
clear all;
readP190('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Matlab\CSV\MGL1110MCS07.p190')
struct2vars(ans);
clear ans;
save('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\P190\MGL1110MCS07.mat')
clear all;

function struct2vars(s)
%STRUCT2VARS Extract values from struct fields to workspace variables
    names = fieldnames(s);
    for i = 1:numel(names)
        assignin('caller', names{i}, s.(names{i}));
    end
end