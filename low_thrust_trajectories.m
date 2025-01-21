
clearDeleteAdd; % --> !!! ONLY CALL IT ONCE FOR SPEED

%% TEST CASE 1: Earth-Mars (this is very fast)

close all; clc;

% --> parameters
idcentral   = 1;          % --> 1) central body is the Sun
Tmax        = 0.5;        % --> max. thrust                       [N]
Isp         = 2000;       % --> specific impulse                  [s]
m0          = 1000;       % --> initial mass                      [kg]           
g0          = 9.80665;    % --> Earth acceleration at sea level   [m/s]
useParallel = false;      % --> if true, uses parallel for fsolve

tof    = 348.795 * 86400;                                                     % --> time of flight [sec]
state1 = [ -140699693 -51614428 980 9.774596  -28.07828  4.337725e-4 ];       % --> initial state [km],[km/s]
state2 = [ -172682023 176959469 7948912 -16.427384  -14.860506  9.21486e-4 ]; % --> final state [km],[km/s]
Nrev   = 0; % --> number of revolutions

% --> initialise the parameters
param = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, Nrev, idcentral, useParallel);

% --> you might want to overwrite some of those (some examples below)
param.plot                                  = true;    % --> this plots the thrust evolution over time for different rho (default is false)
param.rhoLim                                = 0.0001;
param.rho                                   = 1;
param.gamma                                 = 0.1;
param.fsolveoptions.MaxFunctionEvaluations  = 10e3;
param.fsolveoptions.MaxIterations           = 10e3;

% --> solve the problem
LTsol = wrapSolveFopt( param );

% --> if you do not want to wait... UNCOMMENT the following code with the
% solution. The solution is contained in the structure LTsol.

% load('./results/low_thrust/LTsol_mars.mat');

% --> plot the solution
transfer = LTsol.transfer;
[figTRAJ, figMASS, figTHRmag] = plotLT( transfer, param );

% --> add Mars and Earth orbits to the plot
figure(figTRAJ);
plotPLTS_tt([3 4], 0, 3*365.25, idcentral, 1);

%% TEST CASE 2: Asteroid-to-asteroid (this is very fast)

close all; clc;

% --> parameters
idcentral = 1;        % --> 1) central body is the Sun
Tmax      = 0.6;      % --> max. thrust                       [N]
Isp       = 4000;     % --> specific impulse                  [s]
g0        = 9.80665;  % --> Earth acceleration at sea level   [m/s]

% --> this uses the ESA database
row  = 8872;
if ~exist('data', 'var')
    fprintf( "\n Loading ESA database... \n" );
    data = readmatrix('fuel_optimal_db.csv');
    fprintf( "\n Done! \n" );
end

% --> extract the data
m0      = data(row, 13);                % [kg]
mf      = data(row, 15);                % [kg]
tof     = data(row, 14) * 86400;        % [s]
state1  = data(row, 1:6)./1000;         % [km],[km/s]
state2  = data(row, 7:12)./1000;        % [km],[km/s]

useParallel = true;      % --> if true, uses parallel for fsolve
Nrev        = 0;          % --> number of revolutions

% --> initialise the parameters
param = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, Nrev, idcentral, useParallel);

% --> you might want to overwrite some of those (some examples below)
param.plot                                  = true;    % --> this plots the thrust evolution over time for different rho (default is false)
param.rhoLim                                = 0.00001;
param.rho                                   = 1;
param.gamma                                 = 0.1;
param.fsolveoptions.MaxFunctionEvaluations  = 10e3;
param.fsolveoptions.MaxIterations           = 10e3;

% --> solve the problem
LTsol = wrapSolveFopt( param );

% --> if you do not want to wait... UNCOMMENT the following code with the
% solution. The solution is contained in the structure LTsol.

% load('./results/low_thrust/LTsol_ESA_DB_row_8872.mat');

% --> check that the solution converged to the one from ESA database
mf_ESA_db = mf;
mf_fsolve = LTsol.mf;
if abs(mf_fsolve - mf_ESA_db) < 10
    fprintf( 'Solutions found and compatible with ESA database \n' );
    fprintf( 'Difference with ESA solution: %f kg \n', mf_fsolve - mf_ESA_db );
end

% --> plot the solution
transfer = LTsol.transfer;
[figTRAJ, figMASS, figTHRmag] = plotLT( transfer, param );

%% TEST CASE 3: Mercury leveraging (this might require some time...)

close all; clc;

% --> parameters
idcentral   = 1;          % --> 1) central body is the Sun
Tmax        = 0.32;       % --> max. thrust                       [N]
Isp         = 3000;       % --> specific impulse                  [s]
m0          = 4000;       % --> initial mass                      [kg]           
g0          = 9.80665;    % --> Earth acceleration at sea level   [m/s]
useParallel = false;      % --> if true, uses parallel for fsolve

