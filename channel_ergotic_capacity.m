% Function: 
%   - calculate average capacity for MIMO systems with known antenna number
%   and SNR ratio under fading channels with zero mean and unit variance
%
% InputArg(s):
%   - n: number of transmitters and receivers antenna
%   - nChannel: number of channels to simulate
%   - iSnr: average signal-to-noise ratio at receive antennas
%
% OutputArg(s):
%   - capacityErgodic: average channel capacity
%
% Comments:
%   - only average capacity is returned
% Author & Date: Yang (i@snowztail.com) - %DATE%
function [capacityErgodic] = channel_ergotic_capacity(n, nChannel, iSnr)
capacity = zeros(nChannel, 1);
variance = 1;
for iChannel = 1: nChannel
    hTemp = sqrt (variance / 2) * (randn(n) + 1i * randn(n));
    % imaginary part is meaningless; take real part only
    capacity(iChannel) = real(log2(det(eye(n) + (iSnr / n) .* hTemp * hTemp')));
end
capacityErgodic = mean(capacity);
end
