function [LEGSnext, VASnext, VINFnext, tocVec, nLP] = wrap_DynProgr_st1(T0, legs, runOpts, tstep, TOF_LIM, INPUT)

% DESCRIPTION:
% This function performs the first stage of dynamic programming for interplanetary trajectory optimization. 
% It computes the possible legs, associated velocities, and incoming velocities for the next stage, considering 
% the initial conditions and constraints. The function supports parallel processing to speed up calculations.
% 
% INPUT:
% T0      : Initial time (epoch) for the departure from the first planet.
% legs    : Matrix representing the sequence of planetary encounters, where each row corresponds to a leg.
% runOpts : Vector containing options for the Lambert solver, such as the method for solving the Lambert problem.
% tstep   : Time step (in days) used for generating possible times of flight.
% TOF_LIM : Vector containing the minimum and maximum time of flight limits for the legs.
% INPUT   : Structure containing various settings and options, including parallel computing settings.
% 
% OUTPUT:
% LEGSnext : Matrix containing the possible trajectory legs for the next stage, including the departure and arrival planets, 
%            departure and arrival times, and the delta-v required.
% VASnext  : Matrix containing the arrival velocities at the destination planets for each leg.
% VINFnext : Vector containing the incoming velocities at the destination planets for each leg.
% tocVec   : Scalar representing the elapsed time for the function execution.
% nLP      : Scalar representing the number of possible legs for the next stage.
% 
% -------------------------------------------------------------------------


tic0  = tic;

mu    = 132724487690;

indl  = 1;
pl1   = legs(indl,1);
pl2   = legs(indl,2);
optMR = runOpts(indl,:);

% --> generate TOF for the given leg
TOFS = wrap_TOFs(pl1, pl2, optMR, tstep, TOF_LIM, indl);

% --> find next nodes (i.e. couples of planets with their visiting epochs)
[MAT, M1, M2] = generateMAT(pl1, pl2, T0, TOFS);
[EPH]         = wrap_generateEPH(M1, M2);

nLP  = size(MAT,1);

% --> solve the LP for the first leg
if INPUT.parallel == true
    LEGSnext = zeros(size(MAT,1), 5);
    VASnext  = zeros(size(MAT,1), 3);
    VINFnext = zeros(size(MAT,1), 1);
    parfor indm = 1:size(MAT,1)

        pl1        = MAT(indm,1);
        t1         = MAT(indm,2);
        pl2        = MAT(indm,3);
        t2         = MAT(indm,4);
        rr1        = EPH( EPH(:,1) == pl1 & EPH(:,2) == t1 , 3:5 );
        vv1        = EPH( EPH(:,1) == pl1 & EPH(:,2) == t1 , 6:8 );
        rr2        = EPH( EPH(:,1) == pl2 & EPH(:,2) == t2 , 3:5 );
        vv2        = EPH( EPH(:,1) == pl2 & EPH(:,2) == t2 , 6:8 );
        tof        = MAT(indm,4) - MAT(indm,2); 
        
        [vvd, vva] = lambertMR_MEXIFY_mex(rr1, rr2, tof*86400, mu, optMR(1), optMR(2));

        dv               = norm(vvd - vv1);
        VASnext(indm,:)  = vva;
        LEGSnext(indm,:) = [pl1 t1 dv pl2 t2];
        VINFnext(indm,:) = norm(vv2 - vva);

    end
else
    LEGSnext = zeros(size(MAT,1), 5);
    VASnext  = zeros(size(MAT,1), 3);
    VINFnext = zeros(size(MAT,1), 1);
    for indm = 1:size(MAT,1)

        pl1        = MAT(indm,1);
        t1         = MAT(indm,2);
        pl2        = MAT(indm,3);
        t2         = MAT(indm,4);
        rr1        = EPH( EPH(:,1) == pl1 & EPH(:,2) == t1 , 3:5 );
        vv1        = EPH( EPH(:,1) == pl1 & EPH(:,2) == t1 , 6:8 );
        rr2        = EPH( EPH(:,1) == pl2 & EPH(:,2) == t2 , 3:5 );
        vv2        = EPH( EPH(:,1) == pl2 & EPH(:,2) == t2 , 6:8 );
        tof        = MAT(indm,4) - MAT(indm,2);
        
        [vvd, vva] = lambertMR(rr1, rr2, tof*86400, mu, optMR(1), optMR(2));

        dv               = norm(vvd - vv1);
        VASnext(indm,:)  = vva;
        LEGSnext(indm,:) = [pl1 t1 dv pl2 t2];
        VINFnext(indm,:) = norm(vv2 - vva);

    end
end

% --> prune w.r.t. the dep. infinity velocity
[LEGSnext, VASnext, VINFnext] = prune_VINF_DP(LEGSnext, VASnext, VINFnext, INPUT);

tocVec = toc(tic0);
if INPUT.opt ~= 4
    toc(tic0)
end

end