% Function: 
%   - argmin: points x for which f(x) attains its smallest value
%
% InputArg(s):
%   - xTxSet: the possible value set of one symbol
%   - targetFunction: the function to be minimized
%
% OutputArg(s):
%   - elementSymbol: the symbol regarded as transmitted
%
% Comments:
%   - the possible set should be determined before calling
%
% Author & Date: Yang (i@snowztail.com) - 12 Nov 18
function [elementSymbol] = argmin(xTxSet, targetFunction)
 [~, minIndex] = min(targetFunction);
 elementSymbol = xTxSet(:, minIndex);
end

