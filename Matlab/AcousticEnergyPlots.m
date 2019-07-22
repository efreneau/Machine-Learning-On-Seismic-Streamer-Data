clear all; close all; clc;
[~,~,A] = xlsread('..\example_shots\shallow.csv');
[~,~,B] = xlsread('..\example_shots\mid.csv');
[~,~,C] = xlsread('..\example_shots\deep.csv');

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

%Compute log R
log_shallow_range = log10(shallow_range);
log_mid_range = log10(mid_range);
log_deep_range = log10(deep_range);

%MMSE fit of log R using a grid search
%c_finder(rms_shallow,log_shallow_range)

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

function C = c_finder(target,base)%MMSE solution for C in target = C*base
    grid = (-100:0.1:100);
    MSE = zeros(1,size(grid,1));
    i = 1;
    for c = grid
        MSE(i) = mean((c*base-target).^2)
        i = i + 1;
    end
    [~,I] = min(MSE);
    C = grid(I);
end





