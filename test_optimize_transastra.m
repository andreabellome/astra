
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


% --> define custom ephemerides
INPUT.customEphemerides = @EphSS_NEOs;
customEphemerides       = INPUT.customEphemerides;

%%

close all; clc;

t01 = date2mjd2000( [2028 1 1 12 0 0] );

T0   = t01:1:t01+2*365;
tofs = 1:1:300;

for indt0 = 1:length(T0)

    t0 = T0(indt0);
    
    [rrgas1, vvgas1]  = customEphemerides( seq(1), t0, 1 );
    cars1             = [ rrgas1, vvgas1 ];
    
    [rrgas2, vvgas2]  = customEphemerides( seq(2), t0, 1 );
    cars2             = [ rrgas2, vvgas2 ];
    
    distance(indt0,1) = norm( rrgas2 -  rrgas1 );

end

earth_hill_radius       = 1.496e8*((5.972e24)/(1.989e30*3))^(1/3);
earth_moon_hill_radius  = 1.496e8*((5.972e24+7.348e24)/(1.989e30*3))^(1/3);

earth_soi = 1.496e8*((5.972e24)/(1.989e30))^(2/5);

figure( 'Color', [1 1 1] );
hold on; grid on;
plot( T0, distance, '-.', 'LineWidth', 2 );

hline(3e6);

hline(earth_soi);

datetick('x','mmm.dd,yy' );

%%

t01 = date2mjd2000( [2028 1 1 12 0 0] );

T0   = t01:1:t01+1*365;
tofs = 1:1:30;

dvApprox = zeros( length(T0), length(tofs) );
DV1      = zeros( length(T0), length(tofs) );
DV2      = zeros( length(T0), length(tofs) );
DV1p     = zeros( length(T0), length(tofs) );
DV2p     = zeros( length(T0), length(tofs) );

dv1      = zeros( length(T0), length(tofs) );
dv2      = zeros( length(T0), length(tofs) );
dorb     = zeros( length(T0), length(tofs) );


meshTDEP = zeros(length(T0), length(tofs));
meshTOF  = zeros(length(T0), length(tofs));

for indt0 = 1:length(T0)

    indt0/length(T0)*100

    t0 = T0(indt0);

    [rrgas1, vvgas1] = customEphemerides( seq(1), t0, 1 );
    cars1            = [ rrgas1, vvgas1 ];
    
    [rrgas2, vvgas2] = customEphemerides( seq(2), t0, 1 );
    cars2            = [ rrgas2, vvgas2 ];
    
    for indtof = 1:length(tofs)

        meshTDEP(indt0,indtof) = t0;
        meshTOF(indt0,indtof)  = tofs(indtof);

        t1     = t0 + tofs(indtof);
        
        [rrgat1, vvgat1] = customEphemerides( seq(1), t1, 1 );
        cart1(indtof,:)  = [ rrgat1, vvgat1 ];
        
        [rrgat2, vvgat2] = customEphemerides( seq(2), t1, 1 );
        cart2(indtof,:)  = [ rrgat2, vvgat2 ];
        
        xx1                = improvedOrbitalIndicator(cars1(1:3), cars1(4:6), ...
                                                      cart1(indtof,1:3), cart1(indtof,4:6), ...
                                                      tofs(indtof).*86400);
        xx2                = improvedOrbitalIndicator(cars2(1:3), cars2(4:6), ...
                                                      cart2(indtof,1:3), cart2(indtof,4:6), ...
                                                      tofs(indtof).*86400);

        DV1(indt0,indtof)  = norm(xx1(1:3) - xx2(1:3));
        DV2(indt0,indtof)  = norm(xx1(4:6) - xx2(4:6));
        DV1p(indt0,indtof) = norm(xx1(7:9) - xx2(7:9));
        DV2p(indt0,indtof) = norm(xx1(10:12) - xx2(10:12));

        dvApprox(indt0,indtof) = norm( xx1 - xx2 );
        
        DT = tofs(indtof)*86400;

        xx                 = orbitalIndicator([cars1(1:3); cars2(1,1:3)], [cars1(4:6); cars2(1,4:6)], DT);
        dorb(indt0,indtof) = norm(xx(2,:) - xx(1,:));
        
        dv1(indt0,indtof)         = norm(1./(DT).*(cars2(1,1:3) - cars1(1:3)) + (cars1(4:6) - cars2(1,4:6)));
        dv2(indt0,indtof)         = norm(1./(DT).*(cars2(1,1:3) - cars1(1:3)));

    end

