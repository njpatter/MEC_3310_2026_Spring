clear all; close all; clc

samplingFreq = 20000;

mlist = daqlist;
mId = mlist.DeviceID;
mDaq = daq('ni');
mDaq.Rate = samplingFreq;

ch = mDaq.addinput(mId, "ai0", "Voltage");
ch.TerminalConfig = "Differential";
ch.Range = [-5 5];

[data, time] = mDaq.read(seconds(6), "OutputFormat","Matrix");
data = data;

[f, P1] = BetterFFT(data, samplingFreq, true);
notes = NoteRecognizer(f);

disp(f)
disp(notes)
plot(time, data)
figure 
plot(f, P1, 'o')