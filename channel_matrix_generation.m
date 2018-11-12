% Function: 
%   - generate channel matrix that holds the corresponding gains for
%   channels
%   
% InputArg(s):
%   - nTxRx: number of transmitters and receivers
%   - nChannels: number of channels
%
% OutputArg(s):
%   - channelMatrix: complex channel realization (holds channel gains)
%
% Comments:
%   - assume complex Gaussian (unit var, zero mean) channels with i.i.d
%   entries
%   - assume the numbers of transmitters and receivers equal
%
% Author & Date: Yang (i@snowztail.com) - 12 Nov 18
function [channelMatrix] = channel_matrix_generation(nTxRx, nChannels)
channelMatrix = cell(nChannels, 1);
variance = 1;
for iChannel = 1: nChannels
    channelMatrix{iChannel} = sqrt(variance / 2) * (randn(nTxRx) + 1i * randn(nTxRx));
end
end
