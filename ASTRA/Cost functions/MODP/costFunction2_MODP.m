function [legn, vvf, vinff, PF, COSTS, TOFYS, minCOST, row] = costFunction2_MODP(legn, vvf, vinff)

% DESCRIPTION:
% This function performs a multi-objective optimization by evaluating both the total cost and time of flight (TOF)
% for multiple candidate trajectories. It identifies the Pareto front, selecting the set of non-dominated solutions.
% The function also determines the trajectory with the minimum cost among all candidates.
% 
% INPUT:
% legn   : Matrix where each row represents a different candidate trajectory, with the cost for each leg 
%          stored in the 3rd column of each group of three columns.
% vvf    : Matrix containing the final velocities for the corresponding candidate trajectories.
% vinff  : Matrix containing the incoming velocities for the corresponding candidate trajectories.
% 
% OUTPUT:
% legn    : Matrix containing only the trajectories that lie on the Pareto front.
% vvf     : The final velocities associated with the trajectories on the Pareto front.
% vinff   : The incoming velocities associated with the trajectories on the Pareto front.
% PF      : Matrix representing the Pareto front of the cost matrix.
% COSTS   : Vector containing the total costs for all candidate trajectories, calculated as the sum of 
%           leg costs and incoming velocities.
% TOFYS   : Vector containing the time of flight for each trajectory, converted to years.
% minCOST : The minimum total cost found across all candidate trajectories.
% row     : The index (row number) of the trajectory with the minimum cost in the input matrix `legn`.
% 
% -------------------------------------------------------------------------

% --> compute the objectives of the optimization
COSTS = sum( [ legn(:,3:3:end-2) vinff ], 2);
TOFYS = (legn(:,end) - legn(:,2))./365.25;

% --> put them into the cost matrix
COSTmatrix = [ TOFYS COSTS ];

% --> compute the Pareto front
PF = paretoFront_MODP( COSTmatrix );

% --> save only those on Pareto front
rows  = PF(:,3); % --> legs on Pareto front
legn  = legn(rows,:);
vvf   = vvf(rows,:);
vinff = vinff(rows,:);

% --> find min. DV solution
[minCOST, row] = min(COSTS); % --> min. DV leg

end