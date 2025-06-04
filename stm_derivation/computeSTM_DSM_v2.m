function [dv, tf, ratio, defect, dvv, rr1, vv1, DU, CC, tof] = computeSTM_DSM_v2(PATH, row, t0, idcentral, customEphemerides)

% --> t0 is the time at which the DSM occurs

if nargin == 3
    idcentral = 1;
    customEphemerides = @EphSS_cartesian;
elseif nargin == 4
    if isempty(idcentral)
        idcentral = 1;
    end
    customEphemerides = @EphSS_cartesian;
elseif nargin == 5
    if isempty(idcentral)
        idcentral = 1;
    end
    if isempty(customEphemerides)
        customEphemerides = @EphSS_cartesian;
    end
end

% constants of motion
% mu = 132724487690;
mu = constants(idcentral, 1);

tof  = PATH(row+1, 11);
if row == 1
    rr1  = PATH(row, 1:3);
    vv1  = PATH(row, 4:6);
else
    rrIN       = PATH(row+1, 1:3);
    vvIN       = PATH(row+1, 4:6);
    kepIN      = car2kep([rrIN vvIN], mu);
    [rr1, vv1] = FGKepler_dt(kepIN, -tof*86400, mu);
end

pl2  = PATH(row+1, 7);
tpl2 = PATH(row+1, 8);

% VINFSold  = vInfDepArr(PATH);
VINFS = path2Vinfs(PATH, idcentral, customEphemerides);
VINFS = [VINFS PATH(2:end,10)];

if row == size(PATH,1)-1
    % --> you are on the last leg
    defect = VINFS(end,4);
else
    defect = VINFS(row+1, 5);
end

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
[~, vvpl] = EphSS_car(pl2, tpl2);
vrel      = (vvf - vvpl)./norm(vvf - vvpl);
vrelerror = defect;
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

CC = [Ctl, Ctr; Cbl, Cbr];
% controlla se CC è ben-condizionata o mal-condizionata
RANK    = rank(CC);
RANKmax = size(CC,1);
%%%% compute constraints %%%%

%%%% compute control %%%%
vec = [0 0 0 -vrelerror]';
if RANK < RANKmax
    % then CC is ill-conditioned
    [U,S,V] = svd(CC);
    s       = diag(S);
    k       = sum(s> 1e-17);
    CCinv   = (U(:, 1: k)* diag(1./ s(1: k))* V(:, 1: k)')';
    DU      = CCinv*vec;
else
    DU  = CC\vec;
end
DU  = DU';

dvv = DU(1:3);     % DSM vector [DSMv, DSMp, DSMn]  (km/s)
dv  = norm(dvv);   % DSM magnitude                  (km/s)
tf  = DU(4)/86400; % correction on the arrival time (days)
%%%% compute control %%%%

ratio = defect/dv;

end