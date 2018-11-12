clear; close all;
%% Initialization
snrDb = 0: 5: 25;
nTxRx = 2;
nChannels = 30;
nBits = 1e5;
pskNumber = 4;
berMaximumLikelihood = zeros(1, length(snrDb));
berZeroForcing = zeros(1, length(snrDb));
berMinimumMeanSquareError = zeros(1, length(snrDb));
%% Channel generation, transmission simulation and BER calculation 
for iSnrDb = snrDb
    snrDbIndex = find(snrDb == iSnrDb);
    iSnr = 10 .^ (iSnrDb / 10);
    % 2-by-2 mimo system
    channelMatrix = channel_matrix_generation(nTxRx, nChannels);
    [txStreamSplit, rxStreamSplit, nPairs] = qpsk_plain_system(iSnr, nTxRx, nChannels, nBits, channelMatrix);
    [berMaximumLikelihood(snrDbIndex)] = maximum_likelihood(iSnr, nTxRx, nChannels, nBits, nPairs, channelMatrix, txStreamSplit, rxStreamSplit);
    [berZeroForcing(snrDbIndex)] = zero_forcing(iSnr, nTxRx, nChannels, nBits, channelMatrix, txStreamSplit, rxStreamSplit);
    [berMinimumMeanSquareError(snrDbIndex)] = minimum_mean_square_error(iSnr, nTxRx, nChannels, nBits, channelMatrix, txStreamSplit, rxStreamSplit);
end
%% BER comparison
figure;
berMlCurve = semilogy(snrDb, berMaximumLikelihood, '-');
hold on;
berZfCurve = semilogy(snrDb, berZeroForcing, '--');
hold on;
berMmseCurve = semilogy(snrDb, berMinimumMeanSquareError, '-.');
title('Bit error rate of a 2-by-2 MIMO system with QPSK modulation');
xlabel('SNR (dB)');
ylabel('Bit Error Rate');
legend('Maximum Likelihood', 'Zero Forcing', 'Minimum Mean Square Error');
grid on;
