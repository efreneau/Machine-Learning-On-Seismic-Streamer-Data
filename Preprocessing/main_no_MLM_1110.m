%createCSV_no_MLM('C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\deep.RAW','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\Navigation_P190\Cascadia\MGL1212MCS05.mat','C:\Users\zomege\Documents\GitHub\Machine-Learning-On-Seismic-Streamer-Data\example_shots\deep_no_MLM.csv');

line_name = 'Line_01a_no_MLM';
line_dir = '/media/efreneau/a5c4b484-7df9-4b8d-940e-b5d31c6c9963/DATA/MGL1110/Line_01a/';
csv_location = '/media/efreneau/a5c4b484-7df9-4b8d-940e-b5d31c6c9963/CSV/Line_01a_no_MLM/';
P190 = '/home/efreneau/Downloads/Machine-Learning-On-Seismic-Streamer-Data-master/Navigation_P190/MGL1110/MGL1110MCS01A.mat';
process_line_no_MLM(line_dir,csv_location,P190,line_name)

line_name = 'Line_01b_no_MLM';
line_dir = '/media/efreneau/a5c4b484-7df9-4b8d-940e-b5d31c6c9963/DATA/MGL1110/Line_01b/';
csv_location = '/media/efreneau/a5c4b484-7df9-4b8d-940e-b5d31c6c9963/CSV/Line_01b_no_MLM/';
P190 = '/home/efreneau/Downloads/Machine-Learning-On-Seismic-Streamer-Data-master/Navigation_P190/MGL1110/MGL1110MCS01B.mat';
process_line_no_MLM(line_dir,csv_location,P190,line_name)

line_name = 'Line_05b_no_MLM';
line_dir = '/media/efreneau/a5c4b484-7df9-4b8d-940e-b5d31c6c9963/DATA/MGL1110/Line_05b/';
csv_location = '/media/efreneau/a5c4b484-7df9-4b8d-940e-b5d31c6c9963/CSV/Line_05b_no_MLM/';
P190 = '/home/efreneau/Downloads/Machine-Learning-On-Seismic-Streamer-Data-master/Navigation_P190/MGL1110/MGL1110MCS05B.mat';
process_line_no_MLM(line_dir,csv_location,P190,line_name)