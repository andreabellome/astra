function [hmin, hmax] = maxmin_flybyAltitude(pl)

% DESCRIPTION
% This function extracts minimum and maximum flyby altitudes for Solar
% System planets.
%
% INPUT
% - pl : flyby body ID (1. Mercury, 2. Venus, 3. Earth, 4. Mars, 5.
%           Jupiter, 6. Saturn, 7. Uranus, 8. Neptune)
%
% OUTPUT
% - hmin : minimum altitude for the flyby [km]
% - hmax : maximum altitude for the flyby [km]
%
% -------------------------------------------------------------------------

        % Y   % V   % E   % M    % J       % S      % U       % N
HMIN = [ 200   200   200   200  69911*5   58232*2   25362    24624];
HMAX = [35000 35000 35000 35000 69911*200 58232*100 25362*10 24624*10];

hmin = HMIN(pl);
hmax = HMAX(pl);

end