% Function: 
%   - quantize QPSK signals
% InputArg(s):
%   - continuousSample: unquantized samples
%
% OutputArg(s):
%   - discreteSample: quantized samples
%
% Comments:
%   - both real and imaginary parts correspond to one bit
%
% Author & Date: Yang (i@snowztail.com) - 12 Nov 18
function [discreteSample] = quantization(continuousSample)
discreteSample = (real(continuousSample) >= 0.5) + 1i * (imag(continuousSample) >= 0.5);
end
