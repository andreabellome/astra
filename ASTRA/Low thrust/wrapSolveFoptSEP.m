function LTsol = wrapSolveFoptSEP( param )

% DESCRIPTION
% This function solves the fuel-optimal low-thrust problem
% using Solar Electric Propulsion (SEP). The thrust profile can be seen in
% the function func_thrust_fitted.m
%
% INPUT:
% - param: structure with the required parameters from
%          processDataAndWriteParam.m
%          additional REQUIRED parameters are:
%          - n_engines     : number of engines
%          - thrust_max_N  : reference thrust for each engine [N] (e.g.,
%          0.255 N)
%          - epsilon       : smooth factor for the thrust profile (by
%          default 0.002)
%          - initial_guess : initial guess on the co-states (by default, a
%          random guess is provided). It is STRONGLY RECOMMENDED to solve
%          first a LT problem with max. thrust using wrapSolveFopt.m and
%          then to use that solution as initial guess for the SEP problem.
%
% OUTPUT:
% - LTsol: structure with the following fields:
%           - transfer : Matrix containing the processed trajectory data with the 
%              following columns:
%              [time (days), position (km), velocity (km/s), mass (kg), 
%               thrust magnitude (N), thrust vector (N)].
%           - lambdas: initial conditions for the co-states for
%           fuel-optimal problem using SEP
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

if ~isfield(param, 'initial_guess')
    warning('No initial guess provided. Trying with random guess. It is suggested to use wrapSolveFopt as guess');
    initiallamba = [ 1*rand(1,6), 10];
else
    initiallamba = param.initial_guess;
end

if ~isfield(param, 'epsilon')
    param.epsilon = 0.002;
end

iter        = 1;
disp_name   = true;

% --> START: homotopy approach --> loop until you find a satisfactory solution (over rho --> decreasing)
while param.rho >= param.rhoLim
    
    try
        param.rho                  = param.rho * param.gamma;
        fprintf( "Computing smooth profile Rho: %f (iter number: %d) \n", [param.rho, iter]);
        
        [initiallamba, Fsol] = ...
                fsolve(@(lambda0) propagateState_SEP(lambda0, ...
                @propagateFopt_SEP_MEXIFY_mex, param), ...
                initiallamba, param.fsolveoptions);
    
        if max(abs(Fsol)) <= param.tol
            param.odeoptions.MaxStep    = 0.5;

            [time, states]              = ode45(@(t,x) propagateFopt_SEP_MEXIFY_mex(t, x, ...
                                            [ param.muScl, ...
                                            param.TmaxScl, ...
                                            param.IspScl, ...
                                            param.g0Scl, ...
                                            param.rho, ...
                                            param.LU, param.TU, param.MU, ...
                                            param.thrust_max_N, param.n_engines,...
                                            param.epsilon,...
                                            ]),...
                                            [param.tStart,param.tEnd],...
                                            [param.x0, param.m0Scl, initiallamba], ...
                                            param.odeoptions);

            fprintf( "Final mass: %f kg \n", states(end,7)*param.MU );
            
            % --> START: plot progressively smooth profiles
            if param.plot == true
                transfer = postProcessLT_SEP( time, states, @propagateFopt_SEP_MEXIFY_mex, param );
                hold on;
                plotLT_Th( transfer, param, 1 );

                dist_to_sun_au = vecnorm(transfer(:,2:4)')'./param.AU;
                thrust_profile = func_thrust_fitted( dist_to_sun_au, param);
                if disp_name
                    plot( transfer(:,1), thrust_profile, '--', 'LineWidth', 2, 'DisplayName', 'Available thrust' );
                    disp_name = false;
                else
                    plot( transfer(:,1), thrust_profile, '--', 'LineWidth', 2, 'HandleVisibility', 'off' );
                end
            end
            % --> END: plot progressively smooth profiles
            
            iter = iter + 1;

        else
            Fsol = 1e99;
            flag = -1;
        end
    catch
        Fsol = 1e99;
        flag = -1;
    end

end
% --> END: homotopy approach --> loop until you find a satisfactory solution (over rho --> decreasing)


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

    % --> START: final propagation
    param.odeoptions.MaxStep    = 0.5;

    [time, states]              = ode45(@(t,x) propagateFopt_SEP_MEXIFY_mex(t, x, ...
                                            [ param.muScl, ...
                                            param.TmaxScl, ...
                                            param.IspScl, ...
                                            param.g0Scl, ...
                                            param.rho, ...
                                            param.LU, param.TU, param.MU, ...
                                            param.thrust_max_N, param.n_engines,...
                                            param.epsilon,...
                                            ]),...
                                            [param.tStart,param.tEnd],...
                                            [param.x0, param.m0Scl, initiallamba], ...
                                            param.odeoptions);
    % --> END: final propagation
    
    massScl         = states(:,7);
    mass            = massScl*param.MU; % --> mass evolution
    transfer        = postProcessLT_SEP( time, states, @propagateFopt_SEP_MEXIFY_mex, param );
    
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

end


end