function [berMaximumLikelihood, xMaximumLikelihood] = maximum_likelihood_alamouti(iSnr, nTxRx, nChannels, nBits, nPairs, channelMatrix, txStreamSplit, rxStreamSplit)
bitErrorCount = zeros(nChannels, 1);
xMaximumLikelihood = cell(nChannels, 1);
% possible symbol set of x for 2 tx antennas
xSymbolSet = [0 + 0i, 0 + 1i, 1 + 1i, 1 + 0i];
[xTx1, xTx2] = meshgrid(xSymbolSet, xSymbolSet.');
[xTx1, xTx2] = deal(reshape(xTx1, [], 1), reshape(xTx2, [], 1));
xTxSet = [xTx1, xTx2].';
nCombinations = length(xTxSet);
% possible alamouti set
xAlamoutiSet = zeros(nTxRx, nTxRx * nCombinations);
xAlamoutiSet(:, 1: 2: end) = xTxSet;
xAlamoutiSet(1, 2: 2: end) = - xTxSet(2, :)';
xAlamoutiSet(2, 2: 2: end) = xTxSet(1, :)';
for iChannel = 1: nChannels
    for iPair = 1: nPairs
        frobeniusNorm = zeros(1, nCombinations);
        for iCombination = 1: nCombinations
            frobeniusNorm(iCombination) = norm(rxStreamSplit{iChannel}(:, 2 * iPair - 1: 2 * iPair) - sqrt(iSnr / nTxRx) * channelMatrix{iChannel} * xAlamoutiSet(:, 2 * iCombination - 1: 2 * iCombination), 'fro');
        end
        xMaximumLikelihood{iChannel}(:, iPair) = argmin(xTxSet, frobeniusNorm);
    end
    % total error is the sum of real and imaginary errors
    errorMatrix = xor(real(txStreamSplit(:, 1: 2: end)), real(xMaximumLikelihood{iChannel})) + xor(imag(txStreamSplit(:, 1: 2: end)), imag(xMaximumLikelihood{iChannel}));
    bitErrorCount(iChannel) = sum(errorMatrix(:));
end
berMaximumLikelihood = sum(bitErrorCount(iChannel)) / (nChannels * nBits);
end

