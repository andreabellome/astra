
close all; clc;

% --> extract ASTRA solution
astraSolution.path      = path;             % --> ASTRA solution
astraSolution.revs      = revs;             % --> revolutions' options from ASTRA solution
astraSolution.res       = res;              % --> resonances' options from ASTRA solution
astraSolution.vdep_free = vdep_free;        % --> v-infinity provided by launcher 'for free' [km/s]
astraSolution.varr_free = 0;                % --> arrival infinity velocity 'for free' [km/s]

% --> define low-thrust parameters
lowThrustParameters.Tmax        = 0.6;      % --> max. thrust                       [N]
lowThrustParameters.Isp         = 3000;     % --> specific impulse                  [s]
lowThrustParameters.m0          = 2000;     % --> initial mass                      [kg]    
lowThrustParameters.g0          = 9.80665;  % --> Earth acceleration at sea level   [m/s]

% --> further optional parameters for optimal control solution
lowThrustParameters.gamma       = 0.5;      % --> discount factor for the smoothing parameter (default is 0.5)
lowThrustParameters.plot        = true;     % --> this plots the thrust evolution over time for different rho (default is false)
lowThrustParameters.useParallel = true;     % --> if true, uses parallel for fsolve (default is false)

% --> find low-thrust transfers from ASTRA solution      
LT_SOLUTION = lowThrustFromASTRASolution( astraSolution, lowThrustParameters, INPUT.idcentral, INPUT.customEphemerides );

%%

% --> plot the final output
close all; clc;

planets = [struc.idD, struc(end).idA];
t0      = struc(1).tD;
tend    = struc(end).tA;

[figTRAJ, figMASS, figTHRmag] = wrapPlotLTFull(LT_SOLUTION, param);

figure(figTRAJ);
plotPLTS_tt(planets, t0, tend, INPUT.idcentral, INPUT.customEphemerides, 1, [], [], 0.5, '--');
