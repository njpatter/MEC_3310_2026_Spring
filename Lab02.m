close all; clear all; clc
mList = daqlist;
mId = mList.DeviceID;
mDaq = daq('ni');
mDaq.Rate = 20000;
mChannel = mDaq.addinput(mId,"ai0", "Voltage");
mChannel.Range = [-10 10];

[data, time] = mDaq.read(seconds(3), "OutputFormat","Matrix");
plot(time, data)
hold on
cutFreqs = [80, 40, 20, 10, 2];

for fc = cutFreqs
    % calculate important variables here
    T = 1/mDaq.Rate;
    wc = fc * 2 * pi;
    tau = 1 / wc;
    alpha = T / (tau + T);

    % iterate through data and apply filter
    y(1) = data(1);
    for i=2:length(data)
        y(i) = (1-alpha) * y(i-1) + alpha * data(i);
    end
    % plot filtered data and hold for more
    plot(time, y)
    hold on
end
xlabel("Time (s)")
ylabel("Voltage (V)")
title("Digital Filters Applied To DAQ Data")
legend(["OG Data" string(cutFreqs) + " Hz"])
% Here begins part B
% stairs(time, data)
% 
% smallestDelta = 10000;
% for i=2:length(data)
%     delta = abs(data(i) - data(i-1));
%     if (delta > 0)
%         smallestDelta = min(smallestDelta, delta);
%     end
% end
% numIncrements = 2 / smallestDelta