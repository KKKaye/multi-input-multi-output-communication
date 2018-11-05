function [capacityErgodic] = channel_matrix_generation(n, nChannel, iSnr)
capacity = zeros(nChannel, 1);
% channelMatrix = cell(nChannel, 1);
variance = 1;
for iChannel = 1: nChannel
    hTemp = sqrt (variance / 2) * (randn(n) + 1i * randn(n));
    % imaginary part is meaningless; take real part only
    capacity(iChannel) = real(log2(det(eye(n) + (iSnr / n) .* hTemp * hTemp')));
%     channelMatrix{iChannel} = hTemp;
end
capacityErgodic = mean(capacity);
end
