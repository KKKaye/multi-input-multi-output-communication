clear; close all;
%% Initialization
snrDb = 0: 5: 35;
nTxRx = 2;
nChannels = 3;
nBits = 1e6;
pskNumber = 4;
for iSnrDb = snrDb
    snrDbIndex = find(snrDb == iSnrDb);
    iSnr = 10 .^ (iSnrDb / 10);
    % 2 * 2 mimo system
    channelMatrix = channel_matrix_generation(nTxRx, nChannels);
    [txStreamSplit, rxStreamSplit, nPairs] = qpsk_system(iSnr, nTxRx, nChannels, nBits, channelMatrix);
    [berMaximumLikelihood, xMaximumLikelihood] = maximum_likelihood(iSnr, nTxRx, nChannels, nBits, nPairs, channelMatrix, txStreamSplit, rxStreamSplit);
    [berZeroForcing, xZeroForcing] = zero_forcing(iSnr, nTxRx, nChannels, nBits, channelMatrix, txStreamSplit, rxStreamSplit);
    [berMinimumMeanSquareError, xMinimumMeanSquareError] = minimum_mean_square_error(iSnr, nTxRx, nChannels, nBits, channelMatrix, txStreamSplit, rxStreamSplit);
    flag = 1;
end
