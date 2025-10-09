function [ t0Min, t0Max, TOFMin, TOFMax, rpMin, rpMax, etaMin, etaMax, seq, path ] = ...
            minMaxFromPath(path, t0days, tofperc, rpperc, ksperc, idcentral, customEphemerides)

if nargin == 5
    idcentral         = 1;
    customEphemerides = @EphSS_cartesian;
elseif nargin == 6
    customEphemerides = @EphSS_cartesian;
end

[~, ~, path] = path2FlybyParam(path, idcentral, customEphemerides);
seq          = path(:,7)';
t0           = path(1,8);
tofs         = path(2:end,11)';

t0Min          = t0 - t0days;
t0Max          = t0 + t0days;
TOFMin         = tofs.*(1 - tofperc).*( (tofs.*(1 - tofperc)) >= 0 );
TOFMax         = tofs.*(1 + tofperc);
ks             = path(2:end-1,15)';
[rpMin, rpMax] = maxMinPeriAltitude(path, rpperc);
etaMin         = ks*(1 - ksperc); etaMin(etaMin < 0)    = 0;
etaMax         = ks*(1 + ksperc); etaMax(etaMax > 2*pi) = 2*pi; 

end