function [legn, vvf, vinff] = costFunction1_DP_orbit_dep(legn, vvf, vinff, idcentral, pl_dep, rp_dep, ra_dep)

[~, mu_dep] = constants(idcentral, pl_dep);

vinfd    = legn(:,3);
dv_dep   = deltaV_hyperbola( vinfd, rp_dep, ra_dep, mu_dep );

dvtot    = sum( [ dv_dep legn(:,6:3:end-2) ] , 2);

[~, row] = min(dvtot);

legn  = legn(row,:);
vvf   = vvf(row,:);
vinff = vinff(row,:);

end