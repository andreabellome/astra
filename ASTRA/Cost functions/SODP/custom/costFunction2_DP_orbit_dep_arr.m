function [minCOST, row, COSTS, TOFYS] = costFunction2_DP_orbit_dep_arr(legn, vvf, vinff, idcentral, pl_dep, rp_dep, ra_dep, pl_arr, rp_arr, ra_arr)

[~, mu_dep] = constants(idcentral, pl_dep);
[~, mu_arr] = constants(idcentral, pl_arr);

vinfd    = legn(:,3);
dv_dep   = deltaV_hyperbola( vinfd, rp_dep, ra_dep, mu_dep );
dv_arr   = deltaV_hyperbola( vinff, rp_arr, ra_arr, mu_arr );

COSTS = sum( [ dv_dep legn(:,6:3:end-2) dv_arr ] , 2);

TOFYS          = (legn(:,end) - legn(:,2))./365.25;
[minCOST, row] = min(COSTS);

end
