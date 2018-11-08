function [berMaximumLikelihood, xMaximumLikelihood] = maximum_likelihood(iSnr, nTxRx, nChannels, nBits, nPairs, channelMatrix, txStreamSplit, rxStreamSplit)
bitErrorCount = zeros(nChannels, 1);
xMaximumLikelihood = cell(nChannels, 1);
xTemp = zeros(nTxRx * nChannels, nPairs);
% possible symbol set of x for 2 tx antennas
xSymbolSet = [0 + 0i, 0 + 1i, 1 + 1i, 1 + 0i];
[xTx1, xTx2] = meshgrid(xSymbolSet, xSymbolSet.');
[xTx1, xTx2] = deal(reshape(xTx1, [], 1), reshape(xTx2, [], 1));
xTxSet = [xTx1, xTx2].';
for iChannel = 1: nChannels
    hTemp = channelMatrix{iChannel};
    yTemp = rxStreamSplit{iChannel};
    for iPair = 1: nPairs
%         xMaximumLikelihood{iChannel}(:, iPair) = argmin(xTxSet, vecnorm(rxStreamSplit{iChannel}(:, iPair) - sqrt(iSnr / nTxRx) * channelMatrix{iChannel} * xTxSet));
        xTemp(2 * iChannel - 1: 2 * iChannel, iPair) = argmin(xTxSet, vecnorm(yTemp(:, iPair) - sqrt(iSnr / nTxRx) * hTemp * xTxSet));
    end
    % total error is the sum of real and imaginary errors
    errorMatrix = xor(real(txStreamSplit), real(xTemp(2 * iChannel - 1: 2 * iChannel, :))) + xor(imag(txStreamSplit), imag(xTemp(2 * iChannel - 1: 2 * iChannel, :)));
    bitErrorCount(iChannel) = sum(errorMatrix(:));
end
berMaximumLikelihood = sum(bitErrorCount(iChannel)) / (nChannels * nBits);
end
