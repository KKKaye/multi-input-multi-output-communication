% Function: 
%   - detector with maximum-likelihood algorithm
%
% InputArg(s):
%   - iSnr: current signal-to-noise ratio 
%   - nTxRx: number of transmitter and receiver antennas
%   - nChannels: number of channels to simulate
%   - nBits: number of bits in a stream
%   - nPairs: number of symbol pairs
%   - channelMatrix: complex channel realization (holds channel gains)
%   - txStreamSplit: the transmitted symbol streams splitted to tx antennas
%   - rxStreamSplit: the received symbol streams on rx antennas
%
% OutputArg(s):
%   - berMaximumLikelihood: bit error rate based on Monte Carlo method
%
% Comments:
%   - complex but accurate
%
% Author & Date: Yang (i@snowztail.com) - 12 Nov 18
function [berMaximumLikelihood] = maximum_likelihood(iSnr, nTxRx, nChannels, nBits, nPairs, channelMatrix, txStreamSplit, rxStreamSplit)
bitErrorCount = zeros(nChannels, 1);
xMaximumLikelihood = cell(nChannels, 1);
% possible symbol set of x for 2 tx antennas
xSymbolSet = [0 + 0i, 0 + 1i, 1 + 1i, 1 + 0i];
[xTx1, xTx2] = meshgrid(xSymbolSet, xSymbolSet.');
[xTx1, xTx2] = deal(reshape(xTx1, [], 1), reshape(xTx2, [], 1));
xTxSet = [xTx1, xTx2].';
for iChannel = 1: nChannels
    for iPair = 1: nPairs
    xMaximumLikelihood{iChannel}(:, iPair) = argmin(xTxSet, vecnorm(rxStreamSplit{iChannel}(:, iPair) - sqrt(iSnr / nTxRx) * channelMatrix{iChannel} * xTxSet));
    end
    % total error is the sum of real and imaginary part errors
    errorMatrix = xor(real(txStreamSplit), real(xMaximumLikelihood{iChannel})) + xor(imag(txStreamSplit), imag(xMaximumLikelihood{iChannel}));
    bitErrorCount(iChannel) = sum(errorMatrix(:));
end
berMaximumLikelihood = sum(bitErrorCount(iChannel)) / (nChannels * nBits);
end
