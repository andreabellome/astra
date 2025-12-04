function param = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, Nrev, idcentral, useParallel)

% INPUT:
% 
% - m0          : initial mass                                        [kg]
% - tof         : time of flight                                      [s]
% - state1      : initial state                                       [km],[km/s]
% - state2      : final state                                         [km],[km/s]
% - Tmax        : max. thrust                                         [N]
% - Isp         : specific impulse                                    [s]
% - g0          : Earth acceleration at sea level (default: 9.80665)  [m/s2]
% - Nrev        : number of revolutions (default: 0)
% - idcentral   : ID of the central body (default: 1, i.e., Sun)
% - useParallel : if true, uses parallel for fsolve (default: false)
%
% OUTPUT:
%
% - param : structure with all the info needed for running the solver
%
% -------------------------------------------------------------------------

if nargin == 6
    g0          = 9.8065;
    Nrev        = 0;
    idcentral   = 1;
    useParallel = false;
elseif nargin == 7
    Nrev      = 0;
    idcentral = 1;
    useParallel = false;
elseif nargin == 8
    idcentral   = 1;
    useParallel = false;
elseif nargin == 9
    useParallel = true;
end

%% --> SCALING

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

%% --> SOLVER

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

param.full                                  = false;     

%% --> STATES

param.Nrev = Nrev;

param.state1 = state1;
param.state2 = state2;

% --> apply scaling to initial state
tStart    = 0;
tEnd      = tof/param.TU;
initState = [ state1(1:3)./param.AU, state1(4:6)./param.LU.*param.TU ];
finState  = [ state2(1:3)./param.AU, state2(4:6)./param.LU.*param.TU ];

% --> convert cartesian to MEE
initState = car2mee(initState, param.muScl);
finState  = car2mee(finState, param.muScl);

param.tStart = tStart;
param.tEnd   = tEnd;

param.x0 = initState;
param.xf = finState ;

while param.xf(end) < param.x0(end)
    param.xf(end) = param.xf(end) + 2*pi;
end

param.xf(end) = param.xf(end) + 2*param.Nrev*pi;

%% --> SMOOTHING

% --> smoothing parameters
param.plot    = false; % --> decide if you want to plot thrust w.r.t. the rho      
param.rhoLim  = 0.0001;
param.rho     = 1;
param.gamma   = 0.75;
param.iterMax = 5;
param.tol     = 1e-8;

param.mf         = NaN;
param.CheckESAdb = false; % --> compare with ESA database

end
