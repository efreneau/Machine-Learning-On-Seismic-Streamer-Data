## Machine Learning On Seismic Streamer Data ##

The goal is to create a model for noise given airgun depth, hydrophone depth and range during seismic reflection surveys. This project uses regression in Python training on **Line 06** and test using **Line 05** from the *R/V Marcus G. Langseth* on cruise *MGL1212* from July 12–24, 2012.

![](https://i.imgur.com/Xthvue9.png)

Project website: ​[https://github.com/efreneau/machinelearninguw](https://github.com/efreneau/machinelearninguw)

### Files ###

**Power Plot.ipynb:** Import data CSVs and plot part of the data. The data array is a 3D array of the form [shot]x[hydrophones]x[data]. 

Data is Depth of Airgun(m) [0] , Depth of Reciever(m) [1] , Range(m) [2] , SEL [3], RMS [4].

**Matlab/main.m:** Main matlab file to calculate power levels and write to CSV.

**Matlab/createCSV_tape.m:** Create CSVs for every raw data file in tape.

**Matlab/createCSV.m:** Create a CSV file for the data file given the P190 navigation file.

**Matlab/GetReceiverDepth.m:** Calculates reciever depth.

**Matlab/readMCS.m:** Extract data from raw data file and P190 navigation file

**Matlab/readP190.m:** Read a Langseth post-processed p190 file and create a matlab structure with this data.

**Matlab/readSegd.m:** Read a Langseth SEG-D format RAW file.

### Usage ###

### Resources ###

**Sound source localization technique using a seismic streamer
and its extension for whale localization during seismic surveys**([here](https://github.com/efreneau/machinelearninguw/blob/master/Relevant%20Papers/Abadi_et_al_2015.pdf)): Background

**Estimating the location of baleen whale calls
using dual streamers to support mitigation
procedures in seismic reflection surveys**([here](https://github.com/efreneau/machinelearninguw/blob/master/Relevant%20Papers/Abadi_et_al_2017.pdf)): Background

**Estimating shallow water sound power levels and mitigation
radii for the R/V Marcus G. Langseth using an 8 km long MCS
streamer**([here](https://github.com/efreneau/machinelearninguw/blob/master/Relevant%20Papers/Crone_et%20al_2014_Estimating%20shallow%20water%20sound%20power%20levels%20and%20mitigation.pdf)): Calculating RMS and SEL for a non-stationary process. Method used here.
