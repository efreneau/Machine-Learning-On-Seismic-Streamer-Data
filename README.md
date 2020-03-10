## Machine Learning On Seismic Streamer Data ##

The goal of this project is to create a model, using machine learning, to quantify the noise produced during seismic reflection surveys done on the ocean. Factors such as airgun depth, hydrophone depth, range and properties of the ocean and ocean floor have bearing on how far noise travels and in what ways. We aim to be able to predict various measures of noise by analyzing these factors.

I use data gathered by *R/V Marcus G. Langseth* on cruises *MGL1212* (Washington), *MGL1110* and *MGL1903* (both in Alaska).

Project website: ​[https://github.com/efreneau/machinelearninguw](https://github.com/efreneau/machinelearninguw)

### Process ###
1. Extract sensor data, positions and system properties from the RAW and navigation files.
2. Perform signal processing tasks outlined in *Estimating shallow water sound power levels and mitigation
radii for the R/V Marcus G. Langseth using an 8 km long MCS
streamer*.
3. Compute RMS, SEL and the MLMs (Minimum Level Metrics) for 1/3-octave frequency bands. These are the measures we are trying to predict.
4. Throw out bad data identified from the crew's logs and outliers detected in the remaining data.
5. Create a database containing abridged results and system properties.
6. Train and test model. We have experimented with linear/polynomial/spline regression and random forest to model RMS and SEL.
7. Verify through simulation. We use arlpy for simulations, which is a python wrapper for BELLHOP.

### Files and Folders ###

**/:** Files in the root directory are current or important work.

**/Lists/:** Contains a list of all of the csv files and the list of files I determined to be bad from the crew's logs. CURRENTLY: only exists for MGL1212.

**/Analysis/:** Code usually having to do with further processing and figure generation.

**/Preprocessing/:** All code dealing with preprocessing. This code relies on parallelization toolbox in MATLAB.

**/Navigation_P190/:** Processed navigation files in the *.mat* format.

**/Relevant Papers/:** Reference.

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

**Quantifying seismic survey reverberation off the Alaskan North Slope**([here](https://github.com/efreneau/Machine-Learning-On-Seismic-Streamer-Data/blob/master/Relevant%20Papers/Guerra_Thode_et%20al_2011_read.pdf)): Process to compute MLMs discussed here.

### Publications ###

Abadi, S. H., & Freneau, E. (2019). Short-range propagation characteristics of airgun pulses during marine seismic reflection surveys.
The Journal of the Acoustical Society of America, 146(4), 2430–2442. https://doi.org/10.1121/1.5127843.

S. Abadi and E. Freneau, "Spectral Analysis of Airgun Pulses During Marine Seismic Reflection Surveys," OCEANS 2019 MTS/IEEE SEATTLE, Seattle, WA, USA, 2019, pp. 1-5. doi: 10.23919/OCEANS40490.2019.8962817.
