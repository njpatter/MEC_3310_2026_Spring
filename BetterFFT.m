function [frequencies,amplitudes] = BetterFFT(data, samplingFreq, shouldSort, threshold)
    if nargin < 3
        shouldSort = false;
    end
    if nargin < 4
        threshold = -1000000000;
    end
    
    L = length(data);
    Y = fft(data);
    P2 = abs(Y/L);
    amplitudes = P2(1:int32(L/2) + 1);
    amplitudes(2:end-1) = 2*amplitudes(2:end-1);
    frequencies = samplingFreq / L * (0:int32(L/2));

    if shouldSort 
        [sortedAmps, indices] = sort(amplitudes, 'descend');
        sortedFreqs = frequencies(indices);
        frequencies = sortedFreqs;
        amplitudes = sortedAmps;
    end

    indicies = amplitudes > threshold;
    frequencies = frequencies(indicies);
    amplitudes = amplitudes(indicies);
end