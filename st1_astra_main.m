
clearDeleteAdd; % --> !!! ONLY CALL IT ONCE FOR SPEED

%% --> input section

% --> clear INPUT and define new ones
try clear INPUT; catch; end; clc;

% --> sequence to be optimized
INPUT.idcentral = 1; % --> central body (Sun in this case)
seq = [ 3 2 3 3 5 ]; res = [ 2 1 3 ];

%%%%%%%%%% multi-rev. options %%%%%%%%%%
maxrev                        = 1;                                                          % --> max. number of revolutions (round number)
chosenRevs                    = differentRuns_v2(seq, maxrev);                              % --> generate successive runs
[INPUT.chosenRevs, INPUT.res] = processResonances(chosenRevs, res);                         % --> process the resonances options
[INPUT.chosenRevs]            = maxRevOuterPlanets(seq, INPUT.chosenRevs, INPUT.idcentral); % --> only zero revs. on outer planets
%%%%%%%%%% multi-rev. options %%%%%%%%%%

%%%%%%%%%% set departing options %%%%%%%%%%
t0 = date2mjd2000([2023 1 1 0 0 0]); % --> initial date range (MJD2000)
tf = t0 + 1*365.25;                  % --> final date range (MJD2000)
dt = 2.5;                            % --> step size (days)
INPUT.depOpts = [t0 tf dt];
%%%%%%%%%% set departing options %%%%%%%%%%

%%%%%%%%%% set options %%%%%%%%%%
INPUT.opt      = 2;          % --> (1) is for SODP, (2) is for MODP, (3) is for DATES, (4) is for YEARS - MODP
INPUT.vInfOpts = [0 5];      % --> min/max departing infinity velocities (km/s)
INPUT.dsmOpts  = [1 Inf];    % --> max defect DSM, and total DSMs (km/s)
INPUT.plot     = [1 1];      % --> plot(1) for Pareto front, plot(2) for best traj. DV
INPUT.parallel = true;       % --> put true for parallel, false otherwise
INPUT.tstep    = dt;         % --> step size for Time of flight            
%%%%%%%%%% set options %%%%%%%%%%

%% --> optimize using ASTRA

% --> launch ASTRA optimization
OUTPUT = ASTRA_DP(seq, INPUT);

%% --> extract desired path and plot

close all; clc;

% --> extract path from Pareto front
[path, revs, res] = pathfromPF(OUTPUT);

% --> plot the Pareto front
figPareto = plotPareto(OUTPUT(1).ovPF);

% --> plot the path
[figECI, STRUC, figSYN, figRSC, figVSC] = plotPath(path, INPUT.idcentral);

% --> save the output
generateOutputTXT(path, INPUT.idcentral, './results');

% --> save the figures
name = [pwd '/results/Images/figPareto.png'];
exportgraphics(figPareto, name, 'Resolution', 1200);

name = [pwd '/results/Images/figECI.png'];
exportgraphics(figECI, name, 'Resolution', 1200);

name = [pwd '/results/Images/figSYN.png'];
exportgraphics(figSYN, name, 'Resolution', 1200);

name = [pwd '/results/Images/figRSC.png'];
exportgraphics(figRSC, name, 'Resolution', 1200);

name = [pwd '/results/Images/figVSC.png'];
exportgraphics(figVSC, name, 'Resolution', 1200);

%% --> futher refine around the optimal DV-solution

INPUT.t0days  = 10;   % --> days around current solution departing epoch
INPUT.tofdays = 15;   % --> days around current solution TOFs
INPUT.dt      = 0.5;  % --> step size (days)
INPUT.revs    = revs;
INPUT.res     = res;

% --> further refine using ASTRA
OUTPUTref = refineUsingASTRApath(path, INPUT);
