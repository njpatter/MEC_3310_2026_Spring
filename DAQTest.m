close all;clear all; clc

daqlist;
mDaq = daq("ni") ;
mDaq.Rate = 10000;

mChannel = mDaq.addinput("Dev5", "ai0", "Voltage");
mChannel.Range = [-5 5];
mChannel.TerminalConfig = "Differential";

%mDaq.start("continuous");
pause(0.5)
 
rates = [1.5, 3, 2, 4, 40];

% for mRate = rates
%     mDaq.Rate = mRate;
%     [myNewData, time] = mDaq.read(seconds(2), "OutputFormat", "Matrix");
%     plot(time, myNewData)
%     hold on
% 
%     %xlim([0 2000])
%     %save("Lab02_MethodA_" + string(mRate) + "_HzSampling.mat")
% end
%     ylim([-5 5])
%     xlabel("Time (s)")
%     ylabel("Voltage (Differential)")
%     title("Sine Wave Samples at Various Frequencies")
%     legend(string(rates) + " Hz")

mChannel.Range = [-10 10];
mDaq.Rate = 20000;
amtOfTime = 3;

[myNewData, time] = mDaq.read(seconds(amtOfTime), "OutputFormat", "Matrix");
stairs(time, myNewData)    

T = 1/mDaq.Rate;
cutoffs = [80,40,20,10,2];

filteredData = [0];
for fc = cutoffs
    fc
    tau = 1/(2*pi*fc);
    alpha = T / (tau + T);
    for i = 2:length(myNewData)
        filteredData(i) = (1-alpha)*filteredData(i - 1) + alpha * myNewData(i);
    end
    plot(time, filteredData)
    hold on 
end

title("Digital Filters at Various Cutoff Freq")
xlabel("Time")
ylabel("Voltage")
legend(string(cutoffs) + " Hz")