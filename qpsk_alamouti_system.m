% Function: 
%   - generate bit stream
%   - map to plain QPSK & Alamouti QPSK symbols
%   - simulate transmission
%
% InputArg(s):
%   - iSnr: current signal-to-noise ratio 
%   - nTxRx: number of transmitter and receiver antennas
%   - nChannels: number of channels to simulate
%   - nBits: number of bits in a stream
%   - channelMatrix: complex channel realization (holds channel gains)
%
% OutputArg(s):
%   - txStreamSplit: the transmitted symbol streams splitted to tx antennas
%   - rxStreamSplit: the received symbol streams on rx antennas
%   - txStreamSplitAlamouti: tx streams on Alamouti coding
%   - rxStreamSplitAlamouti: rx streams on Alamouti coding
%   - nPairs: number of symbol pairs
%
% Restraints:
%   - for 2-by-2 MIMO systems only
%
% Comments:
%   - use cells for readability; modify to 3-d matrix for performance
%
% Author & Date: Yang (i@snowztail.com) - 12 Nov 18
function [txStreamSplit, rxStreamSplit, txStreamSplitAlamouti, rxStreamSplitAlamouti, nPairs] = qpsk_alamouti_system(iSnr, nTxRx, nChannels, nBits, channelMatrix)
variance = 1;
pskNumber = 4;
bitsPerSymbol = log2(pskNumber);
nSymbols = nBits / bitsPerSymbol;
nPairs = nSymbols / nTxRx;
rxStreamSplit = cell(nChannels, 1);
% signal length doubled
txStreamSplitAlamouti = zeros(nTxRx, nSymbols);
rxStreamSplitAlamouti = cell(nChannels, 1);
% binary bit sequence
bitStream = round(rand(1, nBits));
% bpsk sequence
demultiplexedStream = reshape(bitStream, bitsPerSymbol, nSymbols);
txStream = demultiplexedStream(1, :) + 1i * demultiplexedStream(2, :);
txStreamSplit = reshape(txStream, nTxRx, nPairs);
noiseSplit = sqrt(variance / 2) * (randn(nTxRx, nPairs) + 1i * randn(nTxRx, nPairs));
% data on tx 1
txStreamSplitAlamouti(1, 1: 2: end) = txStream(1: 2: end);
txStreamSplitAlamouti(1, 2: 2: end) = - txStream(2: 2: end)';
% data on tx 2
txStreamSplitAlamouti(2, 1: 2: end) = txStream(2: 2: end);
txStreamSplitAlamouti(2, 2: 2: end) = txStream(1: 2: end)';
noiseSplitAlamouti = sqrt(variance / 2) * (randn(nTxRx, nSymbols) + 1i * randn(nTxRx, nSymbols));
for iChannel = 1: nChannels
    rxStreamSplit{iChannel} = sqrt(iSnr / nTxRx) * channelMatrix{iChannel} * txStreamSplit + noiseSplit;
    rxStreamSplitAlamouti{iChannel} = sqrt(iSnr / nTxRx) * channelMatrix{iChannel} * txStreamSplitAlamouti + noiseSplitAlamouti;
end
end

