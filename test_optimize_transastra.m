
clearDeleteAdd;

%%

% --> sequence
seq     = [ 3 3403148 ];

% --> load custom ephemerides
MICE_path = './MICE_TOOLBOX' ;
addpath(genpath(MICE_path)); % --> always include this

% % --> load the kernels
% cspice_furnsh( { [MICE_path '/' num2str(max(seq)) '.bsp'],...                         % --> this is for the asteroid
%                  [MICE_path '/de441_part-1.bsp'], [MICE_path '/de441_part-2.bsp'],... % --> this is for Earth
%                  [MICE_path '/mar097.bsp'],...                                        % --> this is for Mars
%                  [MICE_path '/naif0012.tls'] } );                                     % --> this is for time system

% --> load the kernels
cspice_furnsh( { [MICE_path '/' num2str(max(seq)) '.bsp'],...                         % --> this is for the asteroid
                 [MICE_path '/de435.bsp'],...                                         % --> this is for Earth
                 [MICE_path '/mar097.bsp'],...                                        % --> this is for Mars
                 [MICE_path '/naif0012.tls'] } );                                     % --> this is for time system


% --> define custom ephemerides
INPUT.customEphemerides = @EphSS_NEOs;

%%

tarr = date2mjd2000( [ 2028 5 22 12 0 0 ] );
tof  = 95;

tdep = tarr - tof;

customEphemerides = INPUT.customEphemerides;

[rrga1, vvga1] = customEphemerides( seq(1), tdep, 1 );
[rrga2, vvga2] = customEphemerides( seq(2), tarr, 1 );

Nrev = [ 0 0 ];

[vvd, vva] = lambertMR_MEXIFY(rrga1, rrga2, tof*86400, mu, Nrev(1), Nrev(1))

vinfd = norm(vvd - vvga1)
vinfa = norm(vvga2 - vva)

%%

NmanLeg = 1;

t0Min = date2mjd2000( [2028 1 1 12 0 0] );
t0Max = date2mjd2000( [2028 1 31 12 0 0] );

TOFMin = 80;
TOFMax = 100;

dv1Min = [ 0 0 0 ];
dv1Max = [ 5 pi pi ];

dvsMin = [ 0 0 0 ];
dvsMax = [ 0 0 0 ];

epsMin = 0.01;
epsMax = 0.99;

etaMin = []; etaMax = [];
rpMin  = [];  rpMax = [];

lb               = [ t0Min TOFMin dv1Min dvsMin epsMin etaMin rpMin ];
ub               = [ t0Max TOFMax dv1Max dvsMax epsMax etaMax rpMax ];

costFun    = @(x) wrap_mga_nDSM(seq, x, NmanLeg, INPUT.customEphemerides);

%%

% --> optimize
maxit       = 1;
optionsPSO = optPSO(lb, ub);
sol        = zeros(maxit, length(lb));
fval       = zeros(maxit, 1);
for ind = 1:maxit
    [sol(ind,:), fval(ind,:)] = particleswarm(costFun, length(lb), lb, ub, optionsPSO);
end

[minc, row] = min(fval);
minsol      = sol(row,:);

close all; clc;
[DV, dv, t0, tofs, MAT, output] = wrap_mga_nDSM(seq, minsol, NmanLeg, INPUT.customEphemerides, 1);
