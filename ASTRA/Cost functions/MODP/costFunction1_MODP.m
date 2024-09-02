function [legn, vvf, vinff] = costFunction1_MODP(legn, vvf, vinff)

% DESCRIPTION:
% This function selects the optimal trajectories based on a multi-objective optimization approach, 
% considering both the total cost and time of flight (TOF). The function computes the Pareto front, 
% identifying the set of non-dominated solutions, and returns only the trajectories on this front.
% 
% INPUT:
% legn   : Matrix where each row represents a different candidate trajectory. The cost for each leg 
%          is stored in the 3rd column of each group of three columns.
% vvf    : Matrix containing the final velocities for the corresponding candidate trajectories.
% vinff  : Matrix containing the incoming velocities for the corresponding candidate trajectories.
% 
% OUTPUT:
% legn   : Matrix containing only the trajectories that lie on the Pareto front.
% vvf    : The final velocities associated with the trajectories on the Pareto front.
% vinff  : The incoming velocities associated with the trajectories on the Pareto front.
%
% -------------------------------------------------------------------------

% --> compute the two objectives
costTOTn = sum( legn(:,3:3:end-2) , 2); 
TOFyn    = (legn(:,end) - legn(:,2))./365.25;

% --> put them into the cost matrix
COSTmatrix = [ TOFyn costTOTn ];

% --> compute the Pareto front
[PARETO_FRONT] = paretoFront_MODP( COSTmatrix );

% --> save only those on Pareto front
rows  = PARETO_FRONT(:,end);
legn  = legn(rows,:);
vvf   = vvf(rows,:);
vinff = vinff(rows,:);

end
