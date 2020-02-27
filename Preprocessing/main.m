reverb_window = 9;%tune based on shot size

line_name = 'Line_01';
line_dir = 'C:\Users\zomege\Documents\Data\Line1\';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_01\';
P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS01.mat';
process_line(line_dir,csv_location,P190,line_name,reverb_window)