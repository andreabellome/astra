function [minCOST, row, COSTS, TOFYS] = costFunction2_DP(legn, vvf, vinff)

% DESCRIPTION:
% This function calculates the total cost for multiple candidate trajectories, taking into account
% both the leg costs and incoming velocities. It then determines the trajectory with the minimum cost.
% Additionally, it computes the time of flight (TOF) for each trajectory in years.
% 
% INPUT:
% legn   : Matrix where each row represents a different candidate trajectory, with the cost for 
%          each leg stored in the 3rd column of each group of three columns.
% vvf    : Matrix containing the final velocities for the corresponding candidate trajectories (not used in this function).
% vinff  : Matrix containing the incoming velocities for the corresponding candidate trajectories.
% 
% OUTPUT:
% minCOST : The minimum total cost found across all candidate trajectories.
% row     : The index (row number) of the trajectory with the minimum cost in the input matrix `legn`.
% COSTS   : Vector containing the total costs for all candidate trajectories, calculated as the sum of 
%           leg costs and incoming velocities.
% TOFYS   : Vector containing the time of flight for each trajectory, converted to years.
%
% -------------------------------------------------------------------------

COSTS          = sum( [ legn(:,3:3:end-2) vinff ], 2);
TOFYS          = (legn(:,end) - legn(:,2))./365.25;
[minCOST, row] = min(COSTS);

end