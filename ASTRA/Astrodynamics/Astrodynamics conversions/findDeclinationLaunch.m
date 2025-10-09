function [Dec, Asc] = findDeclinationLaunch(vvsc, vvpl)

% DESCRIPTION
% This function computes the declination and right ascension of the
% asymptotic velocity vector at launch, given the heliocentric velocity
% vectors of the spacecraft and the planet at departure.
%
% INPUT
% - vvsc : spacecraft heliocentric velocity vector [1x3] [km/s]
% - vvpl : planet heliocentric velocity vector at departure [1x3] [km/s]
%
% OUTPUT
% - Dec : declination of the launch asymptote [rad]
% - Asc : right ascension of the launch asymptote [rad]
%
% -------------------------------------------------------------------------

vEscape = vvsc - vvpl; % --> this is the v-infinity, with
epsilon = deg2rad(23.5);
R       = [1 0 0; 0 cos(epsilon) -sin(epsilon); 0 sin(epsilon) cos(epsilon)];
v_eci   = R*vEscape';

% --> declination at launch
Dec = asin(v_eci(3)/norm(v_eci));

% --> right-ascension at launch
Asc = atan2( v_eci(2), v_eci(1) );

end
