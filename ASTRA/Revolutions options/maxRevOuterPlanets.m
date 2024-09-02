function [chosenRevs] = maxRevOuterPlanets(seq, chosenRevs)

% DESCRIPTION
% This function updates the matrix of chosen revolutions to set the 
% revolutions for outer planets (with sequence IDs in the range 5 to 1192) 
% to zero. It ensures that the updated matrix reflects that no revolutions 
% are performed for these specific outer planets.
% 
% INPUT
% - seq        : Sequence of IDs for flyby bodies, indicating the order in which they are visited.
% - chosenRevs : Matrix representing different permutations of number of revolutions and 
%                cases (low-/high-energy) for each leg. Each column represents a leg of the sequence.
% 
% OUTPUT
% - chosenRevs : Updated matrix where the revolutions for the outer planets (IDs 5 to 1192) 
%                are set to zero. Each column corresponds to a leg of the sequence of flyby bodies. 
%                The coding is as follows:
%                0  --> means 0 revolutions on the leg.
%                10 --> means 1 revolution and case 0 (low energy) on the leg.
%                11 --> means 1 revolution and case 1 (high energy) on the leg.
%                20 --> means 2 revolutions and case 0 (low energy) on the leg.
%                21 --> means 2 revolutions and case 1 (high energy) on the leg.
%                and so on...
% 
% PROCESS
% - Identify indices in the sequence where IDs are between 5 and 1192 (inclusive).
% - Determine the number of legs up to the identified index.
% - Update the chosenRevs matrix by setting the revolutions for these legs to 0.
% - Ensure that the updated matrix has unique rows in a stable order.
% 
% -------------------------------------------------------------------------

ind = find(seq >= 5 & seq <= 1192);
if ind == 1
    nleg = 1;
else
    nleg = ind - 1;
end
for indl = 1:length(nleg)
    chosenRevs(:,nleg(indl)) = 0;
end
chosenRevs = unique(chosenRevs, 'rows', 'stable');

end