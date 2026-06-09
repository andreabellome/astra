
clear all; close all; clc; format long g;

MICE_path           = 'C:/Users/Andrea/Documents/GitHub/astra/MICE_TOOLBOX';
MICE_kernel_path    = 'C:/Users/Andrea/Documents/GitHub/astra/MICE_TOOLBOX/mice/Kernel';

cspice_furnsh([MICE_path '/data.mk']);
cspice_furnsh([MICE_kernel_path '/20000001.bsp']); % --> load the object ephemerides

mu        = 132724487690;
AU        = 149597870.7;
idcentral = 1;

INPUT.customEphemerides = @EphSS_from_mice_workaround;
customEphemerides       = INPUT.customEphemerides;

%% --> SEP system details

% --> SEP engines
Tmax         = 1050e-3; % --> max. thrust at 1 AU per engine [N]
thrust_max_N = 255e-3;  % --> reference thrust of the engine [N]
n_engines    = 2;       % --> number of engines

Isp          = 3500;   % --> specific impulse [s]
m0           = 2500;   % --> initial mass [kg]
g0           = 9.81;   % --> Earth gravity acceleration at sea level [m/s2]

%% --> INPUT

state1  = [-1.489727830828299e+08	-4.665250926123583e+06	2.168235369026661e-09	0.360503758426933	-34.297829137740329	1.468637746562255];
state2  = [8.871969005111149e+07	2.078180920712900e+08	2.133574152175179e+06	-24.162762129561482	1.388369381798645	0.022320702091613];
tof_sec = ( 538.064869891574 ) * 86400;
Nrev    = 0;

%% --> STEP 1: first solve a fuel-optimal problem at max. thrust (no SEP)

% --> initialise the (temporary) parameters

Tmax_temp            = 0.3;  % --> max. thrust for the fuel-optimal problem [N] - this is an heuristic and the user should select this by trial and error
useParallel          = true; % --> if true, uses parallel for fsolve

param_temp           = processDataAndWriteParam(m0, tof_sec, state1, state2, Tmax_temp, Isp, g0, Nrev, idcentral, useParallel);
param_temp.gamma     = 0.5;
param_temp.rhoGuess1 = 0.5;
param_temp.rhoLim    = 0.0005;

% --> solve the problem
LTsol = wrapSolveFopt( param_temp );

%% --> STEP 2: now solve a fuel-optimal problem with SEP (thrust varies with distance from Sun)

% --> initialise the parameters for the SEP
param = processDataAndWriteParam(m0, tof_sec, state1, state2, Tmax, Isp, g0, Nrev, idcentral, useParallel);

param.thrust_max_N  = thrust_max_N;
param.n_engines     = n_engines;
param.epsilon       = 0.002; % --> this is to smooth the non-differentiable thrust profile 
                             % (the lower it is, the closer to the true motor, 
                             % the harder the problem is to be solved)
param.initial_guess = LTsol.lambdas; % --> use the previous solution as guess for the SEP one
param.rho           = 1; 
param.rhoLim        = 0.001;
param.gamma         = 0.9; 

% --> solve the SEP transfer
LTsol_SEP = wrapSolveFoptSEP( param );

%% --> STEP 3: plot

transfer_1 = LTsol_SEP(1).transfer;
TRANSFER            = transfer_1;

dist_to_sun_au  = vecnorm(TRANSFER(:,2:4)')'./AU;
thrust_profile  = func_thrust_fitted( dist_to_sun_au, param);

[figTRAJ, figMASS, figTHRmag] = plotLT( TRANSFER, param, 0 );

figure(figTHRmag);
plot( TRANSFER(:,1), thrust_profile, '--', 'LineWidth', 2, 'DisplayName', 'Available thrust' );

yyaxis right;
ylabel('Distance to Sun [AU]');
plot( TRANSFER(:,1), dist_to_sun_au, 'LineWidth', 2, 'HandleVisibility', 'off' );

lgd           = legend('Location', 'southeast');
lgd.String{1} = 'Used thrust';

figure(figTRAJ);
plotPLTS_tt([3 4], ...
    0, 365.25*4, ...
    idcentral, ...
    customEphemerides, ...
    1, [], [], 1, '-');

plot3( state1(:,1)./AU, state1(:,2)./AU, state1(:,3)./AU, 'o', ...
    'MarkerSize', 8, ...
    'MarkerEdgeColor', 'black', ...
    'MarkerFaceColor', 'red', ...
    'HandleVisibility', 'off');

axes_dim = 25;

plotFontSizeAxesDim(axes_dim, axes_dim, figTRAJ, findall(figTRAJ, 'Type', 'axes'));
plotFontSizeAxesDim(axes_dim, axes_dim, figTHRmag, findall(figTHRmag, 'Type', 'axes'));
plotFontSizeAxesDim(axes_dim, axes_dim, figMASS, findall(figMASS, 'Type', 'axes'));

% Place the labels
text(state1(:,1)./AU,  state1(:,2)./AU + 0.1, 'Earth', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
    'FontSize', 20, 'FontWeight', 'bold');

text(state2(:,1)./AU,  state2(:,2)./AU + 0.1, 'Mars', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
    'FontSize', 20, 'FontWeight', 'bold');


%%

dist_to_sun_au = [0.5:0.0001:3];
thrust_profile  = func_thrust_fitted( dist_to_sun_au, param);

figure;
plot(dist_to_sun_au, thrust_profile)
