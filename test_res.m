
clearDeleteAdd; % --> !!! ONLY CALL IT ONCE FOR SPEED

%%

idcentral = 6;
pl        = 1;

muCentral = constants(idcentral, pl);

t0        = 0;

vinf = 0.35;
N    = 13;
M    = 12;
k0   = deg2rad(50);

[rrga1, vvga1] = EphSS_cartesian(pl, t0, idcentral);
kepga1         = car2kep( [rrga1, vvga1], muCentral );
sma            = kepga1(1);

r_fb = norm(rrga1);
v_fb = norm(vvga1);

body_revolutions = N;
sc_revolutions   = M;

flyby_body_period = 2*pi*sqrt( sma^3/muCentral );
sc_orbital_period = flyby_body_period * body_revolutions / sc_revolutions;
tof               = flyby_body_period * body_revolutions;

alpha = resonant_pump_angle(muCentral, sc_orbital_period, r_fb, v_fb, vinf);

[vinfCAR, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf, alpha, k0, t0, pl, idcentral);
[rrf, vvf, kep2]    = FGCar_dt(rr1, vv1, tof, muCentral);

[rrga2, vvga2]      = EphSS_cartesian(pl, t0 + tof/86400, idcentral);

%%

[~, AU]   = planetConstants(idcentral);
[tt,yysc] = propagateKepler_tof(rr1, vv1, tof, muCentral);

figECI = plotPLTS_tt(pl, t0, t0 + tof/86400, idcentral);

hold on;

plot3( yysc(:,1)./AU, yysc(:,2)./AU, yysc(:,3)./AU );
