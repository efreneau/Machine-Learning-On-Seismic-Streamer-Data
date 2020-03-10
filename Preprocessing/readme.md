## Preprocessing Scripts ##

**Datasets**
http://www.marine-geo.org/tools/search/entry.php?id=MGL1212
http://www.marine-geo.org/tools/search/entry.php?id=MGL1110
http://www.marine-geo.org/tools/search/entry.php?id=MGL1903


**main_XXXX.m and main_no_MLM_XXXX**
Processes data for whole lines. Point to each line directory, containing data tar.gz files as they are downloaded from MGDS. *main_no_MLM_XXXX* Only computes frequency dependent SEL and forgoes any windowing.

**process_tape.m**
Processes a whole reel/tape. Makes parallel calls to *process_shot.m*.

**process_shot.m**
Processes a single RAW file and outputs a single CSV file. The P190 argument should be a file location for the MATLAB formatted navigation files like those in */Navigation_P190/*. MLM window size is chosen by the last argument: 9s is used for MGL1212, MGL1110 and 17s used for MGL1903.

**readP190.m**
This extracts navigation data from the P190 format. This is used to create the files in */Navigation_P190/*.

**readMCS.m**
Interprets MAT format navigation files created from *readP190.m*. Called by *process_shot.m*.

**readSegd.m**
Back end for reading SEG-D formatted recordings (RAW files). Called by *process_shot.m*.

**GetReceiverDepth.m**
Computes depth at the receiver. Called by *process_shot.m*.
