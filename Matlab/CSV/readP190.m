function [nav] = readP190(filename)
%READP190 Read a Langseth post-processed p190 file.
%   [NAV] = READP190(FILENAME) reads the file given by FILENAME,
%   returning the navigation data in the P190 file in NAV.
%
%   Version 0.1
%   24 Sep 2012
%
%   Timothy Crone
%   tjcrone@gmail.com

% open file
fid = fopen(filename,'r');

% get shot offsets using fread
fseek(fid,0,1);
numBytes = ftell(fid);
fseek(fid,0,-1);
allChars = fread(fid,numBytes,'uint8=>char');
shotOffsets = strfind(allChars','VGL')-1;
if isempty(shotOffsets)
    shotOffsets = strfind(allChars','VMGL')-1;
end
if isempty(shotOffsets)
    shotOffsets = strfind(allChars','VL')-1;
end
groupsPerShotLoc = strfind(allChars','H1100');
groupsPerShot = str2double(allChars(groupsPerShotLoc+29: ...
    groupsPerShotLoc+35)');
numShots = length(shotOffsets);

% determine if file has CMGL lines
cmgl = 0;
if ~isempty(strfind(allChars','CMGL'))
    cmgl = 1;
end

% initialize output
nav.shotNumber = zeros(1,numShots);
nav.depth = zeros(1,numShots);
nav.vesselX = zeros(1,numShots);
nav.vesselY = zeros(1,numShots);
nav.sourceX = zeros(1,numShots);
nav.sourceY = zeros(1,numShots);
nav.tailX = zeros(1,numShots);
nav.tailY = zeros(1,numShots);
nav.receiverX = zeros(groupsPerShot,numShots);
nav.receiverY = zeros(groupsPerShot,numShots);

% read each shot
for i = 1:numShots
    % seek to next shot
    fseek(fid,shotOffsets(i),-1);
    
    % three first lines
    [nav.shotNumber(i), nav.vesselX(i), nav.vesselY(i), nav.depth(i)] = readHeaderLine(fid);
    [~, nav.sourceX(i), nav.sourceY(i)] = readHeaderLine(fid);
    if cmgl
        [~, ~, ~] = readHeaderLine(fid);
    end
    [~, nav.tailX(i), nav.tailY(i)] = readHeaderLine(fid);

    % read group lines
    k = 1;
    for j = 1:groupsPerShot/3
        [nav.receiverX(k:k+2,i), nav.receiverY(k:k+2,i)] = readGroupLine(fid);
        k = k+3;
    end
end

function [shotNumber, x, y, z] = readHeaderLine(fid)
% this function gets the x and y data from a non-group line

fseek(fid,19,0);
shotNumber = str2double(fread(fid,6,'uint8=>char')');
fseek(fid,21,0);
x = str2double(fread(fid,9,'uint8=>char')');
y = str2double(fread(fid,9,'uint8=>char')');
z = str2double(fread(fid,6,'uint8=>char')');
fseek(fid,11,0);

function [x, y] = readGroupLine(fid)
% this function gets the x and y data from a hydrophone group line

x = [0;0;0];
y = [0;0;0];
    
if strcmp('R0',fread(fid,2,'uint8=>char')')
    fseek(fid,3,0);
    for i = 1:3
        x(i) = str2double(fread(fid,9,'uint8=>char')');
        y(i) = str2double(fread(fid,9,'uint8=>char')');
        fseek(fid,8,0);
    end
    fseek(fid,-2,0);
else
    fseek(fid,79,0);
end
