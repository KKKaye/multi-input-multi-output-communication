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
