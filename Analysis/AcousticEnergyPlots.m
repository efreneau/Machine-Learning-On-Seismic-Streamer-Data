clear all; close all; clc;
[~,~,A] = xlsread('..\Example_Shots\shallow.csv');
[~,~,B] = xlsread('..\Example_Shots\mid.csv');
[~,~,C] = xlsread('..\Example_Shots\deep.csv');

%Replace outliers defined by s stds from the median in a window of w
w = 20;
s = 4;

rms_shallow = hampel(cell2mat(A(2:637,55)),w,s);
rms_mid = hampel(cell2mat(B(2:637,55)),w,s);
rms_deep = hampel(cell2mat(C(2:637,55)),w,s);

sel_shallow = hampel(cell2mat(A(2:637,69)),w,s);
sel_mid = hampel(cell2mat(B(2:637,69)),w,s);
sel_deep = hampel(cell2mat(C(2:637,69)),w,s);

%load ranges
shallow_range = (cell2mat(A(2:637,11)).^2+cell2mat(A(2:637,12)).^2+cell2mat(A(2:637,13)).^2).^0.5;
mid_range = (cell2mat(B(2:637,11)).^2+cell2mat(B(2:637,12)).^2+cell2mat(B(2:637,13)).^2).^0.5;
deep_range = (cell2mat(C(2:637,11)).^2+cell2mat(C(2:637,12)).^2+cell2mat(C(2:637,13)).^2).^0.5;

%workaround since certain attributes in the csv's were not flipped when
%written.
shallow_range = flipud(shallow_range);
mid_range = flipud(mid_range);
deep_range = flipud(deep_range);

%Plots
figure; hold on; grid on;%4c
plot(shallow_range,sel_shallow,'r');
plot(shallow_range,rms_shallow,'k');
legend('SEL','SPL_rms','Interpreter','none');
title('acoustic energy level in shallow water (dB)');

figure; hold on; grid on;%5c
plot(mid_range,sel_mid,'r');
plot(mid_range,rms_mid,'k');
legend('SEL','SPL_rms','Interpreter','none');
title('acoustic energy level in mid water (dB)');

figure; hold on; grid on;%6c
plot(deep_range,sel_deep,'r');
plot(deep_range,rms_deep,'k');
legend('SEL','SPL_rms','Interpreter','none');
title('acoustic energy level in deep (dB)');

disp('Shallow RMS')
model_loglinear(rms_shallow,shallow_range);

disp('Shallow SEL')
[a,b] = model_loglinear(sel_shallow,shallow_range);
figure; hold on;
scatter(shallow_range,sel_shallow,10,'filled','k');
plot(shallow_range,a*log10(shallow_range)+b,'LineWidth',1,'Color','r');
xlabel('Range (m)');
ylabel('SEL (dB)');
title('Shallow SEL');

disp('Mid RMS')
model_loglinear(rms_mid,mid_range);

disp('Mid SEL')
[a,b] = model_loglinear(sel_mid,mid_range);
figure; hold on;
scatter(mid_range,sel_mid,10,'filled','k');
plot(mid_range,a*log10(mid_range)+b,'LineWidth',1,'Color','r');
xlabel('Range (m)');
ylabel('SEL (dB)');
title('Mid SEL');

disp('Deep RMS')
model_loglinear(rms_deep,deep_range);

disp('Deep SEL')
model_loglinear(sel_deep,deep_range);
figure; hold on;
scatter(deep_range,sel_deep,10,'filled','k');
plot(deep_range,a*log10(deep_range)+b,'LineWidth',1,'Color','r');
xlabel('Range (m)');
ylabel('SEL (dB)');
title('Deep SEL');

disp('===============')
disp('Shallow RMS')
model_compound(rms_shallow,shallow_range);
disp('Shallow SEL')
model_compound(sel_shallow,shallow_range);
disp('Mid RMS')
model_compound(rms_mid,mid_range);
disp('Mid SEL')
model_compound(sel_mid,mid_range);
disp('Deep RMS')
model_compound(rms_deep,deep_range);
disp('Deep SEL')
model_compound(sel_deep,deep_range);

function [a,b] = model_loglinear(target,range)%constrained optimization solution for [a,b] in target = a*log10(R)+b
    options = optimset('display','off');
    f = @(x) norm(x(1)*log10(range)+x(2)-target,2);
    x = fmincon(f,[0,150],eye(2),[20,200],[],[],[],[],[],options);
    a = x(1); b = x(2);
    disp(strcat(num2str(a),'*Log10(R)+',num2str(b)))
end

function [a,b,c] = model_compound(target,range)%constrained optimization solution for [a,b,c] in target = a*log10(R)+b*R+c
    options = optimset('display','off');
    f = @(x) norm(x(1)*log10(range)+x(2)*range+x(3)-target,2);
    x = fmincon(f,[1,1,150],eye(3),[20,20,200],[],[],[],[],[],options);
    a = x(1); b = x(2); c = x(3);
    disp(strcat(num2str(a),'*Log10(R)+',num2str(b),'*R+',num2str(c)))
end

