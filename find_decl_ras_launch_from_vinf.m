function [Dec, Asc] = find_decl_ras_launch_from_vinf( vvinf )

epsilon = deg2rad(23.439291);
R       = [1 0 0; 0 cos(epsilon) -sin(epsilon); 0 sin(epsilon) cos(epsilon)]; % --> from ecliptic to equatorial 
% R       = [1 0 0; 0 cos(epsilon) sin(epsilon); 0 -sin(epsilon) cos(epsilon)]; % --> from equatorial to ecliptic

v_eci   = R*vvinf';

% --> declination at launch
Dec = asin(v_eci(3)/norm(v_eci));

% --> right-ascension at launch
Asc = atan2( v_eci(2), v_eci(1) );


end