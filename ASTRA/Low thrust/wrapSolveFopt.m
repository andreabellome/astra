function LTsol = wrapSolveFopt( param )

st = 1;

% DESCRIPTION
% This function solves the fuel-optimal low-thrust problem.
%
% INPUT:
% - param: structure with the required parameters from
% processDataAndWriteParam.m
%
% OUTPUT:
% - LTsol: structure with the following fields:
%           - transfer : Matrix containing the processed trajectory data with the 
%              following columns:
%              [time (days), position (km), velocity (km/s), mass (kg), 
%               thrust magnitude (N), thrust vector (N)].
%           - lambdas: initial conditions for the co-states for
%           fuel-optimal problem
%           - Tmax    : max. thrust [N]
%           - Isp     : specific impulse [s]
%           - g0      : gravitational acceleration at sea level [m/s2]
%           - m0      : initial mass [kg]
%           - mf      : final mass [kg]
%           - tof     : time of flight [days]
%           - DV      : DV of the low-thrust transfer [km/s]
%           - param   : structure with relevant parameters for the solution
%           - success : boolean to check if the solver has succeeded or not
% 
% -------------------------------------------------------------------------

if param.plot == true
    figure('Color', [1 1 1]);
    hold on; grid on;
end

% --> start: STEP 0 --> first try energy-optimal guess with zero guess
fprintf( "Computing energy-optimal profile \n" );
initiallamba                = [zeros(1,7)];
[initiallamba, Fsol, flag]  = fsolve(@(lambda0)...
    propagateState_vA(lambda0, @propagateEopt_MEXIFY_mex,...
    param),initiallamba,param.fsolveoptions);
initiallambaEOPT = initiallamba;

if max(abs(Fsol)) <= param.tol
    
    param.odeoptions.MaxStep    = 0.5;
        [time, states]              = ode45(@(t,x) propagateEopt_MEXIFY_mex(t, x, ...
                                        [ param.muScl, param.TmaxScl, param.IspScl, param.g0Scl, param.rho ]),...
                                        [param.tStart,param.tEnd],...
                                        [param.x0, param.m0Scl, initiallamba], ...
                                        param.odeoptions);

    fprintf( "Final mass from energy-optimal: %f kg \n", states(end,7)*param.MU );

    if param.plot == true
        transfer = postProcessLT( time, states, @propagateEopt_MEXIFY_mex, param );
        hold on;
        plotLT_Th( transfer, param, 1 );
    end

end

if max(abs(Fsol)) <= param.tol
    
    pm = param;
    pm.fsolveoptions.MaxFunctionEvaluations = 2e3;

    param.rho = 0.1;
    fprintf( "Computing smooth profile Rho: %f, at iteration: %d \n", [param.rho, 0] );
    [initiallamba, Fsol, flag] = ...
            fsolve(@(lambda0) propagateState_vA(lambda0, @propagateFopt_MEXIFY_mex, param), ...
            initiallamba, pm.fsolveoptions);

    if max(abs(Fsol)) > param.tol
        initiallamba = initiallambaEOPT; % --> re-initialize the search
        param.rho = 0.5;
        fprintf( "Computing smooth profile Rho: %f, at iteration: %d \n", [param.rho, 0] );
        [initiallamba, Fsol, flag] = ...
                fsolve(@(lambda0) propagateState_vA(lambda0, @propagateFopt_MEXIFY_mex, param), ...
                initiallamba, pm.fsolveoptions);
    end

    if max(abs(Fsol)) <= param.tol

        param.odeoptions.MaxStep    = 0.5;
        [time, states]              = ode45(@(t,x) propagateFopt_MEXIFY_mex(t, x, ...
                                        [ param.muScl, param.TmaxScl, param.IspScl, param.g0Scl, param.rho ]),...
                                        [param.tStart,param.tEnd],...
                                        [param.x0, param.m0Scl, initiallamba], ...
                                        param.odeoptions);

        fprintf( "Final mass: %f kg \n", states(end,7)*param.MU );

        if param.plot == true
            transfer = postProcessLT( time, states, @propagateFopt_MEXIFY_mex, param );
            hold on;
            plotLT_Th( transfer, param, 1 );
        end
    end

