function [legn, vvf, vinff, PF, COSTS, TOFYS, minCOST, row] = costFunction2_MODP_orbit_dep_arr(legn, vvf, vinff, idcentral, pl_dep, rp_dep, ra_dep, pl_arr, rp_arr, ra_arr)

[~, mu_dep] = constants(idcentral, pl_dep);
[~, mu_arr] = constants(idcentral, pl_arr);

vinfd    = legn(:,3);
dv_dep   = deltaV_hyperbola( vinfd, rp_dep, ra_dep, mu_dep );
dv_arr   = deltaV_hyperbola( vinff, rp_arr, ra_arr, mu_arr );

COSTS = sum( [ dv_dep legn(:,6:3:end-2) dv_arr ] , 2);
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
