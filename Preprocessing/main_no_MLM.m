%createCSV_no_MLM('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\deep.RAW','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS05.mat','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\deep_no_MLM.csv');

line_name = 'Line_01_no_MLM';
line_dir = 'C:\Users\zomege\Documents\Data\Line1\';
csv_location = 'C:\Users\zomege\Documents\Csv\Line_01_no_MLM\';
P190 = 'C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS01.mat';
process_line_no_MLM(line_dir,csv_location,P190,line_name)


