function [legn, vasn, vinfn, MAT_VV] = constructResonantOrbits_DP(legp, vasp, vinfp, plt, res, tolINCL)

% DESCRIPTION
% This function constructs resonant orbits for a spacecraft by evaluating potential 
% trajectories that satisfy a specified resonance condition with a planet. It computes 
% the spacecraft's incoming and outgoing velocities during a planetary flyby and 
% determines if a resonant orbit can be achieved while minimizing the change in 
% orbital inclination.
% 
% INPUT
% - legp    : Row vector containing the current leg information of the spacecraft's trajectory.
% - vasp    : Row vector of the spacecraft's velocity corresponding to the current leg.
% - vinfp   : Row vector of the spacecraft's hyperbolic excess velocity for the current leg.
% - plt     : ID of the planet involved in the resonance.
% - res     : Array specifying the desired resonance [numerator, denominator].
% - tolINCL : Tolerance for the inclination change between the incoming and outgoing orbit.
% - parallel: Boolean flag indicating if parallel processing is used (not used in this function).
% 
% OUTPUT
% - legn    : Matrix containing the legs of the spacecraft's trajectory after constructing 
%             the resonant orbits. Empty if no valid orbit is found.
% - vasn    : Matrix of spacecraft velocities after constructing resonant orbits. 
%             Empty if no valid orbit is found.
% - vinfn   : Vector of spacecraft's hyperbolic excess velocities after constructing resonant orbits. 
%             Empty if no valid orbit is found.
% - MAT_VV  : Matrix containing various parameters of the evaluated orbits, including 
%             incoming/outgoing velocities and inclination change.
% 
% -------------------------------------------------------------------------

mu                    = 132724487690;                       % --> gravitational parameter of the Sun
[muPL, radius, smapl] = planetConstants(plt);               % --> planet semi-major axis
rpmin                 = maxmin_flybyAltitude(plt) + radius; % --> minimum flyby altitude
Tpl                   = 2*pi*sqrt(smapl^3/mu);              % --> period of the planet
Tsc                   = res(1)/res(2)*Tpl;                  % --> period of the SC orbit
dt                    = res(2)*Tsc/86400;                   % --> transfer time (of the resonant orbit)
sma                   = (mu*(Tsc/(2*pi))^2)^(1/3);          % --> semi-major axis of the resonant orbit

vvIN = vasp;
plIN = legp(end-1);
tIN  = legp(end);
vInf = vinfp(end);

% --> planet state at the two encounters 
[rrga1, vvga1] = EphSS_cartesian(plIN, tIN);
rrIN           = rrga1;
[rrga2, vvga2] = EphSS_cartesian(plIN, tIN + res(1)*Tpl/86400);

% --> incoming keplerian elements (before the first flyby)
kepIN = car2kep([rrIN, vvIN], mu);

phi    = deg2rad(0:5:360);
vscou1 = sqrt(mu*(2/norm(rrga1) - 1/sma)); % --> SC velocity after the first flyby

th = acos((vInf^2 + norm(vvga1)^2 - vscou1^2)/(2*vInf*norm(vvga1)));
th = wrapTo2Pi(th);

alpha = pi - th;

vInfIN2 = zeros(length(phi), 1);
vvIN2   = zeros(length(phi), 3);
kepIN2  = zeros(length(phi), 6);

vvers    = vvga1./norm(vvga1);
crossvec = cross(rrga1, vvga1);
nvers    = crossvec./norm(crossvec);
cvers    = cross(vvers, nvers);
M        = [vvers' nvers' cvers'];

sinal = sin(alpha);
cosal = cos(alpha);
cosph = cos(phi);
sinph = sin(phi);

for indphi = 1:length(phi)
    
    vvInfOU1 = vInf.*[cosal, sinal*cosph(indphi), -sinal*sinph(indphi)];

    vvInfOU1 = M*vvInfOU1';
    vvInfOU1 = vvInfOU1';

    vvInfIN2        = vvInfOU1 + vvga1 - vvga2;
    vvIN2(indphi,:) = vvInfIN2 + vvga2;

    rrscou1         = rrga1;
    vvscou1         = vvInfOU1 + vvga1;
    [~, vvf]        = FGKepler_dt(car2kep([rrscou1, vvscou1], mu), dt*86400, mu);
    vvIN2(indphi,:) = vvf;
    
    vInfIN2(indphi,:) = norm(vvInfIN2);
    kepIN2(indphi,:)  = car2kep([rrga2, vvIN2(indphi,:)], mu);

end
DINCL = abs(kepIN(:,3) - kepIN2(:,3));

% --> eliminate those exceeding the DELTA_MAX constraint
MAT_VV      = [ vvIN.*ones(size(DINCL,1),3) vvIN2 vInfIN2 DINCL ];
MAT_VV      = sortrows(MAT_VV, size(MAT_VV,2));
ind_to_save = zeros(size(MAT_VV,1),1);
delta       = zeros(size(MAT_VV,1),1);
deltaMax    = zeros(size(MAT_VV,1),1);
for indm = 1:size(MAT_VV,1)
   
    vvin      = MAT_VV(indm,1:3);
    vvin2     = MAT_VV(indm,4:6);
    rrin2     = rrga2;
    [~, vvou] = FGKepler_dt(car2kep([rrin2, vvin2], mu), -dt*86400, mu);
    
    vvinfin          = vvin - vvga1;
    vvinfou          = vvou - vvga1;
    delta(indm,:)    = acos(dot(vvinfin,vvinfou)/(norm(vvinfin)*norm(vvinfou)));  
    deltaMax(indm,:) = 2*asin(1/(1 + (rpmin*norm(vvinfin)^2)/muPL)); 
    
    if delta(indm,:) <= deltaMax(indm,:)
        ind_to_save(indm,:) = indm;
    end

end
ind_to_save = ind_to_save(~all(ind_to_save == 0, 2),:);
MAT_VV      = MAT_VV(ind_to_save,:);
DINCL       = MAT_VV(:, end);

% --> select those orbit that minimize the DELTA_INCLINATION
% indxs = find(DINCL <= tolINCL);
[~,indxs] = min(DINCL);

vvIN2   = MAT_VV(indxs,4:6);
vInfIN2 = MAT_VV(indxs,7);

if isempty(vvIN2)
    legn  = [];
    vasn  = [];
    vinfn = [];
else
    legn  = [ legp.*ones(size(vvIN2,1), size(legp,2)) zeros( size(vvIN2,1) , 1) plt tIN+dt ];
    vasn  = vvIN2;
    vinfn = vInfIN2;
end
    
end
