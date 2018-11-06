function [txStream, rxStream] = qpsk_data_generation(iSnr, nTxRx, nChannels, nBits, channelMatrix)
variance = 1;
pskNumber = 4;
bitsPerSymbol = log2(pskNumber);
nSymbol = nBits / bitsPerSymbol;
rxStream = zeros(nChannels, 1);
% binary bit sequence
bitStream = round(rand(1, nBits));
txStream = reshape(bitStream, bitsPerSymbol, nSymbol);
% txStream = demultiplexedStream(1, :) + 1i * demultiplexedStream(2, :);
noise = sqrt(variance / 2) * (randn(1, nSymbol) + 1i * randn(1, nSymbol));
for iChannel = 1: nChannels
    rxStream(iChannel) = sqrt(iSnr / nTxRx) * channelMatrix{iChannel} * txStream + noise;
end
end

