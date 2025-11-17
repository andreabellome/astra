
clearDeleteAdd; % --> !!! ONLY CALL IT ONCE FOR SPEED

%% --> input section

% --> clear INPUT and define new ones
try clear INPUT; catch; end; clc;

% --> sequence to be optimized
INPUT.idcentral = 1; 
seq = [ 3 2 2 3 5 6 ]; res = [  ];

%%%%%%%%%% multi-rev. options %%%%%%%%%%
maxrev                        = 0;                                         % --> max. number of revolutions (round number)
chosenRevs                    = differentRuns_v2(seq, maxrev);             % --> generate successive runs
[INPUT.chosenRevs, INPUT.res] = processResonances(chosenRevs, res);        % --> process the resonances options
[INPUT.chosenRevs]            = maxRevOuterPlanets(seq, INPUT.chosenRevs); % --> only zero revs. on outer planets
%%%%%%%%%% multi-rev. options %%%%%%%%%%

%%%%%%%%%% set departing options %%%%%%%%%%
t0 = date2mjd2000([1997 1 1 0 0 0]); % --> initial date range for launch (MJD2000)
tf = t0 + 1*365.25;                  % --> final date range for launch (MJD2000)
dt = 3;                              % --> step size in launch window (days)
INPUT.depOpts = [t0 tf dt];
%%%%%%%%%% set departing options %%%%%%%%%%

%%%%%%%%%% set options %%%%%%%%%%
INPUT.opt      = 1;          % --> (1) is for SODP, (2) is for MODP, (3) is for DATES, (4) is for YEARS - MODP
INPUT.vInfOpts = [3 5];      % --> min/max departing infinity velocities (km/s)
INPUT.dsmOpts  = [2 Inf];    % --> max defect DSM, and total DSMs (km/s)
INPUT.plot     = [1 1];      % --> plot(1) for Pareto front, plot(2) for best traj. DV
INPUT.parallel = true;       % --> put true for parallel, false otherwise
INPUT.tstep    = dt;         % --> step size for Time of flight            
%%%%%%%%%% set options %%%%%%%%%%

% --> custom input
INPUT.TOF_LIM  = [ 30 400; 100 470; 30 400; 400 2000; 1000 6000 ];

%% --> optimize using ASTRA

% --> launch ASTRA optimization
OUTPUT = ASTRA_DP(seq, INPUT);

%%

% --> process the OUTPUT
processed_OUTPUT = postProcessOutputASTRA( OUTPUT );

% --> process the output for better user experience
paretoFront = process_paretoFront_structure( INPUT, processed_OUTPUT );

[ allSolutions ] = test_process_all_solutions( INPUT, processed_OUTPUT );
[~,index]        = sortrows([allSolutions.vinfArr; allSolutions.vinfDep].');
allSolutions     = allSolutions(index);

%%

row  = 2;
path = allSolutions(row).path;
revs = allSolutions(row).revs;
res  = allSolutions(row).res;

%% --> extract desired path and plot

close all; clc;

row  = 129; length(paretoFront);   % --> select the path to plot
path = paretoFront(row).path;
revs = paretoFront(row).revs;
res  = paretoFront(row).res;

% --> plot the Pareto front
figPareto = plotPareto(processed_OUTPUT.PARETO_FRONT);

% --> plot the path
[figECI, STRUC] = plotPath(path, INPUT.idcentral);

%%

% --> save the output
generateOutputTXT(path, INPUT.idcentral, ...
    @EphSS_cartesian, ...
    '/results_test_compare_ai', ...
    'min_tof_sol');

% --> save the figures
name = [pwd '/results/Images/figPareto_evemmmj.png'];
exportgraphics(figPareto, name, 'Resolution', 1200);

name = [pwd '/results/Images/figECI_evemmmj.png'];
exportgraphics(figECI, name, 'Resolution', 1200);

name = [pwd '/results/Images/figSYN_evemmmj.png'];
exportgraphics(figSYN, name, 'Resolution', 1200);

name = [pwd '/results/Images/figRSC_evemmmj.png'];
exportgraphics(figRSC, name, 'Resolution', 1200);

name = [pwd '/results/Images/figVSC_evemmmj.png'];
exportgraphics(figVSC, name, 'Resolution', 1200);

%% --> futher refine around the optimal DV-solution

INPUT.t0days  = 10;   % --> days around current solution departing epoch
INPUT.tofdays = 15;   % --> days around current solution TOFs
INPUT.dt      = 0.5;  % --> step size (days)
INPUT.revs    = revs;
INPUT.res     = res;

% --> further refine using ASTRA
OUTPUTref           = refineUsingASTRApath(path, INPUT);
processed_OUTPUTref = postProcessOutputASTRA( OUTPUTref );
paretoFrontref      = process_paretoFront_structure( INPUT, processed_OUTPUTref );

pathRef   = OUTPUTref.minPATH;
