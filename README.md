## Machine Learning On Seismic Streamer Data ##

The goal is to create a model for noise given airgun depth, hydrophone depth and range during seismic reflection surveys. This project uses regression in Python training on **Line 06** and test using **Line 05** from the *R/V Marcus G. Langseth* on cruise *MGL1212* from July 12–24, 2012.

![](https://i.imgur.com/Xthvue9.png)

Project website: ​[https://github.com/efreneau/machinelearninguw](https://github.com/efreneau/machinelearninguw)

### Files ###

**Power Plot.ipynb:** Import data CSVs and plot part of the data. The data array is a 3D array of the form [shot]x[hydrophones]x[data]. 

Data is Depth of Airgun(m) [0] , Depth of Reciever(m) [1] , Range(m) [2] , SEL [3], RMS [4].

**main.m:** Main matlab file to calculate power levels and write to CSV.

**createCSV_tape.m:** Create CSVs for every raw data file in tape.

**createCSV.m:** Create a CSV file for the data file given the P190 navigation file.

**GetReceiverDepth.m:** Calculates reciever depth.

**readMCS.m:** Extract data from raw data file and P190 navigation file

**readP190.m:** Read a Langseth post-processed p190 file and create a matlab structure with this data.

**readSegd.m:** Read a Langseth SEG-D format RAW file.

### Usage ###

### Resources ###
