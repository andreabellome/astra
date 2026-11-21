function [LEGSn, VASn, VINFn, nLP, nDEF] = wrap_DynProgr_st2_fast(LEGSnext, VASnext, legs, runOpts, indl, tstep, TOF_LIM, INPUT)

% DESCRIPTION:
% Fast, vectorised version of wrap_DynProgr_st2 for one leg (any leg after
% the first), meant for ASTRA with INPUT.opt = 3 (SODP by launch date).
% Each leg has its own cache, so several legs can use it at the same time.
%
% Same results as wrap_DynProgr_st2 with the default cost function
% (costFunction1_DP) and default pruning (wrap_Pruning_DP), but:
%   1) the Lambert arcs (flyby epoch, arrival epoch) and the ephemerides
%      are CACHED across launch dates. The arc only depends on the two
%      epochs (not on the launch date), so with opt = 3 the same arcs were
%      solved again for every launch date. Here each arc is solved once.
%   2) defects, pruning and min-cost selection are vectorised over all
%      (incoming state, arc) pairs instead of one MATLAB call per arc.
%
% Usage:
%   - INPUT.fastLastLeg = true : fast version on the last leg
%   - INPUT.fastAllLegs = true : fast version on all legs after the first
%     (non-resonant ones; resonant legs keep their own routine)
%   - INPUT.fastLastLegCacheMB : max size of ONE cache (MB, default 1000)
%   - INPUT.fastCacheTotalMB   : max size of ALL the caches together
%     (MB, default 3000); the least recently used caches are dropped first
%   - wrap_DynProgr_st2_fast('reset') clears the caches (done automatically
%     by ASTRA_dates before/after the loop over launch dates)
%   - S = wrap_DynProgr_st2_fast('stats') returns the number of calls, of
%     Lambert arcs solved and of arcs reused from the caches
%
% There is one cache per (leg, revolutions option): with multi-rev runs
% ASTRA calls the same leg with different Nrev/branch for each launch date,
% and each option keeps its own arcs.
%
% If a custom INPUT.costFunc1 is used, the function falls back to the
% original wrap_DynProgr_st2.
%
% INPUT/OUTPUT: same as wrap_DynProgr_st2.
%
% -------------------------------------------------------------------------

persistent CACHE STATS USE LAST   % --> caches (one per leg and revolutions option), counters, last run summary

if isempty(CACHE) || ~isa(CACHE, 'containers.Map')
    CACHE = containers.Map('KeyType', 'char', 'ValueType', 'any');
end
if isempty(STATS)
    STATS = struct('calls', 0, 'arcsSolved', 0, 'arcsReused', 0, 'cacheResets', 0);
end
if isempty(USE), USE = 0; end

% --> cache reset / statistics
if ischar(LEGSnext) || isstring(LEGSnext)
    if strcmpi(LEGSnext, 'reset')
        if STATS.calls > 0
            LAST = summarise(CACHE, STATS);   % --> keep the statistics of the run that just ended
        end
        CACHE = containers.Map('KeyType', 'char', 'ValueType', 'any');
        STATS = struct('calls', 0, 'arcsSolved', 0, 'arcsReused', 0, 'cacheResets', 0);
        USE   = 0;
    elseif strcmpi(LEGSnext, 'stats')
        if STATS.calls > 0
            LEGSn = summarise(CACHE, STATS);  % --> current run
        else
            LEGSn = LAST;                     % --> last completed run
        end
        if ~isempty(LEGSn) && nargout == 0
            disp(LEGSn.totals); disp(LEGSn.perCache);
        end
    end
    return;
end

% --> fallback for non-default cost functions
if ~isDefaultCost(INPUT.costFunc1)
    INPUT.fastLastLeg = false;
    [LEGSn, VASn, VINFn, nLP, nDEF] = wrap_DynProgr_st2(LEGSnext, VASnext, legs, runOpts, indl, tstep, TOF_LIM, INPUT);
    return;
end

idcentral = INPUT.idcentral;
mu        = constants(idcentral, 1);
dvLim     = INPUT.dsmOpts(1);
dvTotLim  = INPUT.dsmOpts(2);
ephFun    = INPUT.customEphemerides;

