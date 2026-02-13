close all; clear all; clc
mylist = daqlist;
myId = mylist.DeviceID;
myDaq = daq("ni");
myDaq.Rate = 2000;
ch = myDaq.addinput(myId, "ai0", "Voltage");
ch.TerminalConfig = "SingleEnded";
ch.Range = [-5 5];
disp("Start swinging now!")
tic 
while toc < 10
[data, time] = myDaq.read(seconds(3), "OutputFormat","Matrix");
mean(data)
pressure = (data - 2.2726) * 1250 / 4;
velocity = sqrt(2*abs(pressure) / 1.225);
plot(time, velocity)
end