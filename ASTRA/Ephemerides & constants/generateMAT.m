function [MAT, M1, M2] = generateMAT(pl1, pl2, T0, TOFS)

% DESCRIPTION:
% This function generates a matrix of possible time pairs for a given trajectory leg, based on the departure and arrival planets,
% the initial times, and the time of flight constraints. It also creates matrices for unique departure and arrival time pairs.
% 
% INPUT:
% - pl1  : Integer representing the departure planet ID.
% - pl2  : Integer representing the arrival planet ID.
% - T0   : Vector containing the possible initial times for the trajectory legs.
% - TOFS : Vector containing the possible times of flight for the trajectory legs.
% 
% OUTPUT:
% - MAT  : Matrix of possible time pairs for the trajectory legs. Each row represents a potential trajectory with columns for
%        departure planet ID, initial time, arrival planet ID, and arrival time.
% - M1   : Matrix of unique departure time pairs (departure planet ID and initial time).
% - M2   : Matrix of unique arrival time pairs (arrival planet ID and arrival time).
% 
% IMPLEMENTATION NOTE (drop-in replacement, identical input/output)
% The double for-loop filling MAT row by row is replaced by repelem/repmat.
% Row order (T0 outer, TOFS inner) and the arrival times T0(i)+TOFS(j) are
% computed with the same floating-point operation, so MAT is bit-identical.
% 
% -------------------------------------------------------------------------

nT0  = length(T0);
nTOF = length(TOFS);
t0v  = reshape(T0(1:nT0), [], 1);
tofv = reshape(TOFS(1:nTOF), [], 1);

t1  = repelem(t0v, nTOF, 1);
MAT = zeros(nTOF*nT0, 4);
MAT(:,1) = pl1;
MAT(:,2) = t1;
MAT(:,3) = pl2;
MAT(:,4) = t1 + repmat(tofv, nT0, 1);

M1   = unique(MAT(:,1:2), 'rows', 'stable');
M2   = unique(MAT(:,3:4), 'rows', 'stable');

end