vinflim = [];
if isfield(INPUT, 'vInfLim'), vinflim = INPUT.vInfLim; end
tofyMax = [];
if isfield(INPUT, 'tofyMax'), tofyMax = INPUT.tofyMax; end

pl1   = legs(indl,1);
pl2   = legs(indl,2);
optMR = runOpts(indl,:);

% --> TOF grid of the leg (same as the original)
TOFS = wrap_TOFs(pl1, pl2, optMR, tstep, TOF_LIM, indl);
TOFS = TOFS(:);
nT   = numel(TOFS);

LEGSn = [];
VASn  = [];
VINFn = [];
if isempty(LEGSnext) || nT == 0
    nLP  = 0;
    nDEF = 0;
    return;
end
nDEF = numberOfDefects(LEGSnext, TOFS);

% --> flyby body constants (same as the original)
if idcentral == 1
    if pl1 > 11
        muPL  = 0;
        rpmin = 1000;
    else
        [muPL, radius] = planetConstants(pl1);
        rpmin          = maxmin_flybyAltitude(pl1) + radius;
    end
else
    [~, muPL, ~, radpl, hmin] = constants(idcentral, pl1);
    rpmin                     = radpl + hmin;
end

% --> group the incoming states by flyby epoch (exact match, stable order,
%     as in the original: T0 = unique(LEGSnext(:,end),'stable'))
T0           = unique(LEGSnext(:,end), 'stable');
T0           = T0(:);
[~, gid]     = ismember(LEGSnext(:,end), T0);
gid          = gid(:);
nG           = numel(T0);
nLP          = nG*nT;
[~, ordPrev] = sort(gid);                     % --> stable: original order within group
ordPrev      = ordPrev(:);
cnt          = accumarray(gid, 1, [nG 1]);
gStart       = cumsum([1; cnt(1:end-1)]);

% --> quantities of the incoming states needed below
w        = size(LEGSnext,2);
prevCost = sum(LEGSnext(:,3:3:end-2), 2);     % --> costFunction1_DP
if w >= 8
    prevDef = sum(LEGSnext(:,6:3:end-2), 2);  % --> prune_DEFECTtot_DP
else
    prevDef = zeros(size(LEGSnext,1),1);
end
Wn    = w + 3;                                % --> width of the new rows
nplts = numel(1:3:Wn-1);                      % --> as in prune_VINFn_DP

% --> cache of this leg and revolutions option. It is taken OUT of the map
%     before being updated, so that MATLAB updates it in place (no copy).
sig = sprintf('%d|%d|%d|%s|%.8f|%.8f|%d|%d', indl, pl1, pl2, mat2str(optMR), TOFS(1), TOFS(end), nT, idcentral);
STATS.calls = STATS.calls + 1;
if isKey(CACHE, sig)
    E = CACHE(sig);
    remove(CACHE, sig);
else
    E = initCache(sig, nT);
end

% --> evict the epochs that have not been requested in the last 'age'
%     calls of this cache. (The same leg is called several times per launch
%     date, once per revolutions option of the previous legs, with very
%     different epoch ranges: evicting by "earlier than the current minimum"
%     threw away epochs that the next call needed.) Evicted epochs are just
%     recomputed if requested again: results do not change.
kT0      = round(T0*1e5);
E.nCalls = E.nCalls + 1;
age      = 60;
if isfield(INPUT, 'fastCacheAge') && ~isempty(INPUT.fastCacheAge)
    age = INPUT.fastCacheAge;
end
E = evictCache(E, E.nCalls - age, kT0, round(TOFS(1)*1e5));

% --> hard cap on the cache size (MB): if exceeded, restart the cache
cacheMB = 1000;
if isfield(INPUT, 'fastLastLegCacheMB') && ~isempty(INPUT.fastLastLegCacheMB)
    cacheMB = INPUT.fastLastLegCacheMB;
end
bytesPerRow = 8*(7*nT + 4);
if (E.N + nG)*bytesPerRow > cacheMB*2^20
    keepCnt = [E.nSolved E.nReused E.nCalls E.nResets];
    E = initCache(sig, nT);
    E.nSolved = keepCnt(1); E.nReused = keepCnt(2); E.nCalls = keepCnt(3); E.nResets = keepCnt(4) + 1;
    E.indl = indl; E.pl = [pl1 pl2]; E.optMR = optMR(1:2);
    STATS.cacheResets = STATS.cacheResets + 1;
