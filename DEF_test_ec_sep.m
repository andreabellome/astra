
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

%%

load("C:\Users\Andrea\Documents\GitHub\astra\wksp_2040_2040_em_ceres_max_4y_opt_sol_31y_vinf_35.mat"); % --> saved: wksp_EMCEREEEEEEES_VDEF_2040
% load("C:\Users\Andrea\Documents\GitHub\astra\wksp_2043_2043_em_ceres_max_4y_opt_sol_27y_vinf_25.mat"); % --> saved: wksp_EMCEREEEEEEES_VDEF
% load("C:\Users\Andrea\Documents\GitHub\astra\wksp_2044_2044_em_ceres_max_4y_opt_sol_27y_vinf_35.mat"); % --> saved: wksp_EMCEREEEEEEES_VDEF_2044

%%

close all; clc;

% --> plot and process the DSM solution
vdep_free = 5;
varr_free = 0.0;
[DV, dv, t0, tofs, MAT, output] = wrap_mga_nDSM(seq, minsol, struc_revs_man, INPUT.customEphemerides, 1);
struc = postProcessPathASTRA_dsm_lowThrust( dv, output, MAT, vdep_free, varr_free, INPUT.idcentral, INPUT.customEphemerides );

close all; 

%%

mu        = 132724487690;
AU        = 149597870.7;
idcentral = 1;

INPUT.customEphemerides = @EphSS_from_mice_workaround;
customEphemerides       = INPUT.customEphemerides;


% --> low-thrust parameters
Tmax         = 1050e-3;
thrust_max_N = 255e-3;
n_engines    = 2;

Isp          = 3500;
m0           = 2500;
g0           = 9.81;
useParallel  = true;      % --> if true, uses parallel for fsolve


close all; clc;
state1 = struc(1).xxDtar;
% state2 = struc(1).xxAtar;
t1     = struc(1).tD;
t2       = struc(1).tA + 900;
(t2 - struc(1).tD)/365.2

[rrarr, vvarr] = EphSS_from_mice_workaround( struc(1).idA, t2, 1 );
state2 = [ rrarr, vvarr ];


dvD    = struc(1).dvD;
dvA    = struc(1).dvA;
Nrev   = 1;

tof_days = t2 - t1;
tof_sec  = tof_days * 86400;

[rrpl, vvpl]        = EphSS_from_mice_workaround( struc(1).idD, t1, idcentral );
[Dec, Asc]          = findDeclinationLaunch(state1(:,4:6), vvpl);
vinf_launch         = norm( vvpl - state1(:,4:6) )
declination_degrees = rad2deg(Dec)
right_asc_degrees   = rad2deg(Asc)
dvD
dvA

%%

clc;

% --> initialise the parameters
param = processDataAndWriteParam(m0, tof_sec, state1, state2, Tmax, Isp, g0, Nrev, idcentral, useParallel);

% --> you might want to overwrite some of those (some examples below)
param.plot                                  = true;    % --> this plots the thrust evolution over time for different rho (default is false)
param.rhoLim                                = 0.0001;
param.rho                                   = 1;
param.rhoGuess1                             = 0.75;
param.gamma                                 = 0.5;
param.fsolveoptions.MaxFunctionEvaluations  = 50e3;
param.fsolveoptions.MaxIterations           = 50e3;

if dvD + dvA >= 0.1
    need_to_refine    = true;

    Tmax_temp            = 0.3;
    param_temp           = processDataAndWriteParam(m0, tof_sec, state1, state2, Tmax_temp, Isp, g0, Nrev, idcentral, useParallel);
    param_temp.gamma     = 0.5;
    param_temp.rhoGuess1 = 0.5;
    param_temp.rhoLim    = 0.0005;
    
    % --> solve the problem
    LTsol = wrapSolveFopt( param_temp );

else

    fprintf( 'No DSM -- no need to refine in LT \n' );
    need_to_refine = false;
    
    % --> simple propagation without thrusting
    [tt, yy] = propagateKepler(state1(1:3), state1(4:6), linspace(0, tof_sec, 1e3), param.mu);

    transfer_1 = [ tt./86400, yy, m0.*ones(size(yy,1),1), zeros(size(yy,1),4) ];

    LTsol.transfer = transfer_1;
    LTsol.lambdas  = zeros( 1,7 );
    LTsol.Tmax     = param.Tmax;
    LTsol.Isp      = param.Isp;
    LTsol.g0       = param.g0;
    LTsol.m0       = m0;
    LTsol.mf       = m0;
    LTsol.tof      = tof_sec / 86400;
    LTsol.DV       = 0;
    LTsol.param    = param;
    LTsol.success  = true;

