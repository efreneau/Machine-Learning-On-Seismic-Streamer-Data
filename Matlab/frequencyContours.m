clear all; close all; clc;
%Create 3 CSV
%{
P190 = '..\P190\MGL1212NTMCS01.mat';
resultFile = '..\example_shots\shallow.csv';
dataFile = 'Z:\DATA\Line_AT\TAPE0106.REEL\R000179_1342879566.RAW';%shallow
createCSV(dataFile,P190,resultFile);

P190 = '..\P190\MGL1212MCS05.mat';
resultFile = '..\example_shots\deep.csv';
dataFile = 'Z:\DATA\Line_05\TAPE0028.REEL\R000028_1342408921.RAW';%deep
createCSV(dataFile,P190,resultFile);

P190 = '..\P190\MGL1212MCS07.mat';
resultFile = '..\example_shots\mid.csv';
dataFile = 'Z:\DATA\Line_07\TAPE0048.REEL\R000319_1342512128.RAW';%mid
createCSV(dataFile,P190,resultFile);
%}

%load files
[~,~,A] = xlsread('..\example_shots\shallow.csv');
[~,~,B] = xlsread('..\example_shots\mid.csv');
[~,~,C] = xlsread('..\example_shots\deep.csv');

x = cell2mat(A(2:637,42:69));
y = cell2mat(B(2:637,42:69));
z = cell2mat(C(2:637,42:69));

%x = flipud(x);
%y = flipud(y);
%z = flipud(z);

%load ranges
shallow_range = (cell2mat(A(2:637,11)).^2+cell2mat(A(2:637,12)).^2+cell2mat(A(2:637,13)).^2).^0.5;
mid_range = (cell2mat(B(2:637,11)).^2+cell2mat(B(2:637,12)).^2+cell2mat(B(2:637,13)).^2).^0.5;
deep_range = (cell2mat(C(2:637,11)).^2+cell2mat(C(2:637,12)).^2+cell2mat(C(2:637,13)).^2).^0.5;

%workaround since certain attributes in the csv's were not flipped when
%written.
shallow_range = flipud(shallow_range);
mid_range = flipud(mid_range);
deep_range = flipud(deep_range);

%Replace outliers defined by s stds from the median in a window of w
w = 20;%20
s = 4;%4
shallow_rms = hampel(x(:,1:13),w,s);
shallow_sel = hampel(x(:,15:27),w,s);
mid_rms = hampel(y(:,1:13),w,s);
mid_sel = hampel(y(:,15:27),w,s);
deep_rms = hampel(z(:,1:13),w,s);
deep_sel = hampel(z(:,15:27),w,s);

%Apply gaussian kernel to smooth
smooth = true;
if smooth
    u = -4:4;%4-4 originaly
    ker = exp(-(u.^2 + u'.^2)/2);
    ker = ker/sum(ker(:));

    shallow_rms = conv2(shallow_rms,ker,'same')';
    shallow_sel = conv2(shallow_sel,ker,'same')';
    mid_rms = conv2(mid_rms,ker,'same')';
    mid_sel = conv2(mid_sel,ker,'same')';
    deep_rms = conv2(deep_rms,ker,'same')';
    deep_sel = conv2(deep_sel,ker,'same')';
end

%Define ticks
xt = [1,100,200,300,400,500,600];
yt = [12.5,16,20,25,31.5,40,50,63,80,100,125,160,200];

%Create contours
layers = 20;

figure;
[C,h] = contourf(deep_sel,layers);
set(h,'LineColor','none')
cb = colorbar; 
title(cb,'dB rel. \muPa');
title('deep_sel', 'Interpreter', 'none');
xlabel('Range (m)');
ylabel('Frequency (Hz)');
xticks(xt);
xticklabels(roundn(deep_range(xt),2));%compute ranges rounded to the hundred
yticks((1:13));
yticklabels(yt);%band center frequencies

figure;
[C,h] = contourf(deep_rms,layers);
set(h,'LineColor','none')
cb = colorbar; 
title(cb,'dB rel. \muPa');
title('deep_rms', 'Interpreter', 'none');
xlabel('Range (m)');
ylabel('Frequency (Hz)');
xticks(xt);
xticklabels(roundn(deep_range(xt),2));
yticks((1:13));
yticklabels(yt);

figure;
[C,h] = contourf(mid_sel,layers);
set(h,'LineColor','none')
cb = colorbar; 
title(cb,'dB rel. \muPa');
title('mid_sel', 'Interpreter', 'none');
xlabel('Range (m)');
ylabel('Frequency (Hz)');
xticks(xt);
xticklabels(roundn(mid_range(xt),2));
yticks((1:13));
yticklabels(yt);

figure;
[C,h] = contourf(mid_rms,layers);
set(h,'LineColor','none')
cb = colorbar; 
title(cb,'dB rel. \muPa');
title('mid_rms', 'Interpreter', 'none');
xlabel('Range (m)');
ylabel('Frequency (Hz)');
xticks(xt);
xticklabels(roundn(mid_range(xt),2));
yticks((1:13));
yticklabels(yt);

figure;
[C,h] = contourf(shallow_sel,layers);
set(h,'LineColor','none')
cb = colorbar; 
title(cb,'dB rel. \muPa');
title('shallow_sel', 'Interpreter', 'none');
xlabel('Range (m)');
ylabel('Frequency (Hz)');
xticks(xt);
xticklabels(roundn(shallow_range(xt),2));
yticks((1:13));
yticklabels(yt);

figure;
[C,h] = contourf(shallow_rms,layers);
set(h,'LineColor','none')
cb = colorbar; 
title(cb,'dB rel. \muPa');
title('shallow_rms', 'Interpreter', 'none');
xlabel('Range (m)');
ylabel('Frequency (Hz)');
xticks(xt);
xticklabels(roundn(shallow_range(xt),2));
yticks((1:13));
yticklabels(yt);