end
% --> end: STEP 0 --> first try energy-optimal guess with zero guess

% --> start: STEP 0.1 --> then try random guess and rho = 1 and fuel-optimal
if max(abs(Fsol)) > param.tol
    param.rho = 1;
    pm = param;
    pm.fsolveoptions.MaxFunctionEvaluations = 8e3; % --> so not to stress too much in difficult cases
    fprintf( "Computing smooth profile Rho: %f, at iteration: %d \n", [param.rho, 0] );
    initiallamba                = [ 1*rand(1,6), 1];
    [initiallamba, Fsol, flag, OUTPUT] = ...
        fsolve(@(lambda0) propagateState_vA(lambda0, @propagateFopt_MEXIFY_mex, param), ...
        initiallamba, pm.fsolveoptions);
    
    if max(abs(Fsol)) <= param.tol
        
        param.odeoptions.MaxStep    = 0.5;
        [time, states]              = ode45(@(t,x) propagateFopt_MEXIFY_mex(t, x, ...
                                        [ param.muScl, param.TmaxScl, param.IspScl, param.g0Scl, param.rho ]),...
                                        [param.tStart,param.tEnd],...
                                        [param.x0, param.m0Scl, initiallamba], ...
                                        param.odeoptions);
    
        fprintf( "Final mass: %f kg \n", states(end,7)*param.MU );
    
        if param.plot == true
            transfer = postProcessLT( time, states, @propagateFopt_MEXIFY_mex, param );
            hold on;
            plotLT_Th( transfer, param, 1 );
        end
    end
end
% --> end: STEP 0.1 --> then try random guess and rho = 1

% --> start: STEP 1 --> loop until you find a satisfactory first guess
if max(abs(Fsol)) > param.tol
    iter = 1;
    Fsol = Inf;
    while max(abs(Fsol)) > param.tol && iter < param.iterMax
        
        try
            fprintf( "Computing smooth profile Rho: %f, at iteration: %d \n", [param.rho, iter] );
        
            initiallamba                = [ 1*rand(1,6), 1];
            [initiallamba, Fsol, flag] = ...
                fsolve(@(lambda0) propagateState_vA(lambda0, @propagateFopt_MEXIFY_mex, param), ...
                initiallamba, param.fsolveoptions);
            
            if max(abs(Fsol)) <= param.tol

                param.odeoptions.MaxStep    = 0.5;
                [time, states]              = ode45(@(t,x) propagateFopt_MEXIFY_mex(t, x, ...
                                                [ param.muScl, param.TmaxScl, param.IspScl, param.g0Scl, param.rho ]),...
                                                [param.tStart,param.tEnd],...
                                                [param.x0, param.m0Scl, initiallamba], ...
                                                param.odeoptions);
        
                fprintf( "Final mass: %f kg \n", states(end,7)*param.MU );

                if param.plot == true
                    transfer = postProcessLT( time, states, @propagateFopt_MEXIFY_mex, param );
                    hold on;
                    plotLT_Th( transfer, param, 1 );
                end
            end
            iter = iter + 1;
        catch
            
        end
    end
end
% --> end: STEP 1 --> loop until you find a satisfactory first guess

