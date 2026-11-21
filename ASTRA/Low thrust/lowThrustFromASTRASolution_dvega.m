function [LT_SOLUTION, struc, info] = lowThrustFromASTRASolution_dvega( astraSolution, lowThrustParameters, idcentral, customEphemerides )

% DESCRIPTION
% Low-thrust conversion of an ASTRA solution, also when the first leg is a
% DV-EGA (same body twice at the start of the sequence, e.g. [3 3 5 ...]).
%
% If the path has no DV-EGA, this is exactly lowThrustFromASTRASolution.
% With a DV-EGA, the first leg is split at the DSM point (see
% buildStrucLowThrust_dvega) and the resulting legs are passed to
% lowThrustFromASTRASolution through astraSolution.struc:
%
%   LT_SOLUTION(1) : launch --> DSM point  (coast, or thrust if v-inf > vdep_free)
%   LT_SOLUTION(2) : DSM point --> EGA     (the DSM is replaced by low thrust)
%   LT_SOLUTION(3:end) : the other legs, as usual
%
% INPUT/OUTPUT: same as lowThrustFromASTRASolution, plus
% - info : DV-EGA reconstruction data (DSM point and epoch, DSM magnitude,
%          consistency check, revolutions of the two sub-legs). Empty if the
%          path has no DV-EGA.
%
% -------------------------------------------------------------------------

if nargin < 3 || isempty(idcentral), idcentral = 1; end
if nargin < 4 || isempty(customEphemerides), customEphemerides = @EphSS_cartesian; end

path  = astraSolution.path;
info  = [];

isDVEGA = size(path,1) >= 2 && path(1,7) == path(2,7) && size(path,2) >= 12 && ...
          isfinite(path(2,12)) && path(2,12) > path(1,8) && path(2,12) < path(2,8);

if ~isDVEGA || (isfield(astraSolution, 'struc') && ~isempty(astraSolution.struc))
    [LT_SOLUTION, struc] = lowThrustFromASTRASolution(astraSolution, lowThrustParameters, idcentral, customEphemerides);
    return;
end

vdep = 0; varr = 0;
if isfield(astraSolution, 'vdep_free') && ~isempty(astraSolution.vdep_free), vdep = astraSolution.vdep_free; end
if isfield(astraSolution, 'varr_free') && ~isempty(astraSolution.varr_free), varr = astraSolution.varr_free; end
res = [];
if isfield(astraSolution, 'res'), res = astraSolution.res; end
revs = zeros(1, size(path,1)-1);
if isfield(astraSolution, 'revs') && ~isempty(astraSolution.revs), revs = astraSolution.revs; end

[strucDV, revsNew, resNew, info] = buildStrucLowThrust_dvega(path, revs, res, vdep, varr, idcentral, customEphemerides);

fprintf(['DV-EGA leg split at the DSM point (%s): DSM %.3f km/s, ', ...
         'launch-DSM %d rev, DSM-EGA %d rev, mismatch %.1f km\n'], ...
    datestr(mjd20002date(info.tDSM), 'dd-mmm-yyyy'), info.dvDSM, info.NrevA, info.NrevB, info.posMismatchKm);

sol       = astraSolution;
sol.struc = strucDV;
sol.revs  = revsNew;
sol.res   = resNew;

[LT_SOLUTION, struc] = lowThrustFromASTRASolution(sol, lowThrustParameters, idcentral, customEphemerides);

end