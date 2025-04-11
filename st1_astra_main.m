
clearDeleteAdd; % --> !!! ONLY CALL IT ONCE FOR SPEED

%% --> input section

% --> clear INPUT and define new ones
try clear INPUT; catch; end; clc;

% --> sequence to be optimized
INPUT.idcentral = 1; % --> central body (Sun in this case)
% seq = [ 3 2 3 4 4 4 5 ];   res = [ 2 1 4 3 1 5 ];
seq = [ 3 2 3 4 3 5 ];   res = [  ];

% % seq = [ 3 2 3 4 3 5 ];   res = [  ];
% seq = [ 3 2 2 1 1 1 1 ]; res = [];

%%%%%%%%%% multi-rev. options %%%%%%%%%%
maxrev                        = 0;                                                          % --> max. number of revolutions (round number)
chosenRevs                    = differentRuns_v2(seq, maxrev);                              % --> generate successive runs
[INPUT.chosenRevs, INPUT.res] = processResonances(chosenRevs, res);                         % --> process the resonances options
[INPUT.chosenRevs]            = maxRevOuterPlanets(seq, INPUT.chosenRevs, INPUT.idcentral); % --> only zero revs. on outer planets
%%%%%%%%%% multi-rev. options %%%%%%%%%%

%%%%%%%%%% set departing options %%%%%%%%%%
t0 = date2mjd2000([2023 1 1 0 0 0]); % --> initial date range (MJD2000)
tf = t0 + 1*365.25;                  % --> final date range (MJD2000)
dt = 3;                            % --> step size (days)
INPUT.depOpts = [t0 tf dt];
%%%%%%%%%% set departing options %%%%%%%%%%

%%%%%%%%%% set options %%%%%%%%%%
INPUT.opt      = 1;          % --> (1) is for SODP, (2) is for MODP, (3) is for DATES, (4) is for YEARS - MODP
INPUT.vInfOpts = [0 5];      % --> min/max departing infinity velocities (km/s)
INPUT.dsmOpts  = [2 Inf];    % --> max defect DSM, and total DSMs (km/s)
INPUT.plot     = [1 1];      % --> plot(1) for Pareto front, plot(2) for best traj. DV
INPUT.parallel = true;       % --> put true for parallel, false otherwise
INPUT.tstep    = dt;         % --> step size for Time of flight            
%%%%%%%%%% set options %%%%%%%%%%

% indxs                       = find(INPUT.chosenRevs(:,1) > 21);
% INPUT.chosenRevs(indxs,:)   = [];
% INPUT.vInfLim               = [ [0 4]; [0 Inf]; [0 Inf]; [0 Inf]; [0 Inf]; [0 Inf]; [0 4]; ];
% INPUT.TOF_LIM               = [[100 500]; [100 500]; [100 500]; [100 400]; [100 400]; [100 400]];

%% --> optimize using ASTRA

% --> launch ASTRA optimization
OUTPUT = ASTRA_DP(seq, INPUT);

%%

% --> process the OUTPUT
processed_OUTPUT = postProcessOutputASTRA( OUTPUT );

% --> process the output for better user experience
paretoFront = process_paretoFront_structure( INPUT, processed_OUTPUT );

%% --> extract desired path and plot

close all; clc;

row  = length(paretoFront);   % --> select the path to plot
path = paretoFront(row).path;
revs = paretoFront(row).revs;
res  = paretoFront(row).res;

% --> plot the Pareto front
figPareto = plotPareto(processed_OUTPUT.PARETO_FRONT);

% --> plot the path
[figECI, STRUC, figSYN, figRSC, figVSC] = plotPath(path, INPUT.idcentral);

%%

% --> save the output
generateOutputTXT(path, INPUT.idcentral, ...
    @EphSS_cartesian, ...
    '/results_test_compare_ai', ...
    'min_tof_sol');

% --> save the figures
name = [pwd '/results/Images/figPareto_evemej.png'];
exportgraphics(figPareto, name, 'Resolution', 1200);

name = [pwd '/results/Images/figECI_evemej.png'];
exportgraphics(figECI, name, 'Resolution', 1200);

name = [pwd '/results/Images/figSYN_evemej.png'];
exportgraphics(figSYN, name, 'Resolution', 1200);

name = [pwd '/results/Images/figRSC_evemej.png'];
exportgraphics(figRSC, name, 'Resolution', 1200);

name = [pwd '/results/Images/figVSC_evemej.png'];
exportgraphics(figVSC, name, 'Resolution', 1200);

%% --> futher refine around the optimal DV-solution

INPUT.t0days  = 10;   % --> days around current solution departing epoch
INPUT.tofdays = 15;   % --> days around current solution TOFs
INPUT.dt      = 0.5;  % --> step size (days)
INPUT.revs    = revs;
INPUT.res     = res;

% --> further refine using ASTRA
OUTPUTref = refineUsingASTRApath(path, INPUT);
pathRef   = OUTPUTref.minPATH;