% --> initialise the parameters
tof    = 358.928459543061 * 86400; % --> time of flight [sec]
state1 = [38757039.7499878;28387323.0458716;-1250921.63423610;-43.6721929563112;40.8343207785050;7.27240226499759]'; % --> initial state [km],[km/s]
state2 = [8402883.04356492;45138449.3894568;2904559.88399718;-60.9850713035465;11.3696258548873;6.51410611494519]';  % --> final state [km],[km/s]
Nrev   = 3; % --> number of revolutions

% --> initialise the parameters
param = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, Nrev, idcentral, useParallel);

% --> you might want to overwrite some of those (some examples below)
param.plot                                  = true;    % --> this plots the thrust evolution over time for different rho (default is false)
param.rhoLim                                = 1e-8;
param.rho                                   = 1;
param.gamma                                 = 0.5;
param.fsolveoptions.MaxFunctionEvaluations  = 5e3;
param.fsolveoptions.MaxIterations           = 5e3;

% --> solve the problem
LTsol = wrapSolveFopt( param );

% --> if you do not want to wait... UNCOMMENT the following code with the
% solution. The solution is contained in the structure LTsol.

% load('./results/low_thrust/LTsol_mercury.mat');

% --> plot the solution
transfer = LTsol.transfer;
[figTRAJ, figMASS, figTHRmag] = plotLT( transfer, param );

% --> add Mercury orbit to the plot
figure(figTRAJ);
plotPLTS_tt(1, 0, 2*365.25, idcentral, 1);

%% TEST CASE 4: Asteroid-to-asteroid (this might require some time...)

close all; clc;

% --> parameters
idcentral = 1;        % --> 1) central body is the Sun
Tmax      = 0.6;      % --> max. thrust                       [N]
Isp       = 4000;     % --> specific impulse                  [s]
g0        = 9.80665;  % --> Earth acceleration at sea level   [m/s]

% --> this uses the ESA database
row  = 1327460;
if ~exist('data', 'var')
    fprintf( "\n Loading ESA database... \n" );
    data = readmatrix('fuel_optimal_db.csv');
    fprintf( "\n Done! \n" );
end

% --> extract the data
m0      = data(row, 13);                % [kg]
mf      = data(row, 15);                % [kg]
tof     = data(row, 14) * 86400;        % [s]
state1  = data(row, 1:6)./1000;         % [km],[km/s]
state2  = data(row, 7:12)./1000;        % [km],[km/s]

useParallel = true;      % --> if true, uses parallel for fsolve
Nrev        = 1;          % --> number of revolutions

% --> initialise the parameters
param = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, Nrev, idcentral, useParallel);

% --> you might want to overwrite some of those (some examples below)
param.plot                                  = true;    % --> this plots the thrust evolution over time for different rho (default is false)
param.rhoLim                                = 0.00001;
param.rho                                   = 1;
param.gamma                                 = 0.5;
param.fsolveoptions.MaxFunctionEvaluations  = 10e3;
param.fsolveoptions.MaxIterations           = 10e3;

% --> solve the problem
LTsol = wrapSolveFopt( param );

% --> if you do not want to wait... UNCOMMENT the following code with the
% solution. The solution is contained in the structure LTsol.

% load('./results/low_thrust/LTsol_ESA_DB_row_1327460.mat');

% --> check that the solution converged to the one from ESA database
mf_ESA_db = mf;
mf_fsolve = LTsol.mf;
if abs(mf_fsolve - mf_ESA_db) < 10
    fprintf( 'Solutions found and compatible with ESA database \n' );
    fprintf( 'Difference with ESA solution: %f kg \n', mf_fsolve - mf_ESA_db );
end

% --> plot the solution
transfer = LTsol.transfer;
[figTRAJ, figMASS, figTHRmag] = plotLT( transfer, param );

%% TEST CASE 5: Earth-Dionysus (this has many revolutions)

close all; clc;
    
% --> parameters
idcentral = 1;        % --> 1) central body is the Sun
Tmax      = 0.32;     % --> max. thrust                       [N]
Isp       = 3000;     % --> specific impulse                  [s]
m0        = 4000;     % --> initial mass                      [kg]          
g0        = 9.80665;  % --> Earth acceleration at sea level   [m/s]

% --> initialise the parameters
param     = writeParamLT( Tmax, Isp, m0, g0, idcentral, true );

% --> Earth-to-Dionysus
tStart    = 0;
tEnd      = 3534;
initState = [ 0.999316, -0.004023, 0.015873, -1.623e-5, 1.667e-5, 1.59491 ];
finState  = [ 1.555261 0.152514 -0.519189 0.016353 0.117461 2.36696 ];

param.tStart = tStart;
param.tEnd   = tEnd;
param.x0     = initState;
param.xf     = finState;

param.plot    = true;
param.rhoLim  = 0.0001;
param.rho     = 1;
param.gamma   = 0.1;
param.iterMax = 5;
param.tol     = 1e-8;

