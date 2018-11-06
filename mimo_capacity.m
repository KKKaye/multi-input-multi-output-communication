clear; close all;
%% Initialization
snrDb = 0: 5: 30;
txRx = 5: 10;
nChannels = 1e4;
capacity = zeros(length(snrDb), length(txRx));
%% MIMO fading channels
for iSnrDb = snrDb
    snrDbIndex = find(snrDb == iSnrDb);
    iSnr = 10 .^ (iSnrDb / 10);
    for iTxRx = txRx
        txRxIndex = find(txRx == iTxRx);
        capacity(snrDbIndex, txRxIndex) = channel_ergotic_capacity(iTxRx, nChannels, iSnr);
    end
end
figure;
capacityCurve = plot(snrDb, capacity);
title('MIMO capacity');
xlabel('SNR (dB)');
ylabel('Capacity (bps/Hz)');
legend('n_T = n_R = 5', 'n_T = n_R = 6', 'n_T = n_R = 7', 'n_T = n_R = 8', 'n_T = n_R = 9', 'n_T = n_R = 10', 'location', 'northwest');
