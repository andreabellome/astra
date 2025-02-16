function [legn, vvf, vinff] = costFunction1_DP_custom_vdep(legn, vvf, vinff, vdep, sigma)

% DESCRIPTION
% This function selects the optimal trajectory based on a cost function that 
% considers both delta-v and time-of-flight. It returns the trajectory leg, 
% final velocity, and incoming hyperbolic excess velocity corresponding to 
% the minimum cost.
%
% INPUT
% - legn  : matrix containing trajectory leg parameters, where columns represent 
%           different trajectory characteristics such as departure time, arrival 
%           time, and delta-v components.
% - vvf   : matrix containing final velocity vectors for each trajectory leg.
% - vinff : matrix containing incoming hyperbolic excess velocities.
% - vdep  : scalar value representing the specified departure velocity.
% - sigma : weighting factor for the time-of-flight in the total cost computation.
%
% OUTPUT
% - legn  : row vector corresponding to the optimal trajectory leg.
% - vvf   : row vector corresponding to the final velocity of the optimal trajectory.
% - vinff : row vector corresponding to the incoming excess velocity of the optimal trajectory.
%
% PROCESS
% 1. Compute the departure delta-v (dv1), ensuring non-negative values.
% 2. Compute the total time-of-flight (tofs).
% 3. Compute the total delta-v (dvtot) including all intermediate maneuvers.
% 4. Normalize the time-of-flight in years.
% 5. Compute the total cost as the sum of delta-v and weighted time-of-flight.
% 6. Identify the trajectory with the minimum total cost.
% 7. Return the corresponding trajectory leg, final velocity, and incoming excess velocity.
%
% -------------------------------------------------------------------------


% --> compute the two objectives
vinfd    = legn(:,3);
dv1      = (vinfd - vdep).*(vinfd - vdep >= 0);
tofs     = (legn(:,end) - legn(:,2));
dvtot    = sum( [ dv1 legn(:,6:3:end-2) ] , 2);

TOFyn    = tofs./365.25;
costTOTn = dvtot + sigma.*tofs;

[~, row] = min(costTOTn);

legn  = legn(row,:);
vvf   = vvf(row,:);
vinff = vinff(row,:);

end