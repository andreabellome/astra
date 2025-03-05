
clearDeleteAdd;

%%

% --> sequence
seq     = [ 3403148 3 ];

% --> load custom ephemerides
MICE_path = './MICE_TOOLBOX' ;
addpath(genpath(MICE_path)); % --> always include this

astra_opt_path = './astra_optimization';
addpath(genpath(astra_opt_path)); % --> always include this

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
customEphemerides       = INPUT.customEphemerides;

%%

% --> option 1)
seq           = [ 3403148 3 ];
[~, mu_earth] = constants( 1, 3 );

t0 = date2mjd2000( [ 2028 1 1 12 0 0 ] );
tof1 = 224;
tstay = 30;

t1   = t0 + tof1 + tstay;
tof2 = 100;
t2   = t1 + tof2;

[rrga1, vvga1] = customEphemerides( seq(1), t1, 1 );
[rrga2, vvga2] = customEphemerides( seq(2), t2, 1 );


Nrev = [ 0 0 ];

[vvd, vva] = lambertMR_MEXIFY(rrga1, rrga2, tof2*86400, mu, Nrev(1), Nrev(1));
dvv1       = vvd - vvga1;
dvv2       = vvga2 - vva;
dv1        = norm( dvv1 );
dv2        = norm( dvv2 );

rpip = 500e3;
rat  = 1e6;

dv = deltaV_hyperbola( dv2, rpip, rat, mu_earth )

0.541 + 0.402

%%

% --> option 2)
seq           = [ 3403148 3 ];
[~, mu_earth] = constants( 1, 3 );

t0 = date2mjd2000( [ 2028 4 26 12 0 0 ] );
tof1 = 116;
tstay = 30;

t1   = t0 + tof1 + tstay;
tof2 = 102;
t2   = t1 + tof2;

[rrga1, vvga1] = customEphemerides( seq(1), t1, 1 );
[rrga2, vvga2] = customEphemerides( seq(2), t2, 1 );


Nrev = [ 0 0 ];

[vvd, vva] = lambertMR_MEXIFY(rrga1, rrga2, tof2*86400, mu, Nrev(1), Nrev(1));
dvv1       = vvd - vvga1;
dvv2       = vvga2 - vva;
dv1        = norm( dvv1 );
dv2        = norm( dvv2 );

rpip = 500e3;
rat  = 1e6;

dv = deltaV_hyperbola( dv2, rpip, rat, mu_earth )

0.615 + 0.394

% rpip = 1e6;
% rat  = 3e6;
% 
% dv = deltaV_hyperbola( dv2, rpip, rat, mu_earth )

%%

% --> option 3)
seq           = [ 3403148 3 ];
[~, mu_earth] = constants( 1, 3 );

t0 = date2mjd2000( [ 2028 1 1 12 0 0 ] );
tof1 = 230;
tstay = 30;

t1   = t0 + tof1 + tstay;
tof2 = 74;
t2   = t1 + tof2;

[rrga1, vvga1] = customEphemerides( seq(1), t1, 1 );
[rrga2, vvga2] = customEphemerides( seq(2), t2, 1 );


Nrev = [ 0 0 ];

[vvd, vva] = lambertMR_MEXIFY(rrga1, rrga2, tof2*86400, mu, Nrev(1), Nrev(1));
dvv1       = vvd - vvga1;
dvv2       = vvga2 - vva;
dv1        = norm( dvv1 );
dv2        = norm( dvv2 );

rpip = 500e3;
rat  = 1e6;

dv = deltaV_hyperbola( dv2, rpip, rat, mu_earth )

0.718 + 0.468

% rpip = 1e6;
% rat  = 3e6;
% 
% dv = deltaV_hyperbola( dv2, rpip, rat, mu_earth )


%%

% --> option 4)
seq           = [ 3403148 3 ];
[~, mu_earth] = constants( 1, 3 );

t0 = date2mjd2000( [ 2028 1 1 12 0 0 ] );
tof1 = 150;
tstay = 30;

t1   = t0 + tof1 + tstay;
tof2 = 134;
t2   = t1 + tof2;

[rrga1, vvga1] = customEphemerides( seq(1), t1, 1 );
[rrga2, vvga2] = customEphemerides( seq(2), t2, 1 );


Nrev = [ 0 0 ];

[vvd, vva] = lambertMR_MEXIFY(rrga1, rrga2, tof2*86400, mu, Nrev(1), Nrev(1));
dvv1       = vvd - vvga1;
dvv2       = vvga2 - vva;
dv1        = norm( dvv1 );
dv2        = norm( dvv2 );

rpip = 500e3;
rat  = 1e6;

dv = deltaV_hyperbola( dv2, rpip, rat, mu_earth )

0.249 + 0.346

[mf, k, mp] = rocketEq_givenDV((20e3), (0.249 + 0.346)*10^3, 330);

% rpip = 1e6;
% rat  = 3e6;
% 
% dv = deltaV_hyperbola( dv2, rpip, rat, mu_earth )

