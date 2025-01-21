function param = writeParamLT( Tmax, Isp, m0, g0, idcentral, useParallel)

% DESCRIPTION
% This function initializes and returns a parameter structure required for 
% low-thrust trajectory optimization. The structure contains constants, 
% scaled parameters, and solver options used in the optimization process.
%
% INPUT
% - Tmax       : Maximum thrust (N).
% - Isp        : Specific impulse (s).
% - m0         : Initial mass (kg).
% - g0         : Standard gravitational acceleration (m/s^2). Default is 9.8065.
% - idcentral  : ID of the central body (1 for Sun, other planets correspond 
%                to their respective IDs). Default is 1.
% - useParallel: Boolean to specify if parallel computation should be used. 
%                Default is false.
%
% OUTPUT
% - param : Structure containing the following fields:
%           - mu          : Gravitational parameter of the central body (km^3/s^2).
%           - AU          : Astronomical unit (km).
%           - Tmax        : Maximum thrust (N).
%           - g0          : Gravitational acceleration (m/s^2).
%           - Isp         : Specific impulse (s).
%           - day         : Duration of one day (s).
%           - year        : Duration of one year (days).
%           - useEdelbaum: Boolean for using Edelbaum approximation (default false).
%           - LU          : Length unit (km).
%           - TU          : Time unit (s).
%           - MU          : Mass unit (kg).
%           - muScl       : Scaled gravitational parameter.
%           - IspScl      : Scaled specific impulse.
%           - TmaxScl     : Scaled thrust.
%           - g0Scl       : Scaled gravitational acceleration.
%           - m0Scl       : Scaled initial mass.
%           - fsolveoptions: Options for the fsolve function, including tolerances,
%                            maximum evaluations, and parallel computation settings.
%           - odeoptions  : Options for ODE solvers, including tolerances.
%           - bvpoptions  : Options for boundary value problem solvers, including 
%                           tolerances and statistics.
%           - plots       : Boolean for enabling/disabling plots (default false).
%           - full        : Boolean for enabling/disabling full output (default false).
% -------------------------------------------------------------------------


if nargin == 3
    g0          = 9.8065;
    idcentral   = 1;
    useParallel = false;
elseif nargin == 4
    idcentral = 1;
    useParallel = false;
elseif nargin == 5
    useParallel = false;
end

mu = constants(idcentral,1);
if idcentral == 1
    AU      = 149597870.7;
else
    [~, AU] = planetConstants(idcentral);
end

param.mu    = mu;       % km3/s2
param.AU    = AU;       % km

param.Tmax  = Tmax;     % N
param.g0    = g0;       % m/s2;
param.Isp   = Isp;      % s

param.day   = 86400;
param.year  = 365.25; 

param.useEdelbaum   = false;
param.LU            = param.AU;
if idcentral == 1
    param.TU = 86400.0; % sqrt(1/param.mu*param.LU^3)% 
elseif idcentral == 3
    param.TU = 806.78557;
end
param.MU            = m0;

param.muScl         = param.mu/param.LU^3*param.TU^2; 
param.IspScl        = param.Isp/param.TU;
param.TmaxScl       = param.Tmax/param.MU/1000/param.LU*param.TU^2;
param.g0Scl         = param.g0/(1000*param.LU)*param.TU*param.TU;

param.m0Scl         = m0/param.MU;

tol                                         = 1e-13;
param.fsolveoptions                         = optimoptions('fsolve','Display','iter');
param.fsolveoptions.FunctionTolerance       = tol; 
param.fsolveoptions.StepTolerance           = tol;
param.fsolveoptions.OptimalityTolerance     = tol;
param.fsolveoptions.MaxFunctionEvaluations  = 100e3;
param.fsolveoptions.MaxIterations           = 100e3;
param.fsolveoptions.UseParallel             = useParallel;
param.odeoptions                            = odeset('RelTol', tol,'AbsTol',tol);
param.bvpoptions                            = bvpset('Stats','on','AbsTol', tol, 'RelTol', tol);

param.plots                                 = false;
param.full                                  = false;                                

end
