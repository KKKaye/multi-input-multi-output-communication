% Function: 
%   - detector with minimum mean square error algorithm
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
%   - berMinimumMeanSquareError: bit error rate based on Monte Carlo method
%
% Comments:
%   - balanced between complexity and reliability
%
% Author & Date: Yang (i@snowztail.com) - 12 Nov 18

function [berMinimumMeanSquareError] = minimum_mean_square_error(iSnr, nTxRx, nChannels, nBits, channelMatrix, txStreamSplit, rxStreamSplit)
bitErrorCount = zeros(nChannels, 1);
xMinimumMeanSquareError = cell(nChannels, 1);
for iChannel = 1: nChannels
    continuousSample = ((iSnr / nTxRx) * channelMatrix{iChannel}' * channelMatrix{iChannel} + eye(nTxRx)) \ sqrt(iSnr / nTxRx) * channelMatrix{iChannel}' * rxStreamSplit{iChannel};
    xMinimumMeanSquareError{iChannel} = quantization(continuousSample);
    errorMatrix = xor(real(txStreamSplit), real(xMinimumMeanSquareError{iChannel})) + xor(imag(txStreamSplit), imag(xMinimumMeanSquareError{iChannel}));
    bitErrorCount(iChannel) = sum(errorMatrix(:));
end
berMinimumMeanSquareError = sum(bitErrorCount(iChannel)) / (nChannels * nBits);
end