end

% --> make sure all flyby epochs are in the cache
[found, row] = ismember(kT0, E.keys(1:E.N));
found        = found(:);
row          = row(:);
STATS.arcsReused = STATS.arcsReused + sum(found)*nT;
E.nReused        = E.nReused + sum(found)*nT;
if any(~found)
    newG               = find(~found);
    [E, rowsNew]       = addEpochs(E, T0(newG), TOFS, pl1, pl2, mu, optMR, idcentral, ephFun);
    row(newG)          = rowsNew;
    STATS.arcsSolved   = STATS.arcsSolved + numel(newG)*nT;
    E.nSolved          = E.nSolved + numel(newG)*nT;
end
E.lastUse(row) = E.nCalls;                    % --> epochs requested in this call
E.indl   = indl; E.pl = [pl1 pl2]; E.optMR = optMR(1:2);
cap = size(E.keys,1);

% --> total memory of all the caches: drop the least recently used ones
totMB = 3000;
if isfield(INPUT, 'fastCacheTotalMB') && ~isempty(INPUT.fastCacheTotalMB)
    totMB = INPUT.fastCacheTotalMB;
end
USE    = USE + 1;
E.used = USE;
ks     = keys(CACHE);
if ~isempty(ks)
    used = zeros(1, numel(ks)); mbs = zeros(1, numel(ks));
    for i = 1:numel(ks)
        Ei      = CACHE(ks{i});
        used(i) = Ei.used;
        mbs(i)  = cacheBytes(Ei)/2^20;
    end
    clear Ei
    [~, o] = sort(used);                      % --> oldest first
    tot    = sum(mbs) + cacheBytes(E)/2^20;
    i = 1;
    while tot > totMB && i <= numel(o)
        remove(CACHE, ks{o(i)});
        tot = tot - mbs(o(i));
        STATS.cacheResets = STATS.cacheResets + 1;
        i = i + 1;
    end
end

% --> loop over chunks of flyby epochs (bounded memory)
maxPairs = 5e5;
if isfield(INPUT, 'fastLastLegMaxPairs') && ~isempty(INPUT.fastLastLegMaxPairs)
    maxPairs = INPUT.fastLastLegMaxPairs;
