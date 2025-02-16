function [minCOST, row, COSTS, TOFYS] = costFunction2_DP_custom_vdep_varr(legn, vvf, vinff, vdep, varr, sigma)

% DESCRIPTION
% This function computes the total cost of a trajectory based on delta-v and 
% time-of-flight, incorporating departure and arrival velocity constraints. 
% It identifies the minimum-cost trajectory among the given options.
%
% INPUT
% - legn  : matrix containing trajectory leg parameters, where columns represent 
%           different trajectory characteristics such as departure time, arrival 
%           time, and delta-v components.
% - vvf   : matrix containing final velocity vectors for each trajectory leg.
% - vinff : matrix containing incoming hyperbolic excess velocities.
% - vdep  : scalar value representing the specified departure velocity.
% - varr  : scalar value representing the specified arrival velocity.
% - sigma : weighting factor for the time-of-flight in the total cost computation.
%
% OUTPUT
% - minCOST : minimum total cost among all trajectories.
% - row     : index of the trajectory with the minimum cost.
% - COSTS   : vector containing the total cost for each trajectory.
% - TOFYS   : vector containing the time-of-flight in years for each trajectory.
%
% PROCESS
% 1. Compute the departure delta-v (dv1), ensuring non-negative values.
% 2. Compute the arrival delta-v (dv2), ensuring non-negative values.
% 3. Compute the total time-of-flight (tofs) in years.
% 4. Compute the total delta-v (dvtot) including all intermediate maneuvers.
% 5. Compute the total cost as the sum of delta-v and weighted time-of-flight.
% 6. Identify the trajectory with the minimum total cost.
%
% -------------------------------------------------------------------------

% --> compute the objectives of the optimization
vinfd  = legn(:,3);
dv1    = (vinfd - vdep).*(vinfd - vdep >= 0); % --> if specified, the vInf<vdep is for free
dv2    = (vinff - varr).*(vinff - varr >= 0); % --> if specified, the vInf<varr is for free
tofs   = (legn(:,end) - legn(:,2));

dvtot = sum( [ dv1 legn(:,6:3:end-2) dv2 ] , 2);
COSTS = dvtot + sigma.*tofs;
TOFYS = (legn(:,end) - legn(:,2))./365.25;

[minCOST, row] = min(COSTS);

end