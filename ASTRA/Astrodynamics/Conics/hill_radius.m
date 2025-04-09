function r_hill = hill_radius( idcentral, secondary_body )

% DESCRIPTION
% This function computes the Hill radius of a secondary body orbiting a 
% central body. The Hill radius represents the region around the secondary 
% body where its gravitational influence dominates over the tidal forces of 
% the central body. If the central body is Earth (ID 1) and the secondary 
% body is the Sun (ID 3), the mass of the Moon is also included in the 
% calculation.
% 
% INPUT
% - idcentral       : integer identifier of the central body
% - secondary_body  : integer identifier of the secondary body
% 
% OUTPUT
% - r_hill         : Hill radius of the secondary body [km]
%
% -------------------------------------------------------------------------


[mu_id_central, mu_secondary, sma] = constants(idcentral, secondary_body);
if idcentral == 1 && secondary_body == 3
    % --> also include the mass of the moon
    [~, mu_moon] = constants(30, 1);
    mu_secondary = mu_secondary + mu_moon;
end

r_hill = sma*(mu_secondary/( 3*mu_id_central ))^(1/3);


end