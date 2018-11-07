function [discreteSample] = quantization(continuousSample)
discreteSample = (real(continuousSample) >= 0.5) + 1i * (imag(continuousSample) >= 0.5);
end
