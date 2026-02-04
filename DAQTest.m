close all;clear all; clc

daqlist;
mDaq = daq("ni") ;
mDaq.Rate = 10000;

mChannel = mDaq.addinput("Dev4", "ai0", "Voltage");
mChannel.Range = [-5 5];
mChannel.TerminalConfig = "SingleEnded";

mDaq.start("continuous");
pause(0.5)
tic 
while toc < 60
    myNewData = mDaq.read("all", "OutputFormat", "Matrix");
    plot(myNewData)
    ylim([0 5])
    xlim([0 2000])
    pause(0.1)
end