function [legn, vvf, vinff] = costFunction1_MODP_vdep(legn, vvf, vinff, vdep, sigma)

% DESCRIPTION
% This function computes two cost objectives for a given set of trajectory legs 
% and determines the subset of solutions that form the Pareto front.
%
% INPUT
% - legn  : matrix containing trajectory leg parameters, where columns represent 
%           different trajectory characteristics such as departure time, arrival 
%           time, and delta-v components.
% - vvf   : matrix containing final velocity vectors for each trajectory leg.
% - vinff : matrix containing incoming hyperbolic excess velocities.
% - vdep  : scalar value representing the initial departure velocity.
% - sigma : weighting factor for the time-of-flight in the total cost computation.
%
% OUTPUT
% - legn  : subset of the input legn matrix corresponding to the Pareto-optimal solutions.
% - vvf   : subset of the input vvf matrix corresponding to the Pareto-optimal solutions.
% - vinff : subset of the input vinff matrix corresponding to the Pareto-optimal solutions.
%
% PROCESS
% 1. Compute the departure delta-v (dv1), ensuring non-negative values.
% 2. Compute the total time-of-flight (tofs) in years.
% 3. Compute the total delta-v (dvtot) including all intermediate maneuvers.
% 4. Formulate the cost matrix using time-of-flight and total delta-v weighted by sigma.
% 5. Compute the Pareto front using the `paretoFront_MODP` function.
% 6. Extract and return only the Pareto-optimal solutions.
%
% -------------------------------------------------------------------------

% --> compute the two objectives
vinfd    = legn(:,3);
dv1      = (vinfd - vdep).*(vinfd - vdep >= 0);
tofs     = (legn(:,end) - legn(:,2));
dvtot    = sum( [ dv1 legn(:,6:3:end-2) ] , 2);

TOFyn    = tofs./365.25;
costTOTn = dvtot + sigma.*tofs;

% --> put them into the cost matrix
COSTmatrix = [ TOFyn costTOTn ];

% --> compute the Pareto front
[PARETO_FRONT] = paretoFront_MODP( COSTmatrix );

% --> save only those on Pareto front
rows  = PARETO_FRONT(:,3);
legn  = legn(rows,:);
vvf   = vvf(rows,:);
vinff = vinff(rows,:);

end
