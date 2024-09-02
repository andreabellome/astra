function [chosenRevs, res] = processResonances(chosenRevs, res)

% DESCRIPTION
% This function processes the matrix of chosen revolutions by setting the 
% revolutions for specific resonant legs to zero and ensuring that the matrix 
% contains unique rows. It also reshapes the results matrix back to its original format.
% 
% INPUT
% - chosenRevs : Matrix representing permutations of number of revolutions and cases 
%                (low-/high-energy) for each leg. Each column represents a leg of the sequence.
% - res        : Matrix of results where each row contains information about a leg, 
%                with the last column indicating the resonant leg.
% 
% OUTPUT
% - chosenRevs : Updated matrix with the revolutions for resonant legs set to zero. 
%                The matrix is also ensured to have unique rows.
% - res        : Reshaped matrix of results back to a single row format.
% 
% PROCESS
% - Reshape the results matrix to have 3 rows and as many columns as necessary.
% - Extract the resonant legs from the last column of the reshaped matrix.
% - Set the revolutions for these resonant legs to zero in the chosenRevs matrix.
% - Ensure that the chosenRevs matrix contains unique rows.
% - Reshape the results matrix back to a single row format.
% 
% -------------------------------------------------------------------------

res                   = reshape(res, 3, [])';
legsres               = res(:,end);
chosenRevs(:,legsres) = 0; 
chosenRevs            = unique(chosenRevs,'rows');
res                   = reshape(res', 1, []);

end