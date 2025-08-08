function spherical = car2Spherical( cart )

% DESCRIPTION :
% Spherical coordinates (r, th, phi) to position vector (pos_x, pos_y,
% pos_z).
% 
% INPUT :
% - cart : position vector (pos_x, pos_y, pos_z)
%
% OUTPUT : 
% - spherical : 1x3 spherical coordinates such that : 
%                - spherical(1) is the radius
%                - spherical(2) is the azimuth
%                - spherical(3) is the elevation
% 
% -------------------------------------------------------------------------
                

r   = norm(cart(1:3));
azi = atan2( cart(2), cart(1) );
rxy = norm(cart(1:2));
el  = atan2( cart(3), rxy );

spherical = [ r, azi, el ];

end