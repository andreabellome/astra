function [minVal, minRow, minCol] = minValueMatrix(mat)

[minVal, row_idx] = min(mat(:)); % Find the minimum value and its linear index
[minRow, minCol]  = ind2sub(size(mat), row_idx);

end