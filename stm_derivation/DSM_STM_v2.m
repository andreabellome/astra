function [CC] = DSM_STM_v2(tof, vvpl, cartIN, t0)

mu = 132724487690; % --> constants of motion

rrIN       = cartIN(1:3);
vvIN       = cartIN(4:6);
kepIN      = car2kep([rrIN vvIN], mu);
[rr1, vv1] = FGKepler_dt(kepIN, -tof*86400, mu);

%%%% propagate until the time of the DSM
kep1       = car2kep([rr1, vv1], mu);
[rrm, vvm] = FGKepler_dt(kep1, t0*86400, mu);
%%%% propagate until the time of the DSM

%%%% find (Vv, Vp, Vn) at the time of the DSM %%%%
nnm = cross(rrm, vvm)./norm(cross(rrm, vvm)); % normal to orbital plane

Vv  = vvm./norm(vvm);                          % along vvm
Vp  = eulerAxisAngle(Vv, nnm, pi/2); Vp = Vp'; % in-orbit-plane, perpendicular to vvm
Vn  = cross(Vv, Vp);                           % out-of-plane normal
%%%% find (Vv, Vp, Vn) at the time of the DSM %%%%

%%%% compute STM between t0 and tf %%%%
dt                          = (tof - t0)*86400;
anNum                       = 1;
[~, ~, vvf, drfdv0, dvfdv0] = compute_keplerian_STM(rrm, vvm, dt, mu, anNum);
%%%% compute STM between t0 and tf %%%%

%%%% planet relative velocity at tf %%%%
vrel      = (vvf - vvpl)./norm(vvf - vvpl);
%%%% planet relative velocity at tf %%%%

%%%% compute constraints %%%%
dvfdvv = dvfdv0*Vv';
dfvdvp = dvfdv0*Vp';
dvfdvn = dvfdv0*Vn';

C1 = drfdv0*Vv';
C2 = drfdv0*Vp';
C3 = drfdv0*Vn';

C4 = dot(dvfdvv, vrel');
C5 = dot(dfvdvp, vrel');
C6 = dot(dvfdvn, vrel');

Ctl = [C1 C2 C3];
Ctr = vvf' - vvpl';
Cbl = [C4 C5 C6];
Cbr = 0;

CC  = [Ctl, Ctr; Cbl, Cbr];
%%%% compute constraints %%%%

end