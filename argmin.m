function [xHat] = argmin(xTxSet, temp)
 [~, minIndex] = min(temp);
 xHat = xTxSet(:, minIndex);
end

