% Function: 
%   - detector with zero forcing algorithm
%
% InputArg(s):
%   - iSnr: current signal-to-noise ratio 
%   - nTxRx: number of transmitter and receiver antennas
%   - nChannels: number of channels to simulate
%   - nBits: number of bits in a stream
%   - channelMatrix: complex channel realization (holds channel gains)
%   - txStreamSplit: the transmitted symbol streams splitted to tx antennas
%   - rxStreamSplit: the received symbol streams on rx antennas
%
% OutputArg(s):
%   - berZeroForcing: bit error rate based on Monte Carlo method
%
% Comments:
%   - low complexity, not very accurate
%
% Author & Date: Yang (i@snowztail.com) - 12 Nov 18
function [berZeroForcing] = zero_forcing(iSnr, nTxRx, nChannels, nBits, channelMatrix, txStreamSplit, rxStreamSplit)
bitErrorCount = zeros(nChannels, 1);
xZeroForcing = cell(nChannels, 1);
for iChannel = 1: nChannels
    continuousSample = (sqrt(iSnr / nTxRx) * channelMatrix{iChannel}) ^ (-1) * rxStreamSplit{iChannel};
    xZeroForcing{iChannel} = quantization(continuousSample);
    errorMatrix = xor(real(txStreamSplit), real(xZeroForcing{iChannel})) + xor(imag(txStreamSplit), imag(xZeroForcing{iChannel}));
    bitErrorCount(iChannel) = sum(errorMatrix(:));
end
berZeroForcing = sum(bitErrorCount(iChannel)) / (nChannels * nBits);
end