end

%%

close all; clc;

cleaned_str = '(2006) RH120';

fig00 = plotPorkChop(dvApprox, meshTDEP, meshTOF, [0.5, 9]);

target_folder = '/results/Images/transASTRA_analysis/';

name_fig_0 = ['orb_approx_to_re_'];

fprintf( 'Saving figures... \n' )
exportgraphics(fig00, [pwd target_folder name_fig_0 '_' cleaned_str '.png' ], 'Resolution', 1200);
fprintf( 'Done! \n' );

%%

min(min(dvApprox))

[minVal, minRow, minCol] = minValueMatrix(dorb);
[minVal, minRow, minCol] = minValueMatrix(dvApprox);

[minVal, minRow, minCol] = minValueMatrix(DV2+DV2p);

[minVal, minRow, minCol] = minValueMatrix(dv1+dv2);

%%

[minVal, minRow, minCol] = minValueMatrix(dvApprox);

tdep = T0(minRow);
tof  = tofs(minCol);

customEphemerides = INPUT.customEphemerides;

[rrga1, vvga1] = customEphemerides( seq(1), tdep, 1 );
[rrga2, vvga2] = customEphemerides( seq(2), tdep+tof, 1 );

Nrev = [ 0 0 ];

[vvd, vva] = lambertMR_MEXIFY(rrga1, rrga2, tof*86400, mu, Nrev(1), Nrev(1));

dvv1 = vvd - vvga1;
dvv2 = vvga2 - vva;

dvtrue = norm(dvv1) + norm(dvv2)

abs(dvtrue - minVal)

%%

% tarr = date2mjd2000( [ 2028 3 22 12 0 0 ] );
% tof  = 100;
% 
% tdep = tarr - tof;
% 
% customEphemerides = INPUT.customEphemerides;
% 
% [rrga1, vvga1] = customEphemerides( seq(1), tdep, 1 );
% [rrga2, vvga2] = customEphemerides( seq(2), tarr, 1 );
% 
% Nrev = [ 0 0 ];
% 
% [vvd, vva] = lambertMR_MEXIFY(rrga1, rrga2, tof*86400, mu, Nrev(1), Nrev(1))
% 
% vinfd = norm(vvd - vvga1)
% vinfa = norm(vvga2 - vva)

%%

close all; clc;

NmanLeg = 1;

t0Min = date2mjd2000( [2028 7 1 12 0 0] );
t0Max = date2mjd2000( [2028 8 1 12 0 0] );

t0Min   = date2mjd2000( [ 2027 10 1 0 0 0 ] );
t0Max   = date2mjd2000( [ 2028 1 1 0 0 0 ] );
tfMax   = ( date2mjd2000( [ 2028 1 1 0 0 0 ] ) + 150 );

TOFMin = 1;
TOFMax = 200;

dv1Min = [ 0 0 0 ];
dv1Max = [ 5 2*pi 2*pi ];

dvsMin = [ 0 0 0 ];
dvsMax = [ 0 0 0 ];

epsMin = 0.01;
epsMax = 0.99;

etaMin = []; etaMax = [];
rpMin  = [];  rpMax = [];

lb = [ t0Min TOFMin dv1Min dvsMin epsMin etaMin rpMin ];
ub = [ t0Max TOFMax dv1Max dvsMax epsMax etaMax rpMax ];

seq        = [ 3 3403148 ];
costFun    = @(x) wrap_mga_nDSM_transastra_to_go(seq, x, NmanLeg, INPUT.customEphemerides);

% --> optimize using PSO
[minsol, sol, fval] = wrap_optimization_pso( costFun, lb, ub, 1 );

% --> plot the result
close all; clc;
[DV, dv, t0, tofs, MAT, output] = wrap_mga_nDSM_transastra_to_go(seq, minsol, NmanLeg, INPUT.customEphemerides, 1);

