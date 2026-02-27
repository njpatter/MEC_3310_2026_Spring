clear all; close all; clc

mylist = daqlist;
myId = mylist.DeviceID;
myDaq = daq('ni');
myDaq.Rate = 1000;


for i=0:1
    ch(i+1) = myDaq.addinput(myId, "ai"+string(i), "Voltage");
    ch(i+1).Range = [-5 5];
    ch(i+1).TerminalConfig = "SingleEnded";
end

s = input("Position in X-0g orientation and hit enter");
[data, time] = myDaq.read(seconds(6), "OutputFormat","Matrix");
avgVals = mean(data)
Xoffset = avgVals(1);
Ycombo = avgVals(2);

s = input("Position in X+1g orientation and hit enter");
[data, time] = myDaq.read(seconds(6), "OutputFormat","Matrix");
avgVals = mean(data)
Xcombo = avgVals(1);
Yoffset = avgVals(2);

sx = Xcombo - Xoffset;
sy = Ycombo - Yoffset;

myDaq.start("continuous")
pause(1)
tic
while toc < 30
    %seconds(3)
    pause(0.3)
    [data, time] = myDaq.read("all", "OutputFormat","Matrix");
    avgVals = mean(data);
    ax = (avgVals(1) -  Xoffset) / sx;
    ay = (avgVals(2) - Yoffset) / sy;
    atan2d(ax, ay)
end 
  
fprintf("Xoffset: %.9f, sx: %.9f, Yoffset %.9f, sy: %.9f\n",Xoffset,sx, Yoffset,sy)