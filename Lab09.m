close all; clear all; clc

mlist = daqlist;
mid = mlist.DeviceID;
mdaq = daq('ni');
mdaq.Rate = 1000;

ch = mdaq.addinput(mid, 'ai0', 'Voltage');
ch.Range = [-5 5];
ch.TerminalConfig = "SingleEnded";

s = "";
while true
    s = input("Hit enter to collect sample, 'q' and enter to quit:  ", "s");
    if s ~= ""
        break
    end
    [data, time ] = mdaq.read(seconds(2), "OutputFormat", "Matrix");
    data = mean(data);
    disp(string(data) + " Volts")
end
disp("Program stopped")