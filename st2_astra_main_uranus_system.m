
clearDeleteAdd; % --> !!! ONLY CALL IT ONCE FOR SPEED

%% --> input section

% --> clear INPUT and define new ones
try clear INPUT; catch; end; clc;

% --> sequence to be optimized
INPUT.idcentral = 7; % --> central body (Uranus in this case)
seq = [ 4 3 2 4 2 ]; res = [ ];

%%%%%%%%%% multi-rev. options %%%%%%%%%%
maxrev                        = 3;                                                          % --> max. number of revolutions (round number)
chosenRevs                    = differentRuns_v2(seq, maxrev);                              % --> generate successive runs
[INPUT.chosenRevs, INPUT.res] = processResonances(chosenRevs, res);                         % --> process the resonances options
[INPUT.chosenRevs]            = maxRevOuterPlanets(seq, INPUT.chosenRevs, INPUT.idcentral); % --> only zero revs. on outer planets
%%%%%%%%%% multi-rev. options %%%%%%%%%%

%%%%%%%%%% set departing options %%%%%%%%%%
t0 = date2mjd2000([2023 1 1 0 0 0]); % --> initial date range (MJD2000)
tf = t0 + 30;                  % --> final date range (MJD2000)
dt = 1;                            % --> step size (days)
INPUT.depOpts = [t0 tf dt];
%%%%%%%%%% set departing options %%%%%%%%%%

%%%%%%%%%% set options %%%%%%%%%%
INPUT.opt      = 3;          % --> (1) is for SODP, (2) is for MODP, (3) is for DATES, (4) is for YEARS - MODP
INPUT.vInfOpts = [3.5 4];    % --> min/max departing infinity velocities (km/s)
INPUT.dsmOpts  = [0.5 Inf];  % --> max defect DSM, and total DSMs (km/s)
INPUT.plot     = [1 1];      % --> plot(1) for Pareto front, plot(2) for best traj. DV
INPUT.parallel = true;       % --> put true for parallel, false otherwise
INPUT.tstep    = dt;         % --> step size for Time of flight            
%%%%%%%%%% set options %%%%%%%%%%

% --> specify custom bounds for TOFs and VINFs
INPUT.TOF_LIM = [[10 30]; [10 30]; [10 30]; [10 30]]; 
% INPUT.vInfLim = [[3.5 4]; [4 4.5]; [4 4.5]; [3.5 4]; [4 4.5]];   % --> PL1, PL2, PL3, ...   
tol = 0.1;
INPUT.vInfLim = [[3.75-tol 3.75+tol]; [4.25-tol 4.25+tol]; [4.2-tol 4.2+tol]; [3.65-tol 3.65+tol]; [4.45-tol 4.45+tol]];   % --> PL1, PL2, PL3, ...   

% --> specify custom objective functions (SODP - INPUT.opt=3 (DATES))
INPUT.costFunc1 = @(legn, vvf, vinff) costFunction1_DP_custom(legn, vvf, vinff);
INPUT.costFunc2 = @(legn, vvf, vinff) costFunction2_DP_custom(legn, vvf, vinff);

% % --> specify custom objective functions (SODP)
% INPUT.costFunc1_MODP = @(legn, vvf, vinff) costFunction1_MODP(legn, vvf, vinff);
% INPUT.costFunc2_MODP = @(legn, vvf, vinff) costFunction2_MODP(legn, vvf, vinff);

%% --> optimize using ASTRA

% --> launch ASTRA optimization
OUTPUT = ASTRA_DP(seq, INPUT);

%% --> extract desired path and plot

close all; clc;

% --> extract path from Pareto front
[path, revs, res] = pathfromPF(OUTPUT, INPUT.idcentral);

% --> plot the Pareto front
figPareto = plotPareto(OUTPUT(1).ovPF);

% --> plot the path
[figECI, STRUC, figSYN, figRSC, figVSC] = plotPath(path, INPUT.idcentral);

% --> save the output
generateOutputTXT(path, INPUT.idcentral, './results');

%% --> futher refine around the optimal DV-solution

INPUT.t0days  = 5;   % --> days around current solution departing epoch
INPUT.tofdays = 5;   % --> days around current solution TOFs
INPUT.dt      = 0.1;  % --> step size (days)
INPUT.revs    = revs;
INPUT.res     = res;

% --> further refine using ASTRA
OUTPUTref = refineUsingASTRApath(path, INPUT);
