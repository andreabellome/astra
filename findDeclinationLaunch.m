function [Dec, Asc] = findDeclinationLaunch(vvsc, vvpl)

vEscape = vvsc - vvpl; % --> this is the v-infinity, with
epsilon = deg2rad(23.5);
R       = [1 0 0; 0 cos(epsilon) -sin(epsilon); 0 sin(epsilon) cos(epsilon)];
v_eci   = R*vEscape';

% --> declination at launch
Dec = asin(v_eci(3)/norm(v_eci));

% --> right-ascension at launch
Asc = atan2( v_eci(2), v_eci(1) );

end