clear all; close all; clc

samplingFreq = 10000;

mlist = daqlist;
mId = mlist.DeviceID;
mDaq = daq('ni');
mDaq.Rate = samplingFreq;

ch = mDaq.addinput(mId, "ai0", "Voltage");
ch.Range = [-5 5];

[data, time] = mDaq.read(seconds(3), "OutputFormat","Matrix");
data = data - 2.5;

[f, P1] = BetterFFT(data, samplingFreq, true, 1.5);
notes = NoteRecognizer(f);

disp(f)
disp(notes)
plot(time, data)
figure 
plot(f, P1, 'o')