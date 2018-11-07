clear; close all;
%% Initialization
snrDb = 0: 5: 35;
nTxRx = 2;
nChannels = 2;
nBits = 1e6;
pskNumber = 4;
for iSnrDb = snrDb
    snrDbIndex = find(snrDb == iSnrDb);
    iSnr = 10 .^ (iSnrDb / 10);
    % signal in alamouti coding
    channelMatrix = channel_matrix_generation(nTxRx, nChannels);
    [txStreamSplit, rxStreamSplit, nPairs] = alamouti_system(iSnr, nTxRx, nChannels, nBits, channelMatrix);
    [berMaximumLikelihood, xMaximumLikelihood] = maximum_likelihood_alamouti(iSnr, nTxRx, nChannels, nBits, nPairs, channelMatrix, txStreamSplit, rxStreamSplit);
    flag = 1;
end
