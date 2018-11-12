clear; close all;
%% Initialization
snrDb = 0: 5: 25;
nTxRx = 2;
nChannels = 30;
nBits = 1e5;
pskNumber = 4;
berMl = zeros(1, length(snrDb));
berMlAlamouti = zeros(1, length(snrDb));
%% Channel generation, transmission simulation and BER calculation 
for iSnrDb = snrDb
    snrDbIndex = find(snrDb == iSnrDb);
    iSnr = 10 .^ (iSnrDb / 10);
    % signal in alamouti coding
    channelMatrix = channel_matrix_generation(nTxRx, nChannels);
    [txStreamSplit, rxStreamSplit, txStreamSplitAlamouti, rxStreamSplitAlamouti, nPairs] = qpsk_alamouti_system(iSnr, nTxRx, nChannels, nBits, channelMatrix);
    [berMl(snrDbIndex)] = maximum_likelihood(iSnr, nTxRx, nChannels, nBits, nPairs, channelMatrix, txStreamSplit, rxStreamSplit);
    [berMlAlamouti(snrDbIndex)] = maximum_likelihood_alamouti(iSnr, nTxRx, nChannels, nBits, nPairs, channelMatrix, txStreamSplitAlamouti, rxStreamSplitAlamouti);
end
%% BER comparison
figure;
berMlCurve = semilogy(snrDb, berMl, '-');
hold on;
berMlAlamoutiCurve = semilogy(snrDb, berMlAlamouti, '--');
title('Bit error rate of a 2-by-2 MIMO system with QPSK modulation');
xlabel('SNR (dB)');
ylabel('Bit Error Rate');
legend('Maximum Likelihood', 'Maximum Likelihood with Alamouti Coding');
grid on;
