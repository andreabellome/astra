function [MAT, M1, M2] = generateMAT(pl1, pl2, T0, TOFS)

% DESCRIPTION:
% This function generates a matrix of possible time pairs for a given trajectory leg, based on the departure and arrival planets,
% the initial times, and the time of flight constraints. It also creates matrices for unique departure and arrival time pairs.
% 
% INPUT:
% pl1  : Integer representing the departure planet ID.
% pl2  : Integer representing the arrival planet ID.
% T0   : Vector containing the possible initial times for the trajectory legs.
% TOFS : Vector containing the possible times of flight for the trajectory legs.
% 
% OUTPUT:
% MAT  : Matrix of possible time pairs for the trajectory legs. Each row represents a potential trajectory with columns for
%        departure planet ID, initial time, arrival planet ID, and arrival time.
% M1   : Matrix of unique departure time pairs (departure planet ID and initial time).
% M2   : Matrix of unique arrival time pairs (arrival planet ID and arrival time).
% 
% -------------------------------------------------------------------------

MAT = zeros(length(TOFS)*length(T0), 4);
ind  = 1;
for indt0 = 1:length(T0)
    for indtof = 1:length(TOFS)
        MAT(ind,:) = [ pl1 T0(indt0) pl2 [T0(indt0) + TOFS(indtof)] ];
        ind        = ind + 1;
    end
end

M1   = unique(MAT(:,1:2), 'rows', 'stable');
M2   = unique(MAT(:,3:4), 'rows', 'stable');

end