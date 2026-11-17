function [legn, vvf, vinff] = costFunction1_MODP_orbit_dep(legn, vvf, vinff, idcentral, pl_dep, rp_dep, ra_dep)

[~, mu_dep] = constants(idcentral, pl_dep);

vinfd    = legn(:,3);
dv_dep   = deltaV_hyperbola( vinfd, rp_dep, ra_dep, mu_dep );

tofs     = (legn(:,end) - legn(:,2));
dvtot    = sum( [ dv_dep legn(:,6:3:end-2) ] , 2);

TOFyn    = tofs./365.25;
costTOTn = dvtot;

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