close all; clear all; clc
mList = daqlist;
mId = mList.DeviceID;
mDaq = daq('ni');
mDaq.Rate = 20000;
ch1 = mDaq.addinput(mId, "ai0", "Voltage");
ch2 = mDaq.addinput(mId, "ai2", "Voltage");

tic
while toc < 30
    if toc < 10 
        r = 1;
    elseif toc < 15
        r = 10;
    else
        r = 20;
    end
    ch1.Range = [-r r] ;
    ch2.Range = [-r r];
    mDaq.Rate = 20000; % * (60 - toc)/60;
    [data, time] = mDaq.read(seconds(3), "OutputFormat","Matrix");
    plot(time, data(:,1), time, data(:,2))
    xlabel("Time (s)")
    ylabel("Voltage (V)")
    title("Dr Patterson's record from 4 decades ago")

    soundsc(data(:,2), 20000)
end