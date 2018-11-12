% Function: 
%   - detector with maximum-likelihood algorithm on Alamouti code
%
% InputArg(s):
%   - iSnr: current signal-to-noise ratio 
%   - nTxRx: number of transmitter and receiver antennas
%   - nChannels: number of channels to simulate
%   - nBits: number of bits in a stream
%   - nPairs: number of symbol pairs
%   - channelMatrix: complex channel realization (holds channel gains)
%   - txStreamSplitAlamouti: tx streams on Alamouti coding
%   - rxStreamSplitAlamouti: rx streams on Alamouti coding
%
% OutputArg(s):
%   - berMaximumLikelihoodAlamouti: bit error rate based on Monte Carlo
%   method
%
% Comments:
%   - complex but very accurate
%   - lower BER vs 1t1r; double stream length vs plain QPSK
%
% Author & Date: Yang (i@snowztail.com) - 12 Nov 18
function [berMaximumLikelihoodAlamouti] = maximum_likelihood_alamouti(iSnr, nTxRx, nChannels, nBits, nPairs, channelMatrix, txStreamSplitAlamouti, rxStreamSplitAlamouti)
bitErrorCount = zeros(nChannels, 1);
xMaximumLikelihoodAlamouti = cell(nChannels, 1);
% possible symbol set of x for 2 tx antennas
xSymbolSet = [0 + 0i, 0 + 1i, 1 + 1i, 1 + 0i];
[xTx1, xTx2] = meshgrid(xSymbolSet, xSymbolSet.');
[xTx1, xTx2] = deal(reshape(xTx1, [], 1), reshape(xTx2, [], 1));
xTxSet = [xTx1, xTx2].';
nCombinations = length(xTxSet);
% possible Alamouti set
xAlamoutiSet = zeros(nTxRx, nTxRx * nCombinations);
xAlamoutiSet(:, 1: 2: end) = xTxSet;
xAlamoutiSet(1, 2: 2: end) = - xTxSet(2, :)';
xAlamoutiSet(2, 2: 2: end) = xTxSet(1, :)';
for iChannel = 1: nChannels
    for iPair = 1: nPairs
        frobeniusNorm = zeros(1, nCombinations);
        for iCombination = 1: nCombinations
            frobeniusNorm(iCombination) = norm(rxStreamSplitAlamouti{iChannel}(:, 2 * iPair - 1: 2 * iPair) - sqrt(iSnr / nTxRx) * channelMatrix{iChannel} * xAlamoutiSet(:, 2 * iCombination - 1: 2 * iCombination), 'fro');
        end
        xMaximumLikelihoodAlamouti{iChannel}(:, iPair) = argmin(xTxSet, frobeniusNorm);
    end
    % total error is the sum of real and imaginary part errors
    errorMatrix = xor(real(txStreamSplitAlamouti(:, 1: 2: end)), real(xMaximumLikelihoodAlamouti{iChannel})) + xor(imag(txStreamSplitAlamouti(:, 1: 2: end)), imag(xMaximumLikelihoodAlamouti{iChannel}));
    bitErrorCount(iChannel) = sum(errorMatrix(:));
end
berMaximumLikelihoodAlamouti = sum(bitErrorCount(iChannel)) / (nChannels * nBits);
end

