function [header, traces] = readSegd(filename, verbose) %#ok<STOUT>
%READSEGD Read a Langseth SEG-D format RAW file.
%   [HEADER, TRACES] = READSEGD(FILENAME) reads the file given by FILENAME,
%   returning header information in HEADER and the trace data in TRACES.
%   This version currently does not read any information from the third
%   header block or any subsequent general header blocks. It currenly skips
%   any included extended header blocks and external header blocks which
%   are often present in Langseth RAW files. It currently skips any
%   included sample skew header blocks and general trailer blocks which are
%   not typically present in Langseth RAW files. Passing VERBOSE as a value
%   of unity makes the program print information regarding the read.
%   Otherwise the program is silent if the read was successful. If this
%   program fails to read your file or if you need additional information
%   from the headers, contact me and I will try to release another version
%   to address the issue.
%
%   Version 0.2
%   6 Nov 2012
%
%   Timothy Crone
%   tjcrone@gmail.com

% open file
fid = fopen(filename,'r','ieee-be');

% display message
if exist('verbose', 'var') && verbose==1
    fprintf('\nReading RAW file ...\n');
end

% read general header block #1
header.fileNumber = str2double(sprintf('%i%i%i%i',fread(fid,4,'ubit4=>uint8')));
if header.fileNumber==15151515
    header.fileNumber = 'FFFF';
end
header.formatCode = sprintf('%i%i%i%i',fread(fid,4,'ubit4=>uint8'));
if ~strcmp(header.formatCode,'8058')
    error('This version of readSegd only handles SEG-D files with format code 8058. The format code of this file is %s', header.formatCode);
end
fread(fid,12,'ubit4=>uint8'); % twelve digits 1-2, no meaning as far as I can tell
header.year = str2double(sprintf('20%i%i',fread(fid,2,'ubit4=>uint8')));
header.additionalHeaderBlocks = fread(fid,1,'ubit4=>uint8');
header.julianDay = str2double(sprintf('%i%i%i',fread(fid,3,'ubit4=>uint8')));
header.hour = str2double(sprintf('%i%i',fread(fid,2,'ubit4=>uint8')));
header.minute = str2double(sprintf('%i%i',fread(fid,2,'ubit4=>uint8')));
header.second = str2double(sprintf('%i%i',fread(fid,2,'ubit4=>uint8')));
header.manufacturerCode = sprintf('%i%i',fread(fid,2,'ubit4=>uint8'));
header.manufacturerSerialNumber = sprintf('%i%i%i%i',fread(fid,4,'ubit4=>uint8'));
header.bytesPerScan = str2double(sprintf('%i%i%i%i%i%i',fread(fid,6,'ubit4=>uint8')));
intervalList = [8 4 2 1 1/2 1/4 1/8 1/16];
header.baseScanInterval = intervalList(strfind(dec2bin(fread(fid,1,'uint8'),8),'1'));
header.polarityCode = dec2bin(fread(fid,1,'ubit4=>uint8'),4);
header.scansInBlockExponent = fread(fid,1,'ubit4=>uint8');
header.scansInBlockBase = fread(fid,1,'uint8');
header.recordTypeCode = dec2bin(fread(fid,1,'ubit4=>uint8'),4); % pretty sure there is a typo in spec version 1.0
header.recordLength = str2double(sprintf('%i%i.%i',fread(fid,3,'ubit4=>uint8')))*1.024;
if header.recordLength==1515.15*1.024
    header.recordLength = 'FFF';
end
header.scanTypesPerRecord = str2double(sprintf('%i%i',fread(fid,2,'ubit4=>uint8')));
if header.scanTypesPerRecord>1
    error('This version of readSegd only handles SEG-D files with a single scan type per record.');
end
header.channelSetsPerScanType = str2double(sprintf('%i%i',fread(fid,2,'ubit4=>uint8')));
if header.channelSetsPerScanType==1515
    header.channelSetsPerScanType = 'FF';
end
header.addedSkewFields = str2double(sprintf('%i%i',fread(fid,2,'ubit4=>uint8')));
header.extendedHeaderLength = str2double(sprintf('%i%i',fread(fid,2,'ubit4=>uint8')));
if header.extendedHeaderLength==1515
    header.extendedHeaderLength = 'FF';
