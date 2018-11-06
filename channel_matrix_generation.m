function [channelMatrix] = channel_matrix_generation(n, nChannels)
channelMatrix = cell(nChannels, 1);
variance = 1;
for iChannel = 1: nChannels
    channelMatrix{iChannel} = sqrt(variance / 2) * (randn(n) + 1i * randn(n));
end
end
