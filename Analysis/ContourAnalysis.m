clear all; close all; clc;

sel_contour('D:\CSV\Line_AT\Line_AT_TAPE0106.REEL_R000011_1342875702.csv','SEL(shallow1)');
sel_contour('D:\CSV\Line_AT\Line_AT_TAPE0106.REEL_R000045_1342876451.csv','SEL(shallow2)');
sel_contour('D:\CSV\Line_AT\Line_AT_TAPE0106.REEL_R000036_1342876254.csv','SEL(shallow3)');
sel_contour('D:\CSV\Line_AT\Line_AT_TAPE0106.REEL_R000179_1342879566.csv','SEL(shallow4)');
sel_contour('D:\CSV\Line_AT\Line_AT_TAPE0107.REEL_R000288_1342882139.csv','SEL(shallow5)');

sel_contour('D:\CSV\Line_07\Line_07_TAPE0048.REEL_R000319_1342512128.csv','SEL(mid1)');
sel_contour('D:\CSV\Line_07\Line_07_TAPE0048.REEL_R000326_1342512300.csv','SEL(mid2)');
sel_contour('D:\CSV\Line_07\Line_07_TAPE0048.REEL_R000326_1342512300.csv','SEL(mid3)');
sel_contour('D:\CSV\Line_07\Line_07_TAPE0048.REEL_R000315_1342512029.csv','SEL(mid4)');
sel_contour('D:\CSV\Line_07\Line_07_TAPE0048.REEL_R000376_1342513478.csv','SEL(mid5)');

sel_contour('D:\CSV\Line_05\Line_05_TAPE0028.REEL_R000028_1342408921.csv','SEL(deep1)');
sel_contour('D:\CSV\Line_05\Line_05_TAPE0028.REEL_R000006_1342408418.csv','SEL(deep2)');
sel_contour('D:\CSV\Line_05\Line_05_TAPE0027.REEL_R000288_1342407077.csv','SEL(deep3)');
sel_contour('D:\CSV\Line_05\Line_05_TAPE0032.REEL_R001163_1342434144.csv','SEL(deep4)');
sel_contour('D:\CSV\Line_05\Line_05_TAPE0032.REEL_R001095_1342432634.csv','SEL(deep5)');

function sel_contour(loc,title1)
    [~,~,data] = xlsread(loc);
    vals = cell2mat(data(2:637,42:69));
    range = (cell2mat(data(2:637,11)).^2+cell2mat(data(2:637,12)).^2+cell2mat(data(2:637,13)).^2).^0.5;
    range = flipud(range); %workaround
    
    sel = hampel(vals(:,15:27),20,4);
    
    u = -4:4;
    ker = exp(-(u.^2 + u'.^2)/2);
    ker = ker/sum(ker(:));
    
    sel = conv2(sel,ker,'same')';
    
    xt = [1,100,200,300,400,500,600];
    yt = [12.5,16,20,25,31.5,40,50,63,80,100,125,160,200];
    
    figure;
    [C,h] = contourf(sel,20);
    set(h,'LineColor','none')
    cb = colorbar; 
    title(cb,'dB rel. \muPa');
    title(title1, 'Interpreter', 'none');
    xlabel('Range (m)');
    ylabel('Frequency (Hz)');
    xticks(xt);
    xticklabels(roundn(range(xt),2));
    yticks((1:13));
    yticklabels(yt);
    
    style=hgexport('readstyle','paper');
    style.Format = 'png';
    hgexport(gcf, strcat('..\Figures\Contours\',title1,'.png'), style);
end