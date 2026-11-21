function [struc, revsNew, resNew, info] = buildStrucLowThrust_dvega(path, revs, res, vdep, varr, idcentral, customEphemerides)

% DESCRIPTION
% Builds the leg structure for the low-thrust conversion of an ASTRA path
% whose first leg is a DV-EGA (V-infinity leveraging + Earth gravity
% assist). The DV-EGA leg is not a single conic arc (launch - coast - DSM -
% Lambert arc - EGA), so it is split at the DSM point into two legs:
%
%   leg 1a : launch --> DSM point   (ballistic coast, or low thrust if the
%            launch v-inf exceeds the v-inf given "for free" by the launcher)
%   leg 1b : DSM point --> EGA      (low thrust replaces the DSM)
%
% All the other legs are processed exactly as in
% postProcessPathASTRA_lowThrust. The DSM point is found as the meeting
% point of the forward propagation of the launch state and the backward
% propagation of the EGA arrival state, at the DSM epoch path(2,12): this
% also checks that the path is consistent.
%
% INPUT
% - path              : ASTRA path (DV-EGA on the first leg: path(1,7) == path(2,7),
%                       path(2,10) = DSM [km/s], path(2,12) = DSM epoch [MJD2000])
% - revs              : revolutions options per leg (as in astraSolution.revs)
% - res               : resonances [K L leg, ...] (the DV-EGA triplet on leg 1 is removed)
% - vdep, varr        : v-infinity given "for free" at departure/arrival [km/s]
% - idcentral         : central body ID
% - customEphemerides : ephemerides function handle
%
% OUTPUT
% - struc   : structure for lowThrustFromASTRASolution (astraSolution.struc),
%             one more element than the legs of the path
% - revsNew : revolutions options per element of struc
% - resNew  : resonances re-indexed on the elements of struc
% - info    : DSM epoch/state, consistency errors, revolutions of the sub-legs
%
% -------------------------------------------------------------------------

if nargin < 4 || isempty(vdep), vdep = 0; end
if nargin < 5 || isempty(varr), varr = 0; end
if nargin < 6 || isempty(idcentral), idcentral = 1; end
if nargin < 7 || isempty(customEphemerides), customEphemerides = @EphSS_cartesian; end

mu = constants(idcentral, 1);

% --> standard processing of all the legs
strucStd = postProcessPathASTRA_lowThrust(path, vdep, varr, idcentral, customEphemerides);

% --> DV-EGA data
t0    = path(1,8);              % --> launch epoch
tEGA  = path(2,8);              % --> EGA epoch
tDSM  = path(2,12);             % --> DSM epoch
dsm   = path(2,10);             % --> DSM magnitude
if isnan(tDSM) || tDSM <= t0 || tDSM >= tEGA
    error('buildStrucLowThrust_dvega:dsmEpoch', ...
        'DSM epoch path(2,12) = %g is not between launch (%g) and EGA (%g).', tDSM, t0, tEGA);
end

[rE0, vE0] = customEphemerides(path(1,7), t0, idcentral);
rE0 = rE0(:)'; vE0 = vE0(:)';

% --> EGA arrival state, propagated backward to the DSM epoch (post-DSM)
rrA            = path(2,1:3);
vvA            = path(2,4:6);
[rB, vPost]    = FGKepler_dt(car2kep([rrA vvA], mu), -(tEGA - tDSM)*86400, mu);
rB = rB(:)'; vPost = vPost(:)';

% --> launch velocity: the one in the path, or v-inf along/against the
%     Earth velocity (exterior/interior DV-EGA). The candidate whose coast
%     reaches the DSM point is used.
vinfL = path(1,9);
uE    = vE0./norm(vE0);
cand  = [ path(1,4:6); vE0 + vinfL.*uE; vE0 - vinfL.*uE ];
errR  = inf(3,1);
rF    = zeros(3,3); vPre = zeros(3,3);
for k = 1:3
    if any(~isfinite(cand(k,:))), continue; end
    [r, v]    = FGKepler_dt(car2kep([rE0 cand(k,:)], mu), (tDSM - t0)*86400, mu);
    rF(k,:)   = r(:)';
    vPre(k,:) = v(:)';
    errR(k)   = norm(rF(k,:) - rB);
