## Preprocessing Scripts##

#http://www.marine-geo.org/tools/search/entry.php?id=MGL1212

**main3.mat** Creates CSVs for each line. Point to each line directory, containing directories for each reel, which at the lowest level contain the RAW files.

**createCSV3_tape.mat** Creates CSVs for a whole reel.

**createCSV3.mat** Create CSV for a single RAW file.

**readP190.mat** This extracts navigation data from the P190 format. This is used to create the files in */P190/*.

**readMCS.mat** Interprets MAT format navigation files created from *readP190.mat*. Called by *createCSV3.mat*.

**readSegd.mat** Back end for reading SEG-D formatted raw files. Called by *createCSV3.mat*.

**GetReceiverDepth.mat** Computes depth at the receiver. Called by *createCSV3.mat*.
