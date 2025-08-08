function [t_since_peri, t_to_peri, H] = hyperbola_peri_time(a, e, mu, f)
% DESCRIPTION: 
% Time since periapsis (and time to periapsis) passage on a hyperbola given
% a true anomaly. 
%
% INPUT :
% - a  : semi-major axis (km), negative for hyperbola
% - e  : eccentricity (>1)
% - mu : gravitational parameter (km^3/s^2)
% - f  : true anomaly (rad)
%
% OUTPUT :
% - t_since_peri : time since periapsis (s). Positive if after periapsis.
% - t_to_peri    : time to periapsis (s). Positive if periapsis is in the future.
% - H            : hyperbolic anomaly (signed)
% 
% -------------------------------------------------------------------------

% sanity checks
if e <= 1
    error('eccentricity must be > 1 for a hyperbola');
end
if a >= 0
    error('semi-major axis a must be negative for hyperbola');
end

denom = 1 + e .* cos(f);
% avoid division by zero if denom == 0 (f at asymptote); user should handle that.
if any(abs(denom) < 1e-14)
    warning('Denominator 1+e*cos(f) is near zero (true anomaly near asymptote). Results may be large/NaN.');
end

coshH = (e + cos(f)) ./ denom;

% numerical safety: coshH must be >= 1
coshH = max(coshH, 1.0);

% compute signed sinhH (sign follows sin(f))
sinhH_mag = sqrt(coshH.^2 - 1);
sinhH = sign(sin(f)) .* sinhH_mag;

% compute H; using asinh keeps the sign
H = asinh(sinhH);   % H is signed

% alternative check:
% H_alt = sign(sin(f)).*acosh(coshH);  % acosh returns positive, multiply sign if desired

% mean (hyperbolic) motion factor: sqrt((-a)^3 / mu)
scale = sqrt(((-a).^3) ./ mu);

% time since periapsis
t_since_peri = scale .* ( e .* sinhH - H );

% time to periapsis
t_to_peri = -t_since_peri;
end
