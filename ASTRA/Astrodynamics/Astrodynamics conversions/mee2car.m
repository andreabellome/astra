function car = mee2car( mee, mu )

% DESCRIPTION
% This function converts a state vector expressed in Modified Equinoctial
% Elements (MEE) into Cartesian coordinates (position and velocity) using
% an intermediate conversion to Classical Orbital Elements (COE).
%
% INPUT
% - mee : 6x1 vector of Modified Equinoctial Elements [p, f, g, h, k, L], where:
%         - p : semi-latus rectum [km]
%         - f : e*cos(omega + Omega)
%         - g : e*sin(omega + Omega)
%         - h : tan(i/2)*cos(Omega)
%         - k : tan(i/2)*sin(Omega)
%         - L : true longitude [rad]
% - mu  : gravitational parameter of the central body [km3/s2]
%
% OUTPUT
% - car : 6x1 Cartesian state vector [rx, ry, rz, vx, vy, vz], where:
%         - r : position vector components in inertial frame [km]
%         - v : velocity vector components in inertial frame [km/s]
%
% -------------------------------------------------------------------------

kep = mee2kep(mee);
car = kep2car( kep, mu );

end