while param.xf(end) < param.x0(end)
    param.xf(end) = param.xf(end) + 2*pi;
end
NrevCheckBefore = floor(( param.xf(end) - param.x0(end) )/(2*pi));

Nrev            = 5;
param.xf(end)   = param.xf(end) + 2*Nrev*pi;
NrevCheck       = floor(( param.xf(end) - param.x0(end) )/(2*pi));

LTsol = wrapSolveFopt( param );

% --> if you do not want to wait... UNCOMMENT the following code with the
% solution. The solution is contained in the structure LTsol.

% load('./results/low_thrust/LTsol_dionysus.mat');

% --> plot the solution
transfer                      = LTsol.transfer;
[figTRAJ, figMASS, figTHRmag] = plotLT( transfer, param );

%% TEST CASE 7: Earth-to-Tempel1

close all; clc;

% --> parameters
idcentral = 1;        % --> 1) central body is the Sun
Tmax      = 0.6;      % --> max. thrust                       [N]
Isp       = 3000;     % --> specific impulse                  [s]
m0        = 1000;     % --> initial mass                      [kg]          
g0        = 9.80665;  % --> Earth acceleration at sea level   [m/s]

% --> initialise the parameters
param     = writeParamLT( Tmax, Isp, m0, g0, idcentral, true );

% --> Earth-to-Tempel
tStart    = 0;
tEnd      = 420;
initState = [ 1.000064, -0.003764, 0.015791, -1.211e-5, -4.514e-6, 5.51356 ];
finState  = [2.328616, -0.191235, -0.472341,  0.033222,  0.085426,  4.96395];

param.tStart = tStart;
param.tEnd   = tEnd;
param.x0     = initState;
param.xf     = finState;

param.plot    = true;
param.rhoLim  = 0.00001;
param.rho     = 1;
param.gamma   = 0.1;
param.iterMax = 5;
param.tol     = 1e-8;

while param.xf(end) < param.x0(end)
    param.xf(end) = param.xf(end) + 2*pi;
end
NrevCheckBefore = floor(( param.xf(end) - param.x0(end) )/(2*pi));

LTsol = wrapSolveFopt( param );

% --> if you do not want to wait... UNCOMMENT the following code with the
% solution. The solution is contained in the structure LTsol.

% load('./results/low_thrust/LTsol_tempel.mat');

% --> plot the solution
transfer                      = LTsol.transfer;
[figTRAJ, figMASS, figTHRmag] = plotLT( transfer, param );

%% TEST CASE 8: Asteroid-to-Asteroid (HARD: high mass, high TOF, multi-rev.)

close all; clc;

% --> parameters
idcentral = 1;        % --> 1) central body is the Sun
Tmax      = 0.6;      % --> max. thrust                       [N]
Isp       = 4000;     % --> specific impulse                  [s]
g0        = 9.80665;  % --> Earth acceleration at sea level   [m/s]

% --> this uses the ESA database
row  = 1327515;
if ~exist('data', 'var')
    fprintf( "\n Loading ESA database... \n" );
    data = readmatrix('fuel_optimal_db.csv');
    fprintf( "\n Done! \n" );
end

% --> extract the data
m0      = data(row, 13);                % [kg]
mf      = data(row, 15);                % [kg]
tof     = data(row, 14) * 86400;        % [s]
state1  = data(row, 1:6)./1000;         % [km],[km/s]
state2  = data(row, 7:12)./1000;        % [km],[km/s]

useParallel = true;      % --> if true, uses parallel for fsolve
Nrev        = 1;         % --> number of revolutions

% --> initialise the parameters
param = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, Nrev, idcentral, useParallel);

% --> you might want to overwrite some of those (some examples below)
param.plot                                  = true;    % --> this plots the thrust evolution over time for different rho (default is false)
param.rhoLim                                = 0.01;    % --> this is high (0.01), but still the solution is very close to optimal one...
param.rho                                   = 1;
param.gamma                                 = 0.7;
param.fsolveoptions.MaxFunctionEvaluations  = 100e3;
param.fsolveoptions.MaxIterations           = 100e3;

% --> solve the problem
LTsol = wrapSolveFopt( param );

% --> if you do not want to wait... UNCOMMENT the following code with the
% solution. The solution is contained in the structure LTsol.

% load('./results/low_thrust/LTsol_ESA_DB_row_1327515.mat');

% --> check that the solution converged to the one from ESA database
mf_ESA_db = mf;
mf_fsolve = LTsol.mf;
if abs(mf_fsolve - mf_ESA_db) < 10
    fprintf( 'Solutions found and compatible with ESA database \n' );
    fprintf( 'Difference with ESA solution: %f kg \n', mf_fsolve - mf_ESA_db );
end

% --> plot the solution
transfer                      = LTsol.transfer;
[figTRAJ, figMASS, figTHRmag] = plotLT( transfer, param );