if max(abs(Fsol)) <= param.tol % flag >= 0 

    % --> then loop here until you find a satisfactory solution (over rho --> decreasing)
    while param.rho >= param.rhoLim
        try
            param.rho                  = param.rho * param.gamma;
            fprintf( "Computing smooth profile Rho: %f \n", param.rho );
            [initiallamba, Fsol, flag] = fsolve(@(lambda0) propagateState_vA(lambda0, @propagateFopt_MEXIFY_mex, param),...
                initiallamba, param.fsolveoptions);
            
            if max(abs(Fsol)) <= param.tol

                param.odeoptions.MaxStep    = 0.5;
                [time, states]              = ode45(@(t,x) propagateFopt_MEXIFY_mex(t, x, ...
                                                [ param.muScl, param.TmaxScl, param.IspScl, param.g0Scl, param.rho ]),...
                                                [param.tStart,param.tEnd],...
                                                [param.x0, param.m0Scl, initiallamba], ...
                                                param.odeoptions);
        
                fprintf( "Final mass: %f kg \n", states(end,7)*param.MU );

                if param.plot == true
                    transfer = postProcessLT( time, states, @propagateFopt_MEXIFY_mex, param );
                    hold on;
                    plotLT_Th( transfer, param, 1 );
                end
            end
        catch
            Fsol = 1e99;
            flag = -1;
        end
    end
    % --> end: loop untile the rho < rhoLim

    if max(abs(Fsol)) > param.tol % || flag < 0
        fprintf( 'No solutions found \n' );

        LTsol.transfer = NaN;
        LTsol.lambdas  = NaN.*ones( 1,7 );
        LTsol.Tmax     = param.Tmax;
        LTsol.Isp      = param.Isp;
        LTsol.g0       = param.g0;
        LTsol.m0       = param.MU;
        LTsol.mf       = NaN;
        LTsol.tof      = ((param.tEnd - param.tStart)*param.TU)/86400;
        LTsol.DV       = NaN;
        LTsol.param    = param;
        LTsol.success  = false;
    else

        fprintf( 'Solutions found \n' );
        
        % --> final propagation
        param.odeoptions.MaxStep    = 0.5;
        [time, states]              = ode45(@(t,x) propagateFopt_MEXIFY_mex(t, x, ...
            [ param.muScl, param.TmaxScl, param.IspScl, param.g0Scl, param.rho ]),...
            [param.tStart,param.tEnd],...
            [param.x0, param.m0Scl, initiallamba],param.odeoptions);
        
        massScl         = states(:,7);
        mass            = massScl*param.MU; % --> mass evolution
        transfer        = postProcessLT( time, states, @propagateFopt_MEXIFY_mex, param );
                
        LTsol.transfer = transfer;
        LTsol.lambdas  = initiallamba;
        LTsol.Tmax     = param.Tmax;
        LTsol.Isp      = param.Isp;
        LTsol.g0       = param.g0;
        LTsol.m0       = param.MU;
        LTsol.mf       = mass(end);
        LTsol.tof      = ((param.tEnd - param.tStart)*param.TU)/86400;
        LTsol.DV       = param.Isp*param.g0*log( param.MU/LTsol.mf )/1000;
        LTsol.param    = param;
        LTsol.success  = true;
        
        if isfield(param, 'CheckESAdb')

            if param.CheckESAdb == true
    
                if abs(LTsol.mf - param.mf) < 10
                    fprintf( 'Solutions found and compatible with ESA database \n' );
                else
        
                    fprintf( 'No solutions found compatible with ESA database \n' );
                    LTsol.success  = false;
        
                end
    
            end

        end

        if param.plot == true
%             legend( 'Location', 'Best' );
        end

    end
else

    LTsol.transfer = NaN;
    LTsol.lambdas  = NaN.*ones( 1,7 );
    LTsol.Tmax     = param.Tmax;
    LTsol.Isp      = param.Isp;
    LTsol.g0       = param.g0;
    LTsol.m0       = param.MU;
    LTsol.mf       = NaN;
    LTsol.tof      = ((param.tEnd - param.tStart)*param.TU)/86400;
    LTsol.DV       = NaN;
    LTsol.param    = param;
    LTsol.success  = false;

    fprintf( 'No solutions found \n' );
end

end