end
cellL = {}; cellV = {}; cellI = {};
g1 = 1;
while g1 <= nG

    % --> chunk of groups
    cs = cumsum(cnt(g1:end))*nT;
    ng = find(cs <= maxPairs, 1, 'last');
    if isempty(ng), ng = 1; end
    gsv = (g1:g1+ng-1)';
    g1  = g1 + ng;

    % --> arcs: group-major, TOF ascending (same order as generateMAT)
    nA    = ng*nT;
    arcG  = repelem(gsv, nT);
    arcK  = repmat((1:nT)', ng, 1);
    rC    = reshape(row(arcG), [], 1);
    li    = rC + (arcK-1)*cap;                % --> linear index in cap x nT
    off3  = cap*nT;
    vvd   = [reshape(E.D(li),[],1) reshape(E.D(li+off3),[],1) reshape(E.D(li+2*off3),[],1)];
    vva   = [reshape(E.A(li),[],1) reshape(E.A(li+off3),[],1) reshape(E.A(li+2*off3),[],1)];
    vinfA = reshape(E.VI(li), [], 1);
    vJ    = E.vJ(rC,:);
    vrelD = vvd - vJ;
    vD    = sqrt(sum(vrelD.^2,2));

    % --> pairs (incoming state, arc)
    nPer    = reshape(cnt(arcG), [], 1);
    nP      = sum(nPer);
    pArc    = repelem((1:nA)', nPer);
    first   = cumsum([0; nPer(1:end-1)]);
    off     = (1:nP)' - repelem(first, nPer);
    pPrev   = reshape(ordPrev( reshape(gStart(arcG(pArc)),[],1) + off - 1 ), [], 1);

    vrelA   = VASnext(pPrev,:) - vJ(pArc,:);
    vA      = sqrt(sum(vrelA.^2,2));
    dvapp   = abs(reshape(vD(pArc),[],1) - vA);
    k       = dvapp <= dvLim;                 % --> NaN --> false (pruned anyway)
    pArc    = pArc(k);
    pPrev   = pPrev(k);
    vrelA   = vrelA(k,:);
    vA      = vA(k);
    if isempty(pArc), continue; end

    % --> defects (vectorised findDV)
    dv = findDV_vec(vrelA, vA, vrelD(pArc,:), reshape(vD(pArc),[],1), muPL, rpmin);

    % --> pruning (wrap_Pruning_DP)
    k = ~isnan(dv) & (dv <= dvLim) & ((reshape(prevDef(pPrev),[],1) + dv) <= dvTotLim);
    if ~isempty(vinflim)
        vi = reshape(vinfA(pArc), [], 1);
        k  = k & ~(vi < vinflim(nplts,1) | vi > vinflim(nplts,2));
    end
    t2 = reshape(T0(arcG), [], 1) + TOFS(arcK);               % --> same as generateMAT
    if ~isempty(tofyMax)
        k = k & ~( (reshape(t2(pArc),[],1) - LEGSnext(pPrev,2))./365.25 > tofyMax );
    end
    if isfield(INPUT, 'ltLimit') && ~isempty(INPUT.ltLimit)   % --> low-thrust feasibility (prune_DEFECT_LT_DP)
        lt    = INPUT.ltLimit;
        eta   = 0.6; if isfield(lt, 'eta')  && ~isempty(lt.eta),  eta  = lt.eta;  end
        varr  = 0;   if isfield(lt, 'varr') && ~isempty(lt.varr), varr = lt.varr; end
        dvMax = eta*(lt.Tmax/lt.m0).*TOFS(arcK(pArc)).*86400./1000;
        dvReq = dv;
        if isfield(lt, 'arrival') && lt.arrival && isfield(lt, 'nBodies') && ~isempty(lt.nBodies) && ...
                (Wn + 1)/3 == lt.nBodies
            dvReq = dvReq + max(reshape(vinfA(pArc),[],1) - varr, 0);
        end
        k = k & (dvReq <= dvMax);
    end
    pArc  = pArc(k);
    pPrev = pPrev(k);
    dv    = dv(k);
    if isempty(pArc), continue; end

    % --> min cost per arc (costFunction1_DP, first index on ties)
    cost     = reshape(prevCost(pPrev), [], 1) + dv;
    [~, o]   = sortrows([pArc cost]);         % --> stable
    pA       = pArc(o);
    best     = o([true; diff(pA) ~= 0]);
    a        = pArc(best);

    cellL{end+1,1} = [ LEGSnext(pPrev(best),:) reshape(dv(best),[],1) pl2.*ones(numel(a),1) reshape(t2(a),[],1) ]; %#ok<AGROW>
    cellV{end+1,1} = vva(a,:);  %#ok<AGROW>
    cellI{end+1,1} = reshape(vinfA(a), [], 1);  %#ok<AGROW>

end

if ~isempty(cellL)
    LEGSn = cell2mat(cellL);
    VASn  = cell2mat(cellV);
    VINFn = cell2mat(cellI);
end

CACHE(sig) = E;                               % --> put the (updated) cache back

end

% =========================================================================
function b = cacheBytes(E)
b = 8*( numel(E.keys) + numel(E.vJ) + numel(E.D) + numel(E.A) + numel(E.VI) + ...
        numel(E.arrKeys) + numel(E.arrR) + numel(E.arrV) );
end

% =========================================================================
function tf = isDefaultCost(f)
s  = regexprep(func2str(f), '\s', '');
tf = strcmp(s, '@(legn,vvf,vinff)costFunction1_DP(legn,vvf,vinff)') || ...
     strcmp(s, 'costFunction1_DP');
end

% =========================================================================
function E = evictCache(E, minUse, kNow, tof1Key)
% Removes the cached flyby epochs last requested before call minUse
% (except those requested now, kNow), and the arrival epochs earlier than
% the earliest flyby epoch still needed + the min TOF. Compaction only when
% at least 25% can be removed.
if E.N > 0
    keep = E.lastUse(1:E.N) >= minUse | ismember(E.keys(1:E.N), kNow);
    if sum(~keep) >= 0.25*E.N
        idx       = find(keep);
        n         = numel(idx);
        cap       = max(1024, ceil(1.25*n));
        E.keys    = [E.keys(idx);    zeros(cap-n,1)];
        E.lastUse = [E.lastUse(idx); zeros(cap-n,1)];
        E.vJ      = [E.vJ(idx,:);    zeros(cap-n,3)];
        E.D       = cat(1, E.D(idx,:,:), zeros(cap-n, E.nT, 3));
        E.A       = cat(1, E.A(idx,:,:), zeros(cap-n, E.nT, 3));
        E.VI      = [E.VI(idx,:);    zeros(cap-n, E.nT)];
        E.N       = n;
    end
end
minArrKey = min([E.keys(1:E.N); kNow(:)]) + tof1Key;
if E.arrN > 0
    keep = E.arrKeys(1:E.arrN) >= minArrKey;
    if sum(~keep) >= 0.25*E.arrN
        idx       = find(keep);
        n         = numel(idx);
        cap       = max(4096, ceil(1.25*n));
        E.arrKeys = [E.arrKeys(idx); zeros(cap-n,1)];
        E.arrR    = [E.arrR(idx,:);  zeros(cap-n,3)];
        E.arrV    = [E.arrV(idx,:);  zeros(cap-n,3)];
        E.arrN    = n;
    end
end
end

% =========================================================================
function E = initCache(sig, nT)
cap0  = 1024;
E.sig = sig;
E.nT  = nT;
E.N   = 0;
E.keys = zeros(cap0,1);
E.lastUse = zeros(cap0,1);   % --> last call in which each epoch was requested
E.vJ   = zeros(cap0,3);
E.D    = zeros(cap0,nT,3);   % --> Lambert departure velocity
E.A    = zeros(cap0,nT,3);   % --> Lambert arrival velocity
E.VI   = zeros(cap0,nT);     % --> arrival v-infinity norm
% --> arrival-body ephemerides cache
E.arrN    = 0;
E.arrKeys = zeros(4*cap0,1);
E.arrR    = zeros(4*cap0,3);
E.arrV    = zeros(4*cap0,3);
E.used    = 0;
E.nSolved = 0; E.nReused = 0; E.nCalls = 0; E.nResets = 0;
E.indl    = NaN; E.pl = [NaN NaN]; E.optMR = [NaN NaN];
end

% =========================================================================
function R = summarise(CACHE, STATS)
% Statistics of the run: totals and one row per cache (leg, revolutions option).
ks = keys(CACHE);
n  = numel(ks);
leg = zeros(n,1); from = zeros(n,1); to = zeros(n,1); Nrev = zeros(n,1); branch = zeros(n,1);
calls = zeros(n,1); solved = zeros(n,1); reused = zeros(n,1); resets = zeros(n,1);
epochs = zeros(n,1); MB = zeros(n,1);
for i = 1:n
    E = CACHE(ks{i});
    leg(i) = E.indl; from(i) = E.pl(1); to(i) = E.pl(2); Nrev(i) = E.optMR(1); branch(i) = E.optMR(2);
    calls(i) = E.nCalls; solved(i) = E.nSolved; reused(i) = E.nReused; resets(i) = E.nResets;
    epochs(i) = E.N; MB(i) = cacheBytes(E)/2^20;
end
reusePct = 100*reused./max(solved + reused, 1);
tot = STATS;
tot.reusePct = 100*STATS.arcsReused/max(STATS.arcsSolved + STATS.arcsReused, 1);
tot.nCaches  = n;
tot.cacheMB  = sum(MB);
try
    R.perCache = sortrows(table(leg, from, to, Nrev, branch, calls, solved, reused, reusePct, resets, epochs, MB), {'leg','Nrev','branch'});
    R.totals   = struct2table(tot);
catch   % --> no table (e.g. Octave): plain matrix with the same columns
    R.perCache = sortrows([leg from to Nrev branch calls solved reused reusePct resets epochs MB], [1 4 5]);
    R.totals   = tot;
end
end

% =========================================================================
function [E, rows] = addEpochs(E, tNew, TOFS, pl1, pl2, mu, optMR, idcentral, ephFun)

tNew = tNew(:);
nNew = numel(tNew);
nT   = numel(TOFS);

% --> grow the cache if needed (capacity doubling)
need = E.N + nNew;
cap  = size(E.keys,1);
if need > cap
    newCap      = max(need, ceil(1.25*cap));
    E.keys(newCap,1)    = 0;
    E.lastUse(newCap,1) = 0;
    E.vJ(newCap,3)      = 0;
    E.D(newCap,nT,3)    = 0;
    E.A(newCap,nT,3)    = 0;
    E.VI(newCap,nT)     = 0;
end

% --> departure body states
rr1 = zeros(nNew,3); vv1 = zeros(nNew,3);
for i = 1:nNew
    [rr, vv]  = ephFun(pl1, tNew(i), idcentral);
    rr1(i,:)  = rr(:)';
    vv1(i,:)  = vv(:)';
end

% --> arrival epochs (nNew x nT) and arrival body states (cached)
tA  = tNew + TOFS';                 % --> same as generateMAT: T0 + TOFS
tAv = tA(:);
kA  = round(tAv*1e5);
[uk, ia, ic] = unique(kA);
[fA, rA]     = ismember(uk, E.arrKeys(1:E.arrN));
miss         = find(~fA);
if ~isempty(miss)
    nm   = numel(miss);
    needA = E.arrN + nm;
    if needA > size(E.arrKeys,1)
        cA = max(needA, 2*size(E.arrKeys,1));
        E.arrKeys(cA,1) = 0; E.arrR(cA,3) = 0; E.arrV(cA,3) = 0;
    end
    for j = 1:nm
        [rr, vv] = ephFun(pl2, tAv(ia(miss(j))), idcentral);
        E.arrN               = E.arrN + 1;
        E.arrKeys(E.arrN)    = uk(miss(j));
        E.arrR(E.arrN,:)     = rr(:)';
        E.arrV(E.arrN,:)     = vv(:)';
        rA(miss(j))          = E.arrN;
    end
end
rowA = reshape(rA(ic), [], 1);
rr2  = E.arrR(rowA,:);
vv2  = E.arrV(rowA,:);

% --> Lambert arcs (one per (flyby epoch, arrival epoch))
nArc = nNew*nT;
iDep = repmat((1:nNew)', nT, 1);    % --> column-major index of tA
tofD = tAv - tNew(iDep);            % --> same as MAT(:,4) - MAT(:,2)
Dl   = nan(nArc,3);
Al   = nan(nArc,3);
for j = 1:nArc
    i = iDep(j);
    try
        [vvd, vva] = lambertMR_MEXIFY_mex(rr1(i,:), rr2(j,:), tofD(j)*86400, mu, optMR(1), optMR(2));
    catch
        [~,~,~,~,vvd, vva] = lambertMR_CER(rr1(i,:), rr2(j,:), tofD(j)*86400, mu, 0, optMR(1), optMR(2), 0);
    end
    Dl(j,:) = vvd(:)';
    Al(j,:) = vva(:)';
end
VIl = sqrt(sum((Al - vv2).^2, 2));

% --> store
rows               = (E.N+1:E.N+nNew)';
E.keys(rows)       = round(tNew*1e5);
E.vJ(rows,:)       = vv1;
E.D(rows,:,:)      = reshape(Dl, nNew, nT, 3);
E.A(rows,:,:)      = reshape(Al, nNew, nT, 3);
E.VI(rows,:)       = reshape(VIl, nNew, nT);
E.N                = E.N + nNew;

end

% =========================================================================
function dv = findDV_vec(vvrel_A, vA, vvrel_D, vD, muPL, rpmin)
% Vectorised findDV: powered/unpowered flyby defect.
cosal   = sum(vvrel_A.*vvrel_D, 2)./(vA.*vD);
cosal   = min(max(cosal, -1), 1);
alpha   = acos(cosal);                                % --> turning angle
if muPL == 0
    alpha_A = zeros(size(vA));                        % --> no deflection
else
    e_A     = 1 + (rpmin.*vA.^2)./muPL;
    alpha_A = 2*asin(1./e_A);                         % --> max turning angle
end
dv      = abs(vD - vA);
k       = alpha > alpha_A;
dv(k)   = sqrt( vA(k).^2 + vD(k).^2 - 2.*vA(k).*vD(k).*cos(alpha_A(k) - alpha(k)) );
end