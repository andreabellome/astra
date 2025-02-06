
clearDeleteAdd; % --> !!! ONLY CALL IT ONCE FOR SPEED



%% --> input section

% --> clear INPUT and define new ones
try clear INPUT; catch; end; clc;

% --> sequence to be optimized
INPUT.idcentral = 1; % --> central body (Sun in this case)
seq             = [ 3403148 3 ]; res = []; % --> (2006 RH120)

%%%%%%%%%% multi-rev. options %%%%%%%%%%
maxrev                        = 1;                                                          % --> max. number of revolutions (round number)
chosenRevs                    = differentRuns_v2(seq, maxrev);                              % --> generate successive runs
[INPUT.chosenRevs, INPUT.res] = processResonances(chosenRevs, res);                         % --> process the resonances options
[INPUT.chosenRevs]            = maxRevOuterPlanets(seq, INPUT.chosenRevs, INPUT.idcentral); % --> only zero revs. on outer planets
%%%%%%%%%% multi-rev. options %%%%%%%%%%

%%%%%%%%%% set departing options %%%%%%%%%%
t0 = date2mjd2000([2028 1 1 12 0 0]); % --> initial date range (MJD2000)
tf = t0 + 5*365.25;                  % --> final date range (MJD2000)
dt = 2;                            % --> step size (days)
INPUT.depOpts = [t0 tf dt];
%%%%%%%%%% set departing options %%%%%%%%%%

%%%%%%%%%% set options %%%%%%%%%%
INPUT.opt      = 3;          % --> (1) is for SODP, (2) is for MODP, (3) is for DATES, (4) is for YEARS - MODP
INPUT.vInfOpts = [0 Inf];      % --> min/max departing infinity velocities (km/s)
INPUT.dsmOpts  = [1 Inf];    % --> max defect DSM, and total DSMs (km/s)
INPUT.plot     = [1 1];      % --> plot(1) for Pareto front, plot(2) for best traj. DV
INPUT.parallel = false;       % --> put true for parallel, false otherwise
INPUT.tstep    = dt;         % --> step size for Time of flight            
%%%%%%%%%% set options %%%%%%%%%%

% --> specify custom bounds for TOFs and VINFs
INPUT.TOF_LIM = [[30 500]];
INPUT.vInfLim = [ 0 Inf; 0 Inf ]; % --> PL1, PL2, PL3, ...   

%%

% --> load custom ephemerides
MICE_path = './MICE_TOOLBOX' ;
addpath(genpath(MICE_path)); % --> always include this

% --> load the kernels
cspice_furnsh( { [MICE_path '/' num2str(max(seq)) '.bsp'], [MICE_path '/de435.bsp'], [MICE_path '/naif0012.tls'] } )

% --> define custom ephemerides
INPUT.customEphemerides = @EphSS_NEOs;

%% --> optimize using ASTRA

% --> launch ASTRA optimization
OUTPUT = ASTRA_DP(seq, INPUT);

%% --> extract desired path and plot

close all; clc;

% --> process the OUTPUT
[processed_OUTPUT] = postProcessOutputASTRA( OUTPUT );
path = processed_OUTPUT.minPATH;
revs = processed_OUTPUT.minREVS;
res  = processed_OUTPUT.res;
cost = processed_OUTPUT.minCOST;
tofy = processed_OUTPUT.minTOFY;

% --> extract path from Pareto front
[path, revs, res] = pathfromPF(OUTPUT, 1, 1, [], INPUT.customEphemerides);

% --> plot the Pareto front
figPareto = plotPareto(OUTPUT(1).ovPF);

% --> plot the path
[figECI, STRUC, figSYN, figRSC, figVSC] = plotPath(path, INPUT.idcentral, INPUT.customEphemerides);

% % --> save the output
% generateOutputTXT(path, INPUT.idcentral, INPUT.customEphemerides, './results');

% % --> save the figures
% name = [pwd '/results/Images/figPareto.png'];
% exportgraphics(figPareto, name, 'Resolution', 1200);
% 
% name = [pwd '/results/Images/figECI.png'];
% exportgraphics(figECI, name, 'Resolution', 1200);
% 
% name = [pwd '/results/Images/figSYN.png'];
% exportgraphics(figSYN, name, 'Resolution', 1200);
% 
% name = [pwd '/results/Images/figRSC.png'];
% exportgraphics(figRSC, name, 'Resolution', 1200);
% 
% name = [pwd '/results/Images/figVSC.png'];
% exportgraphics(figVSC, name, 'Resolution', 1200);

%% --> find low-thrust trajectories

Tmax        = 0.15;        % --> max. thrust                       [N]
Isp         = 3000;       % --> specific impulse                  [s]
m0          = 750;       % --> initial mass                      [kg]           
g0          = 9.80665;    % --> Earth acceleration at sea level   [m/s]
useParallel = true;       % --> if true, uses parallel for fsolve

% --> post-process the path
vinfFree = 1.5;
struc    = postProcessPathASTRA_lowThrust(path, vinfFree, 0, ...
                    INPUT.idcentral, INPUT.customEphemerides);

inds   = 1;
state1 = struc(inds).xxDtar;
state2 = struc(inds).xxAtar;
tof    = ( struc(inds).tA - struc(inds).tD ) * 86400;
dvD    = struc(inds).dvD;
dvA    = struc(inds).dvA;
accel  = ( dvD + dvA )*1000/tof;
revopt = rev2RevOpt(revs, res, inds);

if accel * 1.5 <= Tmax/m0

    % --> initialise the parameters
    param        = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, revopt(1), INPUT.idcentral, useParallel);
    param.plot   = true;    % --> this plots the thrust evolution over time for different rho (default is false)
    param.gamma  = 0.5;
    
    % --> solve the problem
    LTsol = wrapSolveFopt( param );
    
    % --> plot the solution
    transfer = LTsol.transfer;
    [figTRAJ, figMASS, figTHRmag] = plotLT( transfer, param );
    
    figure(figTRAJ);
    colors = cool(2);
    plotPLTS_tt(3, 0, 0+365.25, 1, INPUT.customEphemerides, 1, 'k', {'Earth'}, 0.5, '--');  % --> plot the Earth
    plotPLTS_tt(struc(inds).idA, t0, t0+365.25, 1, INPUT.customEphemerides, 1, 'red', {num2str(struc(inds).idA)}, 0.5, '--');  % --> plot the asteroid

else
    
    fprintf( 'Thrust system is not enough \n' );

end

%% --> futher refine around the optimal DV-solution

INPUT.t0days  = 10;   % --> days around current solution departing epoch
INPUT.tofdays = 15;   % --> days around current solution TOFs
INPUT.dt      = 0.5;  % --> step size (days)
INPUT.revs    = revs;
INPUT.res     = res;

% --> further refine using ASTRA
OUTPUTref = refineUsingASTRApath(path, INPUT);
