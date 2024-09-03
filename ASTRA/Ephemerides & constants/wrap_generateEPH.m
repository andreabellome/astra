function [EPH] = wrap_generateEPH(M1, M2, idcentral)

% DESCRIPTION:
% This function generates a combined ephemeris matrix by generating ephemeris data for two sets of planetary time pairs,
% and then combining and deduplicating the results.
% 
% INPUT:
% M1  : Matrix of unique departure time pairs, where each row contains departure planet ID and initial time.
% M2  : Matrix of unique arrival time pairs, where each row contains arrival planet ID and arrival time.
% idcentral  : ID of the central body. See constants.m
%
% OUTPUT:
% EPH : Combined ephemeris matrix containing unique rows of ephemeris data for both departure and arrival time pairs.
% 
% NOTES:
% - `generateEPH` is a helper function that produces ephemeris data for given time pairs.
% - The output matrix `EPH` is unique and ordered based on the rows to ensure no duplicates and maintain stability.
% 
% -------------------------------------------------------------------------

if nargin == 2
    idcentral = 1;
end

EPH1 = generateEPH(M1, idcentral);
EPH2 = generateEPH(M2, idcentral);
EPH  = [EPH1; EPH2];

EPH = unique(EPH, 'rows', 'stable');

end