end
header.externalHeaderLength = str2double(sprintf('%i%i',fread(fid,2,'ubit4=>uint8')));
if header.externalHeaderLength==1515
    header.externalHeaderLength = 'FF';
end

% read general header block #2
if strcmp(header.fileNumber,'FFFF')
    header.fileNumber = fread(fid,1,'ubit24=>uint32');
else
    fread(fid,1,'ubit24=>uint32');
end
if strcmp(header.channelSetsPerScanType,'FF')
    header.channelSetsPerScanType = fread(fid,1,'uint16');
else
    fread(fid,1,'uint16');
end
if strcmp(header.extendedHeaderLength,'FF')
    header.extendedHeaderLength = fread(fid,1,'uint16');
else
    fread(fid,1,'uint16');
end
if strcmp(header.externalHeaderLength,'FF')
    header.externalHeaderLength = fread(fid,1,'uint16');
else
    fread(fid,1,'uint16');
end
fseek(fid,1,0); % skip undefined
header.SEGDrevision = sprintf('%i.%i',fread(fid,2,'uint8'));
header.generalTrailers = fread(fid,1,'uint16');
if strcmp(header.recordLength,'FFF')
    header.recordLength = fread(fid,1,'ubit24=>uint32');
else
    fread(fid,1,'ubit24=>uint32');
end
fseek(fid,1,0); % skip undefined
generalHeaderBlockNumber = fread(fid,1,'uint8'); %#ok<NASGU>
fseek(fid,13,0); % skip undefined

% read additional general header blocks
if header.additionalHeaderBlocks-1 > 0
    fseek(fid,(header.additionalHeaderBlocks-1)*32,0); % skip for now
    if exist('verbose', 'var') && verbose==1
        fprintf('  *** Skipping %i additional general header block.\n',header.additionalHeaderBlocks-1);
    end
end

% read scan type header
for i = 1:header.channelSetsPerScanType
    fseek(fid,8,0); % skip for now
    eval(sprintf('header.channelSet%iChannels = str2double(sprintf(''%%i%%i%%i%%i'',fread(fid,4,''ubit4=>uint8'')));',i));
    fread(fid,22,'uint8'); % skip for now
end

% read skew headers
if header.addedSkewFields > 0
    fseek(fid,header.addedSkewFields*32,0); % skip for now
    if exist('verbose', 'var') && verbose==1
        fprintf('  *** Skipping %i added skew field blocks.\n',header.addedSkewFields);
    end
end

% read extended header
fseek(fid,header.extendedHeaderLength*32,0); % skip for now
if exist('verbose', 'var') && verbose==1
    fprintf('  *** Skipping %i extended header blocks.\n',header.extendedHeaderLength);
end


% read external header blocks
fseek(fid,header.externalHeaderLength*32,0); % skip for now
if exist('verbose', 'var') && verbose==1
    fprintf('  *** Skipping %i external header blocks.\n',header.externalHeaderLength);
end

for i = 1:header.channelSetsPerScanType
    % read first trace header (assuming the number of extension blocks is
    % the same for all traces)
    fseek(fid,9,0);
    traceHeaderExtensionBlocks = fread(fid,1,'uint8');
    fseek(fid,10,0); % skip stuff for now
    
    % read first set of trace header extension blocks
    for j = 1:traceHeaderExtensionBlocks
        fread(fid,7,'uint8'); % skip for now
        samplesPerTrace = fread(fid,1,'ubit24=>uint32');
        fread(fid,22,'uint8'); % skip for now
    end
    
    % store number of channels in channel set
    eval(sprintf('numChannels = header.channelSet%iChannels;',i));
    
    % initialize data
    data = zeros(samplesPerTrace,numChannels,'single');
    
    % read trace data
    for k = 1:numChannels
        data(:,k) = fread(fid,samplesPerTrace,'single');
        if k < numChannels
            fseek(fid,20+traceHeaderExtensionBlocks*32,0);
        end
    end
    
    % store data in traces
    eval(sprintf('traces.channelSet%i = data;',i));
end

% skip trailer blocks if any are included
pos = ftell(fid);
fseek(fid,0,1);
if ftell(fid)~=pos
    if exist('verbose', 'var') && verbose==1
        disp('  *** Skipping general trailer blocks.');
    end
end

% display message
if exist('verbose', 'var') && verbose==1
    fprintf('done.\n\n');
end

% close file
fclose(fid);
