function [mf, k, mp] = rocketEq_givenDV(m0, dv, Isp, g0)

% DESCRIPTION
% This function computes the final mass of a rocket after a velocity change (delta-v)
% using the Tsiolkovsky rocket equation. It also calculates the propellant mass
% expended and the mass ratio.
% 
% INPUT
% - m0  : initial mass of the rocket (kg)
% - dv  : velocity change (delta-v) required (m/s)
% - Isp : specific impulse of the rocket engine (s)
% - g0  : gravitational acceleration at sea level (m/s^2) [optional, default = 9.806 m/s^2]
% 
% OUTPUT
% - mf : final mass of the rocket after delta-v (kg)
% - k  : mass ratio, defined as propellant mass fraction (mp/m0)
% - mp : propellant mass expended (kg)
%
% -------------------------------------------------------------------------


if nargin == 3
    g0 = 9.806;
end

mf = m0*exp( -dv./( g0*Isp ) );
mp = m0 - mf;
k  = mp./m0;

end