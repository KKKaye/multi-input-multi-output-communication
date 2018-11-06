function [txStreamSplit, rxStreamSplit] = qpsk_data_generation(iSnr, nTxRx, nChannels, nBits, channelMatrix)
variance = 1;
pskNumber = 4;
bitsPerSymbol = log2(pskNumber);
nSymbols = nBits / bitsPerSymbol;
rxStreamSplit = cell(nChannels, 1);
% binary bit sequence
bitStream = round(rand(1, nBits));
% bpsk sequence
demultiplexedStream = reshape(bitStream, bitsPerSymbol, nSymbols);
txStream = demultiplexedStream(1, :) + 1i * demultiplexedStream(2, :);
% split data for mimo: dimension is (number of tx) * (symbols per tx), each
% row correspond to the data handled by an tx antenna
txStreamSplit = reshape(txStream, nTxRx, nSymbols / nTxRx);
noise = sqrt(variance / 2) * (randn(1, nSymbols) + 1i * randn(1, nSymbols));
noiseSplit = reshape(noise, nTxRx, nSymbols / nTxRx);
for iChannel = 1: nChannels
    rxStreamSplit{iChannel} = sqrt(iSnr / nTxRx) * channelMatrix{iChannel} * txStreamSplit + noiseSplit;
end
end

