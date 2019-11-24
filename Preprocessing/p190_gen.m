clear all;
%{
nav = readP190('..\..\P190\MGL1110MCS02.p190')
save('..\..\P190\MGL1110MCS02.mat')


nav = readP190('..\..\P190\MGL1110MCS03.p190')
save('..\..\P190\MGL1110MCS03.mat')

nav = readP190('..\..\P190\MGL1110MCS04.p190')
save('..\..\P190\MGL1110MCS04.mat')

nav = readP190('..\..\P190\MGL1110MCS05.p190')
save('..\..\P190\MGL1110MCS05.mat')

nav = readP190('..\..\P190\MGL1110MCS06.p190')
save('..\..\P190\MGL1110MCS06.mat')

nav = readP190('..\..\P190\MGL1110MCS07.p190')
save('..\..\P190\MGL1110MCS07.mat')
%}

nav = readP190('C:\Users\zomege\Desktop\MGDS_Download\MGL1212\MGL1212MCS09A.p190')
save('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\MGL1212MCS09A.mat')
clear all;

nav = readP190('C:\Users\zomege\Desktop\MGDS_Download\MGL1212\MGL1212MCS09B.p190')
save('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\MGL1212MCS09B.mat')
clear all;

nav = readP190('C:\Users\zomege\Desktop\MGDS_Download\MGL1212\MGL1212MCS09C.p190')
save('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\MGL1212MCS09C.mat')
clear all;

function struct2vars(s)
%STRUCT2VARS Extract values from struct fields to workspace variables
    names = fieldnames(s);
    for i = 1:numel(names)
        assignin('caller', names{i}, s.(names{i}));
    end
end