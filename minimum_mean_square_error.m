function [berMinimumMeanSquareError] = minimum_mean_square_error(iSnr, nTxRx, nChannels, nBits, channelMatrix, txStreamSplit, rxStreamSplit)
bitErrorCount = zeros(nChannels, 1);
xMinimumMeanSquareError = cell(nChannels, 1);
for iChannel = 1: nChannels
    continuousSample = ((iSnr / nTxRx) * channelMatrix{iChannel}' * channelMatrix{iChannel} + eye(nTxRx)) ^ (-1) * sqrt(iSnr / nTxRx) * channelMatrix{iChannel}' * rxStreamSplit{iChannel};
    xMinimumMeanSquareError{iChannel} = quantization(continuousSample);
    errorMatrix = xor(real(txStreamSplit), real(xMinimumMeanSquareError{iChannel})) + xor(imag(txStreamSplit), imag(xMinimumMeanSquareError{iChannel}));
    bitErrorCount(iChannel) = sum(errorMatrix(:));
end
berMinimumMeanSquareError = sum(bitErrorCount(iChannel)) / (nChannels * nBits);
end
