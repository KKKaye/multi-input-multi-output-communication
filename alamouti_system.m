function [txStreamSplit, rxStreamSplit, nPairs] = alamouti_system(iSnr, nTxRx, nChannels, nBits, channelMatrix)
variance = 1;
pskNumber = 4;
bitsPerSymbol = log2(pskNumber);
nSymbols = nBits / bitsPerSymbol;
nPairs = nSymbols / nTxRx;
% signal length doubled
txStreamSplit = zeros(nTxRx, nSymbols);
rxStreamSplit = cell(nChannels, 1);
% binary bit sequence
bitStream = round(rand(1, nBits));
% bpsk sequence
demultiplexedStream = reshape(bitStream, bitsPerSymbol, nSymbols);
txStream = demultiplexedStream(1, :) + 1i * demultiplexedStream(2, :);
% data on tx 1
txStreamSplit(1, 1: 2: end) = txStream(1: 2: end);
txStreamSplit(1, 2: 2: end) = - txStream(2: 2: end)';
% data on tx 2
txStreamSplit(2, 1: 2: end) = txStream(2: 2: end);
txStreamSplit(2, 2: 2: end) = txStream(1: 2: end)';
noiseSplit = sqrt(variance / 2) * (randn(1, nSymbols) + 1i * randn(1, nSymbols));
for iChannel = 1: nChannels
    rxStreamSplit{iChannel} = sqrt(iSnr / nTxRx) * channelMatrix{iChannel} * txStreamSplit + noiseSplit;
end
end

