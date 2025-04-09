function [dv, k, mp] = rocketEq_givenFinalMass(m0, mf, Isp, g0)

% DESCRIPTION
% This function computes the velocity change (delta-v) required to reach a given 
% final mass using the Tsiolkovsky rocket equation. It also calculates the 
% propellant mass expended and the mass ratio.
% 
% INPUT
% - m0  : initial mass of the rocket (kg)
% - mf  : final mass of the rocket after delta-v (kg)
% - Isp : specific impulse of the rocket engine (s)
% - g0  : gravitational acceleration at sea level (m/s^2) [optional, default = 9.806 m/s^2]
% 
% OUTPUT
% - dv : velocity change (delta-v) required (m/s)
% - k  : mass ratio, defined as propellant mass fraction (mp/m0)
% - mp : propellant mass expended (kg)
%
% -------------------------------------------------------------------------


if nargin == 3
    g0 = 9.806;
end

mp = m0 - mf;
k  = mp./m0;
dv = Isp*g0*log( m0/mf );

end