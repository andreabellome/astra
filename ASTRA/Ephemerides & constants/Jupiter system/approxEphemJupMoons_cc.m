function [rr, vv, kep] = approxEphemJupMoons_cc(idmoon, t)

% DESCRIPTION
% This function provides an approximation of the ephemerides for Jupiter's 
% moons (Io, Europa, Ganymede, and Callisto) using Keplerian elements. 
% It is intended for use in Delta-V (DV) and time of flight (TOF) analyses 
% but not for mission design purposes.
% 
% INPUT
% - idmoon : Integer identifier for the Jupiter moon:
%            1 --> Io
%            2 --> Europa
%            3 --> Ganymede
%            4 --> Callisto
% - t      : Time of interest in Modified Julian Date (MJD2000).
% 
% OUTPUT
% - rr     : Position vector of the moon at time t (in kilometers).
% - vv     : Velocity vector of the moon at time t (in kilometers per second).
% - kep    : Keplerian elements of the moon at time t.
% 
% PROCESS
% - Defines reference epoch and initial Keplerian elements for each moon.
% - Computes the position and velocity vectors by propagating the initial 
%   Keplerian elements to the given time using the FGKepler_dt function.
% 
% -------------------------------------------------------------------------

muidcentral = planetConstants(5);

tref = date2mjd2000([2030 1 1 0 0 0]); % --> reference epoch (MJD2000) - 2030-01-01
if idmoon == 1 % --> Io
    kep0 = [ 422029.68714001 0 0 0 0 deg2rad(2.500815419418998E+02) ];
elseif idmoon == 2 % --> Europa
    kep0 = [ 671224.23712681 0 0 0 0 deg2rad(1.932732150115001E+00) ];
elseif idmoon == 3 % --> Ganymede
    kep0 = [ 1070587.4692374 0 0 0 0 deg2rad(3.387029874381438E+02) ];
elseif idmoon == 4 % --> Callisto
    kep0 = [ 1883136.6167305 0 0 0 0 deg2rad(3.130144905250815E+01) ];
end

dt            = t - tref;
[rr, vv, kep] = FGKepler_dt(kep0, dt*86400, muidcentral);

end