end
[errPos, kb] = min(errR);
vLaunch = cand(kb,:);
rDSM    = rB;                       % --> DSM point (from the EGA side)
vPreDSM = vPre(kb,:);
dvDSM   = norm(vPost - vPreDSM);

if errPos > 1e4
    warning('buildStrucLowThrust_dvega:consistency', ...
        ['Launch arc and EGA arc do not meet at the DSM epoch (%.0f km apart): ', ...
         'check the meaning of path(1,4:6) and path(2,12) in your DV-EGA version.'], errPos);
end
if abs(dvDSM - dsm) > 0.05
    warning('buildStrucLowThrust_dvega:dsm', ...
        'DSM from the reconstruction (%.3f km/s) differs from path(2,10) (%.3f km/s).', dvDSM, dsm);
end

% --> revolutions of the two sub-legs (elliptic arcs)
NrevA = nRevs([rE0 vLaunch], (tDSM - t0)*86400, mu);
NrevB = nRevs([rDSM vPost],  (tEGA - tDSM)*86400, mu);

% --> leg 1a: launch --> DSM point
s1 = strucStd(1);
a  = s1;
a.idA    = 0;                                   % --> 0 = DSM point (not a body)
a.tA     = tDSM;
a.xxDlam = [rE0 vLaunch];
a.xxAlam = [rDSM vPreDSM];
a.xxAtar = [rDSM vPreDSM];
a.xxObjA = [rDSM vPreDSM];
% --> departure: launcher gives at most vdep (same rule as the standard processing)
vinfVec = vLaunch - vE0;
if norm(vinfVec) > vdep
    vBM = vE0 + vdep.*vinfVec./norm(vinfVec);
else
    vBM = vLaunch;
end
a.xxDtar = [rE0 vBM];
a.dvvD   = vLaunch - vBM;
a.dvD    = norm(a.dvvD);
a.dvvA   = zeros(1,3);
a.dvA    = 0;

% --> leg 1b: DSM point --> EGA (low thrust replaces the DSM)
b = s1;
b.idD    = 0;
b.tD     = tDSM;
b.xxDlam = [rDSM vPost];
b.xxDtar = [rDSM vPreDSM];
b.xxObjD = [rDSM vPreDSM];
b.dvvD   = vPost - vPreDSM;
b.dvD    = dvDSM;
% --> arrival at the EGA as in the standard processing (xxAtar, dvA unchanged)

struc = [a, b, strucStd(2:end)];

% --> revolutions and resonances on the new elements
revs = revs(:)';
if numel(revs) < size(path,1) - 1
    revs = [revs zeros(1, size(path,1) - 1 - numel(revs))];
end
revsNew = [revCode(NrevA), revCode(NrevB), revs(2:end)];

resNew = [];
if ~isempty(res)
    R = reshape(res(:)', 3, [])';
    R(R(:,3) == 1, :) = [];             % --> DV-EGA triplet on leg 1
    R(:,3) = R(:,3) + 1;                % --> one more element before the other legs
    resNew = reshape(R', 1, []);
end

info.tDSM          = tDSM;
info.rDSM          = rDSM;
info.vPreDSM       = vPreDSM;
info.vPostDSM      = vPost;
info.dvDSM         = dvDSM;
info.dsmPath       = dsm;
info.vLaunch       = vLaunch;
info.launchChoice  = kb;                % --> 1 = path(1,4:6), 2 = exterior, 3 = interior
info.posMismatchKm = errPos;
info.NrevA         = NrevA;
info.NrevB         = NrevB;

end

% =========================================================================
function N = nRevs(x, tof, mu)
% Complete revolutions of the Keplerian arc from state x over tof [s].
r = norm(x(1:3)); v = norm(x(4:6));
a = 1/(2/r - v^2/mu);
if a <= 0
    N = 0;
else
    N = floor( tof/(2*pi*sqrt(a^3/mu)) );
end
end

function c = revCode(N)
% revs code used by rev2RevOpt: 0 --> [0 0], N>0 --> [N 1]
if N == 0
    c = 0;
else
    c = 10*N + 1;
end
end