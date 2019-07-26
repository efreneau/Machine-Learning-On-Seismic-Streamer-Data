clear all; close all; clc;

style=hgexport('readstyle','paper');
style.Format = 'tiff';
 
[~,~,A] = xlsread('..\Example_Shots\shallow.csv');
[~,~,B] = xlsread('..\Example_Shots\mid.csv');
[~,~,C] = xlsread('..\Example_Shots\deep.csv');
%[~,~,D] = xlsread('..\Example_Shots\shallow4.csv');

%Experiment: Several SEL models from shallow water (all from line AT)
%-4.6722*Log10(R)+-0.0021123*R+191.0778,    R000179_1342879566 (old shallow.csv)
%-9.7139*Log10(R)+-0.00098267*R+205.2843,   R000011_1342875702 (shallow.csv)
%-20.257*Log10(R)+0.00040106*R+234.468,     R000095_1342877588
%-24.4373*Log10(R)+0.0014306*R+244.322,     R000078_1342877193
%The old shallow shot used was found to be unrepresentative and replaced.

%Replace outliers defined by s stds from the median in a window of w
w = 20;
s = 4;

rms_shallow = hampel(cell2mat(A(2:637,55)),w,s);
rms_mid = hampel(cell2mat(B(2:637,55)),w,s);
rms_deep = hampel(cell2mat(C(2:637,55)),w,s);
%rms_shallow2 = hampel(cell2mat(D(2:637,55)),w,s);

sel_shallow = hampel(cell2mat(A(2:637,69)),w,s);
sel_mid = hampel(cell2mat(B(2:637,69)),w,s);
sel_deep = hampel(cell2mat(C(2:637,69)),w,s);
%sel_shallow2 = hampel(cell2mat(D(2:637,69)),w,s);

%load ranges
shallow_range = (cell2mat(A(2:637,11)).^2+cell2mat(A(2:637,12)).^2+cell2mat(A(2:637,13)).^2).^0.5;
mid_range = (cell2mat(B(2:637,11)).^2+cell2mat(B(2:637,12)).^2+cell2mat(B(2:637,13)).^2).^0.5;
deep_range = (cell2mat(C(2:637,11)).^2+cell2mat(C(2:637,12)).^2+cell2mat(C(2:637,13)).^2).^0.5;
%shallow_range2 = (cell2mat(D(2:637,11)).^2+cell2mat(D(2:637,12)).^2+cell2mat(D(2:637,13)).^2).^0.5;

%workaround since certain attributes in the csv's were not flipped when
%written.
shallow_range = flipud(shallow_range);
mid_range = flipud(mid_range);
deep_range = flipud(deep_range);
%shallow_range2 = flipud(shallow_range2);

%Plots
figure; hold on; grid on;%4c
plot(shallow_range,sel_shallow,'r');
plot(shallow_range,rms_shallow,'k');
legend('SEL','SPL_rms','Interpreter','none');
title('Acoustic Energy Level in Shallow Water (dB)');
ylim([150,195]);

hgexport(gcf, '..\Figures\sel_rms_vs_range_(shallow).tiff', style);

figure; hold on; grid on;%5c
plot(mid_range,sel_mid,'r');
plot(mid_range,rms_mid,'k');
legend('SEL','SPL_rms','Interpreter','none');
title('Acoustic Energy Level in Intermediate Water (dB)');
ylim([150,195]);

hgexport(gcf, '..\Figures\sel_rms_vs_range_(mid).tiff', style);

figure; hold on; grid on;%6c
plot(deep_range,sel_deep,'r');
plot(deep_range,rms_deep,'k');
legend('SEL','SPL_rms','Interpreter','none');
title('Acoustic Energy Level in Deep Water (dB)');
ylim([150,195]);

hgexport(gcf, '..\Figures\sel_rms_vs_range_(deep).tiff', style);

disp('Shallow RMS')
model_compound(rms_shallow,shallow_range);

disp('Shallow SEL')
[a,b,c] = model_compound(sel_shallow,shallow_range);
figure; hold on;
scatter(shallow_range,sel_shallow,10,'filled','k');
plot(shallow_range,a*log10(shallow_range)+b*shallow_range+c,'LineWidth',1,'Color','r');
xlabel('Range (m)');
ylabel('SEL (dB)');
title('SEL vs Range (Shallow)');
ylim([150,185]);

hgexport(gcf, '..\Figures\sel_vs_range_w_fit_(shallow).tiff', style);

disp('Intermediate RMS')
model_compound(rms_mid,mid_range);

disp('Intermediate SEL')
[a,b,c] = model_compound(sel_mid,mid_range);
figure; hold on;
scatter(mid_range,sel_mid,10,'filled','k');
plot(mid_range,a*log10(mid_range)+b*mid_range+c,'LineWidth',1,'Color','r');
xlabel('Range (m)');
ylabel('SEL (dB)');
title('SEL vs Range (Intermediate)');
ylim([150,185]);

hgexport(gcf, '..\Figures\sel_vs_range_w_fit_(mid).tiff', style);

disp('Deep RMS')
model_compound(rms_deep,deep_range);

disp('Deep SEL')
[a,b,c] = model_compound(sel_deep,deep_range);
figure; hold on;
scatter(deep_range,sel_deep,10,'filled','k');
plot(deep_range,a*log10(deep_range)+b*deep_range+c,'LineWidth',1,'Color','r');
xlabel('Range (m)');
ylabel('SEL (dB)');
title('SEL vs Range (Deep)');
ylim([150,185]);

hgexport(gcf, '..\Figures\sel_vs_range_w_fit_(deep).tiff', style);

function [a,b,c] = model_compound(target,range)%constrained optimization solution for [a,b,c] in target = a*log10(R)+b*R+c
    options = optimset('display','off');
    f = @(x) norm(x(1)*log10(range)+x(2)*range+x(3)-target,2);
    x = fmincon(f,[1,5,150],eye(3),[20,20,300],[],[],[],[],[],options);
    a = x(1); b = x(2); c = x(3);
    disp(strcat(num2str(a),'*Log10(R)+',num2str(b),'*R+',num2str(c)))
end

