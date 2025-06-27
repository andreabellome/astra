function kep = mee2kep(mee)

% DESCRIPTION
% This function converts a vector of Modified Equinoctial Elements (MEE) to
% the equivalent set of Classical Orbital Elements (COE).
%
% INPUT
% - mee : 6x1 vector of Modified Equinoctial Elements [p, f, g, h, k, L], where:
%         p : semi-latus rectum
%         f : component of eccentricity vector along x
%         g : component of eccentricity vector along y
%         h : component of inclination vector along x
%         k : component of inclination vector along y
%         L : true longitude
%
% OUTPUT
% - kep : 1x6 vector of Classical Orbital Elements [a, e, i, RAAN, ω, θ], where:
%         a    : semi-major axis
%         e    : eccentricity
%         i    : inclination
%         RAAN : right ascension of ascending node
%         ω    : argument of periapsis
%         θ    : true anomaly
%
% -------------------------------------------------------------------------


pmee = mee(1);
fmee = mee(2);
gmee = mee(3);
hmee = mee(4);
kmee = mee(5);
lmee = mee(6);

tani2s = sqrt(hmee * hmee + kmee * kmee);
ecc    = sqrt(fmee * fmee + gmee * gmee);
sma    = pmee / (1.0 - ecc * ecc);
inc    = 2.0 * atan(tani2s);
raan   = atan2(kmee, hmee);
atopo  = atan2(gmee, fmee);
argper = mod(atopo - raan, 2.0 * pi);
tanom  = mod(lmee - atopo, 2.0 * pi);

kep = [sma, ecc, inc, raan, argper, tanom];

end