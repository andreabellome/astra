function mee = car2mee( car, mu )

% DESCRIPTION
% This function converts Cartesian state vectors into Modified Equinoctial
% Elements (MEE). It first converts position and velocity vectors into
% Keplerian orbital elements, and subsequently transforms those into MEE.
% The MEE representation avoids singularities for zero inclination and
% eccentricity, making it suitable for a wide range of orbital regimes.
%
% INPUT
% - car : Cartesian state vector [rx, ry, rz, vx, vy, vz], where
%         r = position vector [km]
%         v = velocity vector [km/s]
% - mu  : gravitational parameter of the central body [km^3/s^2]
%
% OUTPUT
% - mee : vector of Modified Equinoctial Elements [p, f, g, h, k, L]
%         where:
%         - p : semi-latus rectum [km]
%         - f : e*cos(omega + Omega)
%         - g : e*sin(omega + Omega)
%         - h : tan(i/2)*cos(Omega)
%         - k : tan(i/2)*sin(Omega)
%         - L : true longitude [rad]
%
% -------------------------------------------------------------------------


kep = car2kep( car, mu );
mee = kep2mee( kep );

end