function [r, radPL, muPL] = astroConstantsj2000(pl)

% DESCRIPTION
% This function retrieves astronomical constants for a specified planet 
% in the Solar System. It provides the planet's distance from the Sun 
% (semi-major axis), gravitational parameter, and radius. If the specified 
% planet is not available in the pre-defined list, it attempts to calculate 
% the distance using ephemerides data.
% 
% INPUT
% - pl    : Planet index (1 for Mercury, 2 for Venus, ..., 8 for Neptune)
% 
% OUTPUT
% - r     : Distance from the Sun (semi-major axis) in kilometers.
% - radPL : Radius of the planet in kilometers.
% - muPL  : Gravitational parameter of the planet in km^3/s^2.
% 
% -------------------------------------------------------------------------


try
    AU = 149597870.7;
    
    R     = [0.3871*AU 0.7233*AU 1.0000*AU 1.5237*AU 5.2026*AU 9.5549*AU 19.2185*AU 30.1104*AU];
    MUPL  = [22033 3.2486e+05 3.986e+05 42828 1.2669e+08 3.7931e+07 5.7939e+06 6.8347e+06];
    RADPL = [2440 6051.8 6378.2 3389.9 69911 58232 25362 24624];
    
    r     = R(pl);
    muPL  = MUPL(pl);
    radPL = RADPL(pl);
catch

    [rr, vv] = EphSS_cartesian(pl, date2mjd2000([2023 1 1 0 0 0]));
    r     = norm(rr);
    radPL = [];
    muPL  = [];

end

end