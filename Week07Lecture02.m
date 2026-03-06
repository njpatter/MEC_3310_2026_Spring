clear all; close all; clc

%recFs = 8000;
%recObj = audiorecorder(recFs, 8, 1, 1);

[songData, songFs] = audioread("Dont Stop.mp3");
sound(songData, songFs)
%record(recObj);

tic
delay = 0.15;
pause(delay + 0.5);
while toc < 300
    %micData = getaudiodata(recObj);
    %micData = micData(end - recFs * delay : end);
    %[f, a] = BetterFFT(micData, recFs);


    currentTime = toc;
    iIndex = int32((currentTime - delay) * songFs);
    fIndex = int32((currentTime) * songFs);
    if fIndex > length(songData)
        break
    end
    [fSong, aSong] = BetterFFT(songData(iIndex:fIndex, 1), songFs);

    subInd = fSong < 1200;
    fSong = fSong(subInd);
    aSong = aSong(subInd);

    plot(fSong, aSong) %, f, a)
    xlim([0 1200])
    ylim([0 0.15])

    pause(delay);
end