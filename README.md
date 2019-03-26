## Machine Learning On Seismic Streamer Data ##

The goal of this project is to create a model, using machine learning, to quantify the noise produced during seismic reflection surveys done on the ocean. Factors such as airgun depth, hydrophone depth, range and properties of the ocean and ocean floor have bearing on how far noise travels and in what ways. We aim to be able to predict various measures of noise by analyzing these factors. This project uses data gathered from *R/V Marcus G. Langseth* on cruise *MGL1212* from July 12–24, 2012.

Project website: ​[https://github.com/efreneau/machinelearninguw](https://github.com/efreneau/machinelearninguw)

### Process ###
1. Extract sensor data, positions and system properties from the RAW and navigation files.
2. Perform signal processing tasks outlined in *Estimating shallow water sound power levels and mitigation
radii for the R/V Marcus G. Langseth using an 8 km long MCS
streamer*.
3. Compute RMS, SEL and the MLMs (Minimum Level Metrics) for various frequency bands. These are the measures we are trying to predict.
4. Create CSVs containing abridged results and system properties.
5. Import CSVs into Python.
2. Throw out bad data identified from the crew's logs and outliers detected in the remaining data.
6. Train and test model. We have experimented with linear regression, polynomial regression, spline regression and random forest to model RMS and SEL. We submited our results to The Journal of the Acoustical Society of America. We are currently working on models for the MLMs, which quantifies reverberations, and the different measures with respect to each frequency band.
7. Verify through simulation. We use arlpy for simulations, which is a python wrapper for BELLHOP.

### Files and Folders ###
**/:** Files in the root directory are current work, important results and figures.

**/CSV/:** All code dealing with preprocessing and creating CSVs. This code relies on parallelization to save time. CSV1 contains RMS, SEL and T90 results. CSV2 contains MLMs.

**/Lists/:** Contains a list of all of the csv files and the list of files I determined to bad from the crew's logs.

**/Matlab/:** Matlab code usually having to do with figure generation.

**/P190/:** Processed navigation files in .mat format.

**/Relevent Papers/:** Reference.

**/old/:** Old code kept in case the need arises.

### Resources ###
**Sound source localization technique using a seismic streamer
and its extension for whale localization during seismic surveys**([here](https://github.com/efreneau/machinelearninguw/blob/master/Relevant%20Papers/Abadi_et_al_2015.pdf)): Background

**Estimating the location of baleen whale calls
using dual streamers to support mitigation
procedures in seismic reflection surveys**([here](https://github.com/efreneau/machinelearninguw/blob/master/Relevant%20Papers/Abadi_et_al_2017.pdf)): Background

**Estimating shallow water sound power levels and mitigation
radii for the R/V Marcus G. Langseth using an 8 km long MCS
streamer**([here](https://github.com/efreneau/machinelearninguw/blob/master/Relevant%20Papers/Crone_et%20al_2014_Estimating%20shallow%20water%20sound%20power%20levels%20and%20mitigation.pdf)): Calculating RMS and SEL for a non-stationary process. Method used here.
