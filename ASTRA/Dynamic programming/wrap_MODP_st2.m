function [LEGSn, VASn, VINFn, nLP, nDEF] = wrap_MODP_st2(LEGSnext, VASnext, legs, runOpts, indl, tstep, TOF_LIM, INPUT)

% DESCRIPTION
% This function wraps the Multi-Objective Dynamic Programming (MODP) process for the 
% second stage of trajectory optimization. It evaluates possible trajectories for the 
% spacecraft, computes their feasibility, and prunes non-optimal paths using parallel 
% or sequential processing. The function ultimately selects and saves the best 
% trajectories based on a cost function.
% 
% INPUT
% - LEGSnext : Matrix containing the possible next legs (trajectories) of the spacecraft.
% - VASnext  : Matrix of spacecraft velocities corresponding to LEGSnext.
% - legs     : Matrix of initial trajectory legs (current mission plan).
% - runOpts  : Options for running the dynamic programming algorithm.
% - indl     : Index of the current leg being processed.
% - tstep    : Time step used for generating the time of flight (TOF) array.
% - TOF_LIM  : Limits on the time of flight for the leg.
% - INPUT    : Struct containing additional input parameters, including DSM options 
%              and the parallel processing flag.
% 
% OUTPUT
% - LEGSn    : Matrix containing the next legs after processing and optimization.
% - VASn     : Matrix of spacecraft velocities corresponding to the selected next legs.
% - VINFn    : Vector of spacecraft hyperbolic excess velocities for the selected next legs.
% - nLP      : Number of launch points (nodes) generated for the leg.
% - nDEF     : Number of defects found in the dynamic programming step.
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

% [muPL, radius] = planetConstants(pl1);
% rpmin          = maxmin_flybyAltitude(pl1) + radius;

% --> number of defects
nDEF = numberOfDefects(LEGSnext, TOFS);
nLP  = size(MAT,1);

% --> solve the LP
STRUC = struct('LEGSn', cell(1, size(MAT,1)),...
                'VASn', cell(1, size(MAT,1)),...
                'VINFn', cell(1, size(MAT,1))); 

if INPUT.parallel == true % --> solve PARALLEL
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

        % --> DYNAMIC PROGRAMMING 
        indxs   = find(LEGSnext(:,end-1) == pl1 & LEGSnext(:,end) == t1);
        legprev = LEGSnext(indxs,:);
        vasprev = VASnext(indxs,:);
        
        % --> DEFECTS
        [legn, vvf, vinff] = computeDefects_DP(legprev, vasprev, pl2, t2, vv1, vv2, vvd, vva, dvLim, muPL, rpmin);

        % --> PRUNING (on DEFECTS model)
        [legn, vvf, vinff] = wrap_Pruning_DP(legn, vvf, vinff, INPUT);

        if ~isempty(legn)

%             % --> compute the STM-DSM (after the pruning on DEFECTS model)
%             [~,loc]                     = ismember(legn(:,1:end-3),legprev,'rows');
%             [legnSTM, vvfSTM, vinffSTM] = STM_derivation(legn, vvf, vinff, vv1, rr1, vasprev(loc, :), legprev(loc, :));
%             % --> save the legs        
%             STRUC(indm).LEGSn_all     = legn;
%             STRUC(indm).VASn_all      = vvf;
%             STRUC(indm).VINFn_all     = vinff;
%             STRUC(indm).LEGSn_all_STM = legnSTM;
%             STRUC(indm).VASn_all_STM  = vvfSTM;
%             STRUC(indm).VINFn_all_STM = vinffSTM;
            
            % --> MODP (from DEFECTS)
            [legtosav, vvftosav, vinfftosav] = INPUT.costFunc1_MODP(legn, vvf, vinff);

            % --> SAVE
            STRUC(indm).LEGSn = legtosav;
            STRUC(indm).VASn  = vvftosav;
            STRUC(indm).VINFn = vinfftosav;

%             % --> MODP (from STM) and save
%             [legtosavSTM, vvftosavSTM, vinfftosavSTM] = INPUT.costFunc1_MODP(legnSTM, vvfSTM, vinffSTM);
%             STRUC(indm).LEGSnSTM                      = legtosavSTM;
%             STRUC(indm).VASnSTM                       = vvftosavSTM;
%             STRUC(indm).VINFnSTM                      = vinfftosavSTM;

        end
                
    end

else % --> solve SEQUENTIAL
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

        % --> DYNAMIC PROGRAMMING 
        indxs   = find(LEGSnext(:,end-1) == pl1 & LEGSnext(:,end) == t1);
        legprev = LEGSnext(indxs,:);
        vasprev = VASnext(indxs,:);
        
        % --> DEFECTS
        [legn, vvf, vinff] = computeDefects_DP(legprev, vasprev, pl2, t2, vv1, vv2, vvd, vva, dvLim, muPL, rpmin);

        % --> PRUNING (on DEFECTS model)
        [legn, vvf, vinff] = wrap_Pruning_DP(legn, vvf, vinff, INPUT);

        if ~isempty(legn)

%             % --> compute the STM-DSM (after the pruning on DEFECTS model)
%             [~,loc]                     = ismember(legn(:,1:end-3),legprev,'rows');
%             [legnSTM, vvfSTM, vinffSTM] = STM_derivation(legn, vvf, vinff, vv1, rr1, vasprev(loc, :), legprev(loc, :));
%             % --> save the legs        
%             STRUC(indm).LEGSn_all     = legn;
%             STRUC(indm).VASn_all      = vvf;
%             STRUC(indm).VINFn_all     = vinff;
%             STRUC(indm).LEGSn_all_STM = legnSTM;
%             STRUC(indm).VASn_all_STM  = vvfSTM;
%             STRUC(indm).VINFn_all_STM = vinffSTM;
            
            % --> MODP (from DEFECTS)
            [legtosav, vvftosav, vinfftosav] = INPUT.costFunc1_MODP(legn, vvf, vinff);

            % --> SAVE
            STRUC(indm).LEGSn = legtosav;
            STRUC(indm).VASn  = vvftosav;
            STRUC(indm).VINFn = vinfftosav;

%             % --> MODP (from STM) and save
%             [legtosavSTM, vvftosavSTM, vinfftosavSTM] = INPUT.costFunc1_MODP(legnSTM, vvfSTM, vinffSTM);
%             STRUC(indm).LEGSnSTM                      = legtosavSTM;
%             STRUC(indm).VASnSTM                       = vvftosavSTM;
%             STRUC(indm).VINFnSTM                      = vinfftosavSTM;

        end
                
    end

end

% --> extract info from STRUC
LEGSn = cell2mat({STRUC.LEGSn}');
VASn  = cell2mat({STRUC.VASn}');
VINFn = cell2mat({STRUC.VINFn}');

end
