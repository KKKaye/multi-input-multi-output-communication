clear; close all;
%% Initialization
snrDb = 0: 5: 35;
nTxRx = 2;
nChannels = 300;
nBits = 1e6;
pskNumber = 4;
for iSnrDb = snrDb
    snrDbIndex = find(snrDb == iSnrDb);
    iSnr = 10 .^ (iSnrDb / 10);
    % 2 * 2 mimo system
    channelMatrix = channel_matrix_generation(nTxRx, nChannels);
    flag = 1;
    [txStream, rxStream] = qpsk_data_generation(iSnr, nTxRx, nChannels, nBits, channelMatrix);
end
