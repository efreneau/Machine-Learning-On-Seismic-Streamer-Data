clear all; close all; clc;
hold on;
grid on;
grid minor;
%Header of csv: 'Date[0],Time[1],Depth of Airgun(m)[2],Depth of Reciever(m)[3],X Airgun[4],Y Airgun[5],Z Airgun[6],X_R1[7],Y_R1[8],Z_R1[9],SEL1[10],RMS1[11],SEL2[12],RMS2[13],SEL3[14],RMS3[15],SEL4[16],RMS4[17],SEL_full[18],RMS_full[19],T90_1[20],T90_2[21],T90_3[22],T90_4[23],T90_full[24]
%shallow
%[~,~,data_all] = xlsread('D:\Machine Learning\NewCSV\CSV1\Line_AT_(RMS_and_SEL)\Line_AT_TAPE0106.REEL_R000179_1342879566.csv');
%mid
%[~,~,data_all] = xlsread('D:\Machine Learning\NewCSV\CSV1\Line_07_(RMS_and_SEL)\Line_07_TAPE0048.REEL_R000319_1342512128.csv');
%deep
[~,~,data_all] = xlsread('D:\Machine Learning\NewCSV\CSV1\Line_05_(RMS_and_SEL)\Line_05_TAPE0028.REEL_R000028_1342408921.csv');

data_all = cell2mat(data_all(2:end,:));
data_all = hampel(data_all,15);

range = sqrt(data_all(:,8).^2+data_all(:,9).^2+data_all(:,10).^2);
T90 = data_all(:,21:end);
%plot(range,T90)
plot(range,T90(:,end),'k','LineWidth',1)
xlabel('Range (m)')
ylabel('T_9_0_ (sec)')
%legend('10-110 Hz','40-140 Hz','70-170 Hz','100-200 Hz','Full Band')
xlim([0,8000])
ylim([0,4])
figure;
hold on;
grid on;
grid minor;
%ax1 = subplot(2,1,1);
SEL = data_all(:,11:2:19);
%plot(range,SEL)
plot(range,SEL(:,end),'k','LineWidth',1)
xlabel('Range (m)')
ylabel('SEL')
ylim([120,200])
xlim([0,8000])
RMS = data_all(:,12:2:20);
%ax2 = subplot(2,1,2);
%plot(range,RMS)
%xlabel('Element #')
%ylabel('RMS')
%legend('10-110 Hz','40-140 Hz','70-170 Hz','100-200 Hz','Full Band')
%linkaxes([ax2,ax1],'xy'); 