dv1                 = extract_dv1( minsol, seq );
[ rrga1, vvga1 ]    = INPUT.customEphemerides(seq(1), t0);

vvinf               = v02dv1(dv1, rrga1, vvga1);
vvsc                = vvga1 + vvinf;
[Dec, Asc]          = findDeclinationLaunch(vvsc, vvga1);
declination_deg     = rad2deg(Dec)
right_ascension_deg = rad2deg(Asc)

% name = [pwd '/results/Images/transASTRA_analysis/traj_to_go_fast_' cleaned_str '.png'];
% exportgraphics(gcf, name, 'Resolution', 1200);

% plotPLTS_tt(3, 0, 2*365.25, 1, customEphemerides, 1, 'b', {'Earth'}, 2)
% legend('Location', 'Best')

%%

NmanLeg = 1;

t0 = date2mjd2000( [ 2028 8 1 12 0 0 ] );
tof1 = 30;
tstay = 30;
mjd20002date( t0 + tof1 + tstay )


t0Min = date2mjd2000( [2028 9 30 12 0 0] );
t0Max = date2mjd2000( [2028 10 1 12 0 0] );

TOFMin = 10;
TOFMax = 200;

dv1Min = [ 1e-3 0 0 ];
dv1Max = [ 1 2*pi 2*pi ];

dvsMin = [ 0 0 0 ];
dvsMax = [ 0 0 0 ];

epsMin = 0.01;
epsMax = 0.99;

etaMin = []; etaMax = [];
rpMin  = [];  rpMax = [];

lb = [ t0Min TOFMin dv1Min dvsMin epsMin etaMin rpMin ];
ub = [ t0Max TOFMax dv1Max dvsMax epsMax etaMax rpMax ];

seq        = [ 3403148 3 ];
costFun    = @(x) wrap_mga_nDSM_transastra_to_re(seq, x, NmanLeg, INPUT.customEphemerides);

[minsol, sol, fval] = wrap_optimization_pso( costFun, lb, ub, 1 );

% name = [pwd '/results/Images/transASTRA_analysis/traj_to_re_fast_' cleaned_str '.png'];
% exportgraphics(gcf, name, 'Resolution', 1200);

close all; clc;
[DV, dv, t0, tofs, MAT, output] = wrap_mga_nDSM_transastra_to_re(seq, minsol, NmanLeg, INPUT.customEphemerides, 1);

dv1                 = extract_dv1( minsol, seq );
[ rrga1, vvga1 ]    = INPUT.customEphemerides(seq(1), t0);

vvinf               = v02dv1(dv1, rrga1, vvga1);
vvsc                = vvga1 + vvinf;
[Dec, Asc]          = findDeclinationLaunch(vvsc, vvga1);
declination_deg     = rad2deg(Dec)
right_ascension_deg = rad2deg(Asc)

%%

close all; clc;

vinf = 0.01:0.01:3;

rpt1 = 500e3;
rat1 = 1e6;

[~, mu_earth] = constants(1, 3);
vp1           = sqrt( ( 2*mu_earth )/(rpt1 + rat1)*( rat1/rpt1 ) );

[delta, vpip1, eip, Eip, aip] = Vinf2Hyperbola(vinf, rpt1, mu_earth);
dvs1 = vpip1 - vp1;

figure( 'Color', [1 1 1] );
hold on; grid on;
ylabel( 'Delta-v [km/s]' ); xlabel( 'Infinity velocity [km/s]' );

plot( vinf, dvs1, 'LineWidth', 2, 'DisplayName', [num2str(rpt1) ' km x ' num2str(rat1) ' km' ] );

rpt2 = 1e6;
rat2 = 3e6;

[~, mu_earth] = constants(1, 3);
vp2           = sqrt( ( 2*mu_earth )/(rpt2 + rat2)*( rat2/rpt2 ) );

[delta, vpip2, eip, Eip, aip] = Vinf2Hyperbola(vinf, rpt2, mu_earth);
dvs2 = vpip2 - vp2;

plot( vinf, dvs2, 'LineWidth', 2, 'DisplayName', [num2str(rpt2) ' km x ' num2str(rat2) ' km' ] );

legend( 'Location', 'Best' );

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 