end

%%

transfer_1 = LTsol.transfer;
[figTRAJ, figMASS, figTHRmag] = plotLT( transfer_1, param, 0 );
figure(figTRAJ);
plotPLTS_tt([3 4 20000001], ...
    t1, t2, ...
    idcentral, ...
    customEphemerides, ...
    1, cool(3), {'Earth', 'Mars', 'Ceres'}, 2);

%%

param.thrust_max_N  = thrust_max_N;
param.n_engines     = n_engines;

if need_to_refine

    lambdas = LTsol.lambdas;
    % lambdas = [ 1*rand(1,6), 1];
    
    param.rho = 0.9;
    [initiallamba, Fsol] = ...
                fsolve(@(lambda0) propagateState_SEP(lambda0, ...
                @propagateFopt_SEP_MEXIFY, param), ...
                lambdas, param.fsolveoptions);

else

    fprintf( 'No DSM -- no need to refine in LT-SEP \n' );

end

%%

if need_to_refine

    fig = figure( 'Color', [1 1 1] );
    for ind = 1:70
        
        fprintf( "-----------------------\n");
        fprintf( "ind: %d \n", ind );
    
        param.gamma = 0.9;
        param.rho = param.rho * param.gamma;
        
        fprintf( "RHO: %f \n", param.rho );
        [initiallamba, Fsol] = ...
                    fsolve(@(lambda0) propagateState_SEP(lambda0, @propagateFopt_SEP_MEXIFY, param), ...
                    initiallamba, param.fsolveoptions);
        
        
        [time, states]              = ode45(@(t,x) propagateFopt_SEP_MEXIFY(t, x, ...
                                                [ param.muScl, ...
                                                param.TmaxScl, ...
                                                param.IspScl, ...
                                                param.g0Scl, ...
                                                param.rho, ...
                                                param.LU, param.TU, param.MU, ...
                                                param.thrust_max_N, param.n_engines,...
                                                ]),...
                                                [param.tStart,param.tEnd],...
                                                [param.x0, param.m0Scl, initiallamba], ...
                                                param.odeoptions);
        
        fprintf( "Final mass: %f kg \n", states(end,7)*param.MU );
        
        transfer_1 = postProcessLT_SEP( time, states, @propagateFopt_SEP_MEXIFY, param );
        
        hold on;
        dist_to_sun_au = vecnorm(transfer_1(:,2:4)')'./AU;
        thrust_profile = func_thrust_fitted( dist_to_sun_au, 0.005, Tmax, n_engines, thrust_max_N);
        plotLT_Th( transfer_1, param, 1 );
        hold on;
        plot( transfer_1(:,1), thrust_profile, '--', 'LineWidth', 2, 'DisplayName', 'Available thrust' );

    
        st = 1;
        fprintf( "-----------------------\n");
    
    end

else

    fprintf( 'No DSM -- no need to refine in LT-SEP \n' );

end

if need_to_refine
    m0_new = states(end,7)*param.MU 
else
    m0_new = m0
end

%%

% close all; clc; 
clc;

[figTRAJ, figMASS, figTHRmag] = plotLT( transfer_1, param, 0 );
figure(figTRAJ);
plotPLTS_tt([3 4 20000001], ...
    t1, t2, ...
    idcentral, ...
    customEphemerides, ...
    1, cool(3), {'Earth', 'Mars', 'Ceres'}, 2);

dist_to_sun_au = vecnorm(transfer_1(:,2:4)')'./AU;
thrust_profile = func_thrust_fitted( dist_to_sun_au, 0.005, Tmax, n_engines, thrust_max_N);

figure(figTHRmag);
plot( transfer_1(:,1), thrust_profile, '--', 'LineWidth', 2, 'DisplayName', 'Available thrust' );

yyaxis right;
ylabel('Distance to Sun [AU]');
plot( transfer_1(:,1), dist_to_sun_au, 'LineWidth', 2, 'HandleVisibility', 'off' );

lgd           = legend;
lgd.String{1} = 'Used thrust';

% fig = figure('Color', [1 1 1]);
% plot( transfer_1(:,1), thrust_profile' );

%%

% % m0_new = 2109.87074949199;
% % m0_new = 2081.694771; % --> saved: wksp_EMCEREEEEEEES_VDEF
% % m0_new = 2500; % --> saved: wksp_EMCEREEEEEEES_VDEF_2044
% % m0_new = 2364.071117; % --> 2044 wksp_EMCEREEEEEEES_VDEF_VDEF_2044
% m0_new = 2349.349319; 

%%

state1   = struc(2).xxDtar;
% state2   = struc(2).xxAtar;
t1       = struc(2).tD;
t2       = struc(2).tA + 300;
(t2 - struc(1).tD)/365.2

[rrarr, vvarr] = EphSS_from_mice_workaround( struc(2).idA, t2, 1 );
state2 = [ rrarr, vvarr ];

tof_days = t2 - t1;
tof_sec  = tof_days * 86400;

% --> initialise the parameters
param = processDataAndWriteParam(m0_new, tof_sec, state1, state2, Tmax, Isp, g0, Nrev, idcentral, useParallel);

% --> you might want to overwrite some of those (some examples below)
param.plot                                  = true;    % --> this plots the thrust evolution over time for different rho (default is false)
param.rhoLim                                = 0.0001;
param.rho                                   = 1;
param.rhoGuess1                             = 0.5;
param.gamma                                 = 0.5;
param.fsolveoptions.MaxFunctionEvaluations  = 100e3;
param.fsolveoptions.MaxIterations           = 100e3;

%%

Tmax_temp            = 0.35;
param_temp           = processDataAndWriteParam(m0_new, tof_sec, state1, state2, Tmax_temp, Isp, g0, Nrev, idcentral, useParallel);
param_temp.gamma     = 0.5;
param_temp.rhoGuess1 = 0.5;
param_temp.rhoLim    = 0.001;

% --> solve the problem
LTsol = wrapSolveFopt( param_temp );

fprintf( "LT at max. thrust is solved \n" );

%%

[figTRAJ, figMASS, figTHRmag] = plotLT( LTsol.transfer, param, 0 );
figure(figTRAJ);
plotPLTS_tt([3 4 20000001], ...
    t1, t2, ...
    idcentral, ...
    customEphemerides, ...
    1, cool(3), {'Earth', 'Mars', 'Ceres'}, 2);

%%

param.thrust_max_N  = thrust_max_N;
param.n_engines     = n_engines;

param.rho = 0.9;
% lambdas = [ 1*rand(1,6), 10];
lambdas = LTsol.lambdas;
[initiallamba, Fsol] = ...
            fsolve(@(lambda0) propagateState_SEP(lambda0, ...
            @propagateFopt_SEP_MEXIFY, param), ...
            lambdas, param.fsolveoptions);

%%

fig = figure( 'Color', [1 1 1] );
for ind = 1:70
    
    fprintf( "-----------------------\n");
    fprintf( "ind: %d \n", ind );

    param.gamma = 0.9;
    param.rho = param.rho * param.gamma;
    
    fprintf( "RHO: %f \n", param.rho );
    [initiallamba, Fsol] = ...
                fsolve(@(lambda0) propagateState_SEP(lambda0, @propagateFopt_SEP_MEXIFY, param), ...
                initiallamba, param.fsolveoptions);
    
    [time, states]              = ode45(@(t,x) propagateFopt_SEP_MEXIFY(t, x, ...
                                            [ param.muScl, ...
                                            param.TmaxScl, ...
                                            param.IspScl, ...
                                            param.g0Scl, ...
                                            param.rho, ...
                                            param.LU, param.TU, param.MU, ...
                                            param.thrust_max_N, param.n_engines,...
                                            ]),...
                                            [param.tStart,param.tEnd],...
                                            [param.x0, param.m0Scl, initiallamba], ...
                                            param.odeoptions);
    
    fprintf( "Final mass: %f kg \n", states(end,7)*param.MU );
    
    transfer_2 = postProcessLT_SEP( time, states, @propagateFopt_SEP_MEXIFY, param );
    
    hold on;
    plotLT_Th( transfer_2, param, 1 );

    st = 1;
    fprintf( "-----------------------\n");

end

%%

[figTRAJ, figMASS, figTHRmag] = plotLT( transfer_2, param, 0 );
figure(figTRAJ);
plotPLTS_tt([3 4 20000001], ...
    t1, t2, ...
    idcentral, ...
    customEphemerides, ...
    1, cool(3), {'Earth', 'Mars', 'Ceres'}, 2);

dist_to_sun_au = vecnorm(transfer_2(:,2:4)')'./AU;
thrust_profile = func_thrust_fitted( dist_to_sun_au, 0.002, Tmax, n_engines, thrust_max_N);
% thrust_law = func_thrust_true( dist_to_sun_au, Tmax, 3, 255e-3);

figure(figTHRmag); yyaxis left;
plot( transfer_2(:,1), thrust_profile, '-', 'LineWidth', 2, 'DisplayName', 'Available thrust' );

yyaxis right;
ylabel('Distance to Sun [AU]');
plot( transfer_2(:,1), dist_to_sun_au, 'LineWidth', 2, 'HandleVisibility', 'off' );

lgd           = legend;
lgd.String{1} = 'Used thrust';
lgd.Location  = 'southeast';

%%

% close all; clc; 

TRANSFER            = transfer_1;
transfer_2_mod      = transfer_2; 
transfer_2_mod(:,1) = transfer_1(end,1) + transfer_2_mod(:,1);

TRANSFER        = [ TRANSFER; transfer_2_mod ];
dist_to_sun_au  = vecnorm(TRANSFER(:,2:4)')'./AU;
thrust_profile  = func_thrust_fitted( dist_to_sun_au, 0.002, Tmax, n_engines, thrust_max_N);

[figTRAJ, figMASS, figTHRmag] = plotLT( TRANSFER, param, 0 );

figure(figTHRmag);
plot( TRANSFER(:,1), thrust_profile, '--', 'LineWidth', 2, 'DisplayName', 'Available thrust' );

yyaxis right;
ylabel('Distance to Sun [AU]');
plot( TRANSFER(:,1), dist_to_sun_au, 'LineWidth', 2, 'HandleVisibility', 'off' );

lgd           = legend('Location', 'southeast');
lgd.String{1} = 'Used thrust';


figure(figTRAJ);
plotPLTS_tt([3 4 20000001], ...
    t1, t2, ...
    idcentral, ...
    customEphemerides, ...
    1, [], [], 1, '-');

plot3( state1(:,1)./AU, state1(:,2)./AU, state1(:,3)./AU, 'o', ...
    'MarkerSize', 8, ...
    'MarkerEdgeColor', 'black', ...
    'MarkerFaceColor', 'red', ...
    'HandleVisibility', 'off');

xl = xlim;
yl = ylim;

% Choose coordinates slightly to the right of each orbit circle
rEarth = 1.0;      % Earth orbit radius (AU) → change if needed
rMars  = 1.524;    % Mars orbit radius (AU) → change if needed

axes_dim = 25;

plotFontSizeAxesDim(axes_dim, axes_dim, figTRAJ, findall(figTRAJ, 'Type', 'axes'));
plotFontSizeAxesDim(axes_dim, axes_dim, figTHRmag, findall(figTHRmag, 'Type', 'axes'));
plotFontSizeAxesDim(axes_dim, axes_dim, figMASS, findall(figMASS, 'Type', 'axes'));


% Place the labels
text(-0.5, -0.8, 'Earth', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
    'FontSize', 20);

text(1.1, 1, 'Mars', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
    'FontSize', 20);

text( state2(:,1)./AU,  state2(:,2)./AU + 0.1, 'Ceres', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle', ...
    'FontSize', 20);

custom_dpi = 300;
print(figTRAJ, 'figTRAJ.png', '-dpng', ['-r' num2str(custom_dpi)]);
print(figMASS, 'figMASS.png', '-dpng', ['-r' num2str(custom_dpi)]);
print(figTHRmag, 'figTHRmag.png', '-dpng', ['-r' num2str(custom_dpi)]);
