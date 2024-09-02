function [LEGSn, VASn, VINFn, nLP, nDEF] = wrap_DynProgr_st2(LEGSnext, VASnext, legs, runOpts, indl, tstep, TOF_LIM, INPUT)

% DESCRIPTION:
% This function performs dynamic programming for the second stage of the trajectory optimization. 
% It calculates and prunes potential trajectory legs, computes defects, and applies cost functions to determine 
% the optimal trajectory based on various constraints and input parameters.
% 
% INPUT:
% LEGSnext : Matrix containing the possible trajectory legs for the current iteration, where each row represents 
%            a leg with columns for departure and arrival planets, departure and arrival times, and the delta-v required.
% VASnext  : Matrix containing the arrival velocities at the destination planets for each leg.
% VINFn    : Vector containing the incoming velocities at the destination planets for each leg.
% legs     : Matrix specifying the sequence of planets and associated indices for processing.
% runOpts  : Matrix containing options for the Lambert solution, including the method and parameters.
% indl     : Index of the current leg being processed.
% tstep    : Time step for discretizing the trajectory.
% TOF_LIM  : Limits for time of flight constraints.
% INPUT    : Structure containing various constraints and limits, including:
%            - dsmOpts : Vector specifying the maximum allowed defect delta-v and other related parameters.
% 
% OUTPUT:
% LEGSn  : Matrix containing the trajectory legs after applying dynamic programming, pruning, and cost functions.
% VASn   : Matrix containing the arrival velocities for the filtered trajectory legs.
% VINFn  : Vector containing the incoming velocities for the filtered trajectory legs.
% nLP    : Number of possible legs considered in this stage.
% nDEF   : Number of defects calculated for the current set of trajectory legs.
% 
% -------------------------------------------------------------------------


mu    = 132724487690;
dvLim = INPUT.dsmOpts(1);

pl1   = legs(indl,1);
pl2   = legs(indl,2);
optMR = runOpts(indl,:);

% --> generate TOF for the given leg
TOFS = wrap_TOFs(pl1, pl2, optMR, tstep, TOF_LIM, indl);
T0   = unique(LEGSnext(:,end), 'rows', 'stable');

% tst

% --> find next nodes (i.e. couples of planets with their visiting epochs)
[MAT, M1, M2] = generateMAT(pl1, pl2, T0, TOFS);
[EPH]         = wrap_generateEPH(M1, M2);

if pl1 > 11 % --> perform the flyby with an asteroid/comet
    muPL  = 0;
    rpmin = 1000;
else % --> perform the flyby with a planet
    [muPL, radius] = planetConstants(pl1);
    rpmin          = maxmin_flybyAltitude(pl1) + radius;
end
% --> number of defects
nDEF = numberOfDefects(LEGSnext, TOFS);
nLP  = size(MAT,1);

% --> solve the LP
STRUC = struct('LEGSn', cell(1, size(MAT,1)),...
                'VASn', cell(1, size(MAT,1)),...
                'VINFn', cell(1, size(MAT,1))); 

if INPUT.parallel == true
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
        
        % --> solve the LP
        [vvd, vva] = lambertMR_MEXIFY_mex(rr1, rr2, tof*86400, mu, optMR(1), optMR(2));

        % --> apply DP principles
        indxs   = find(LEGSnext(:,end-1) == pl1 & LEGSnext(:,end) == t1);
        legprev = LEGSnext(indxs,:);
        vasprev = VASnext(indxs,:);
        
        % --> compute the DEFECTS
        [legn, vvf, vinff] = computeDefects_DP(legprev, vasprev, pl2, t2, vv1, vv2, vvd, vva, dvLim, muPL, rpmin);

        % --> compute the pruning so not to stress memory
        [legn, vvf, vinff] = wrap_Pruning_DP(legn, vvf, vinff, INPUT);
        
        if ~isempty(legn)
            
            % --> compute here the SO
            [legtosav, vvftosav, vinfftosav] = INPUT.costFunc1(legn, vvf, vinff);
            
            % --> save the legs        
            STRUC(indm).LEGSn = legtosav;
            STRUC(indm).VASn  = vvftosav;
            STRUC(indm).VINFn = vinfftosav;
            
        end
        
    end
else
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
        
        % --> solve the LP
        [vvd, vva] = lambertMR_MEXIFY_mex(rr1, rr2, tof*86400, mu, optMR(1), optMR(2));

        % --> apply DP principles
        indxs   = find(LEGSnext(:,end-1) == pl1 & LEGSnext(:,end) == t1);
        legprev = LEGSnext(indxs,:);
        vasprev = VASnext(indxs,:);
        
        % --> compute the DEFECTS
        [legn, vvf, vinff] = computeDefects_DP(legprev, vasprev, pl2, t2, vv1, vv2, vvd, vva, dvLim, muPL, rpmin);

        % --> compute the pruning so not to stress memory
        [legn, vvf, vinff] = wrap_Pruning_DP(legn, vvf, vinff, INPUT);
        
        if ~isempty(legn)
            
            % --> compute here the SO
            [legtosav, vvftosav, vinfftosav] = INPUT.costFunc1(legn, vvf, vinff);
            
            % --> save the legs        
            STRUC(indm).LEGSn = legtosav;
            STRUC(indm).VASn  = vvftosav;
            STRUC(indm).VINFn = vinfftosav;
            
        end
        
    end
end

% --> extract info from STRUC
LEGSn = cell2mat({STRUC.LEGSn}');
VASn  = cell2mat({STRUC.VASn}');
VINFn = cell2mat({STRUC.VINFn}');

% ndvDP

end
