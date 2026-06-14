
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%%

idcentral = 1;                            % --> central body (Saturn in this case)
idmoon    = 2;                            % --> flyby body (Titan in this case)
muCentral = constants(idcentral, idmoon); % --> gravitational constant of the central body [km3/s2]
epoch     = 0;                            % --> initial epoch [MJD2000]
vinf_norm = 10;                          % --> infinity velocity [km/s]
AU        = 149597870.7;

%% --> Test VILTs

% --> select the VILT anatomy
N     = 2;
M     = 1;
L     = 0;
type  = 81;  % --> 1.INBOUND, 8.OUTBOUND
kei   = +1;  % --> +1 for manoeuvre at APOAPSIS, -1 for manoeuvre at PERIAPSIS

vinf1 = 10;
vinf2 = 12.5;

% --> solve the VILT
[vinf1, alpha1, crank1, vinf2, alpha2, crank2, DV, tof1, tof2] = ...
    wrap_vInfinityLeveraging(type, N, M, L, kei, vinf1, vinf2, idmoon, idcentral, 1);
toftot = tof1 + tof2; % --> total time of flight

%%

INPUT.customEphemerides = @EphSS_from_mice_workaround;
customEphemerides       = INPUT.customEphemerides;

t0 = date2mjd2000( [2030 1 1 0 0 0] );
t1 = t0 + toftot / 86400;

[rrga0, vvga0] = customEphemerides(idmoon, t0, idcentral);
kepga0         = car2kep( [rrga0, vvga0], muCentral );

alpha = alpha1; k = crank1; vinf = vinf1; 
kepga = kepga0;
rrga  = rrga0; vvga = vvga0;

% V-infinity in TCN (your existing convention: alpha = in-plane angle from T,
% k = out-of-plane / clock angle)
vinfTCN = vinf .* [ cos(alpha), -sin(alpha)*sin(k), sin(alpha)*cos(k) ];

% --> from TCN to inertial frame
[dv_tcn, rot_mat2] = to_TCN(rrga0, vvga0, vinfTCN);
rot_mat            = rot_mat2'; % from TCN to inertial

% Rotate to inertial Cartesian
vinfCAR = (rot_mat * vinfTCN')';

rr0  = rrga0;
vv0  = vvga0 + vinfCAR;
kep0 = car2kep( [rr0, vv0], muCentral );

[rrga1, vvga1] = customEphemerides(idmoon, t1, idcentral);

if kei == +1; apse = 'apo'; else; apse = 'peri'; end

[dt, rr_out, vv_out] = time_to_apse(rr0, vv0, muCentral, apse, L);

[tt, yy] = propagateKepler_tof(rr0, vv0, dt, muCentral);

Nrev     = [0 0];
tof_full = t1 - t0;
tof_1    = dt/86400;
tof_2    = tof_full - tof_1;
[VI, VF] = lambertMR_vM_MEXIFY(rr_out, rrga1, tof_2 * 86400, muCentral, Nrev(1), Nrev(2));
dv       = norm( VI - vv_out );

[tt,yy2] = propagateKepler_tof(rr_out, VI, tof_2 * 86400, muCentral);

%%

close all; clc; 

fig = figure('Color', [1 1 1]);
hold on; grid on;

plotPLTS_tt(idmoon, t0, t1, idcentral, customEphemerides, 1);

plot3( rr0(1)/AU, rr0(2)/AU, rr0(3)/AU, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'red' );
plot3( yy(:,1)./AU, yy(:,2)./AU, yy(:,3)./AU, 'LineWidth', 2);
plot3( yy2(:,1)./AU, yy2(:,2)./AU, yy2(:,3)./AU, 'LineWidth', 2);

plot3( rr_out(1)/AU, rr_out(2)/AU, rr_out(3)/AU, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'red' );
plot3( rrga1(1)/AU, rrga1(2)/AU, rrga1(3)/AU, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'red' );

% plot3( rr1(1)/AU, rr1(2)/AU, rr1(3)/AU, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'red' );

