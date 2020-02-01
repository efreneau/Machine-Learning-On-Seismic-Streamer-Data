## Preprocessing Scripts ##

**Datasets**
http://www.marine-geo.org/tools/search/entry.php?id=MGL1212
http://www.marine-geo.org/tools/search/entry.php?id=MGL1110
http://www.marine-geo.org/tools/search/entry.php?id=MGL1903


**main.m** Creates CSVs for each line. Point to each line directory, containing directories for each reel, which at the lowest level contain the RAW files. UPDATE: MLM windows is chosen by the last argument. 9s is used for MGL1212, MGL1110 and 17s used for MGL1903.

**createCSV_tape.m** Creates CSVs for a whole reel/tape. Makes parallel calls to *createCSV.m*.

**createCSV.m** Create CSV for a single RAW file.

**readP190.m** This extracts navigation data from the P190 format. This is used to create the files in */P190/*.

**readMCS.m** Interprets MAT format navigation files created from *readP190.m*. Called by *createCSV.m*.

**readSegd.m** Back end for reading SEG-D formatted recordings (RAW files). Called by *createCSV.mat*.

**GetReceiverDepth.m** Computes depth at the receiver. Called by *createCSV.mat*.
