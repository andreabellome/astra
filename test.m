
clearDeleteAdd;

%%

% --> sequence
seq     = [ 3 3403148 ];

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

%%

[muCentral, mu_earth] = constants(1, 3);

% --> Herschel/Planck mission
rp = 319 + 6378;
ra = 1200000;

% --> GTO
rp = 6378 + 250;
ra = 6378 + 35942;

% --> find apses velocities
[vp, va, sma, ecc, period] = apses_velocities( rp, ra, mu_earth );

vp

%%

[muCentral, mu_earth] = constants(1, 3);

rpip = 500 + 6378;
rat  = 500 + 6378;

sma    = 0.5*( rpip + rat )
ecc    = ( rat - rpip )/( rpip + rat )
period = 2*pi*sqrt( sma*sma*sma/mu_earth )/86400

vinf  = 0.65;
dv_hyp = deltaV_hyperbola( vinf, rpip, rat, mu_earth );

%%

[mf, k, mp] = rocketEq_givenDV(2e3, 1.943e3, 330);
mp
[mf, k, mp] = rocketEq_givenDV((20e3), 0.524e3, 330);
mp

%%

INPUT.customEphemerides = @EphSS_NEOs;
customEphemerides = INPUT.customEphemerides;

t1  = date2mjd2000( [ 2028 1 1 12 0 0 ] );
tof = 150;
t2  = t1 + tof;

t2_date = mjd20002date( t2 );

[rrga1, vvga1] = customEphemerides( 3, t1 );
[rrga2, vvga2] = customEphemerides( max(seq), t2 );

Nrev = [ 0 0 ];

[vvd, vva] = lambertMR_MEXIFY(rrga1, rrga2, tof*86400, mu, Nrev(1), Nrev(1));

dvv1 = vvd - vvga1;
dvv2 = vvga2 - vva;

norm(dvv1)
norm(dvv2)

vvsc = vvd;
[Dec, Asc]  = findDeclinationLaunch(vvsc, vvga1);

dec_deg = rad2deg(Dec)
asc_deg = rad2deg(Asc)
