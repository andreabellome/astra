function [ dv ] = deltaV_hyperbola( vinf, rpip, rat, mu )

% DESCRIPTION
% This function computes the delta-v required for a hyperbolic trajectory 
% maneuver. It calculates the velocity at periapsis of the incoming hyperbola 
% and compares it with the velocity required for an elliptical orbit to 
% determine the necessary velocity change.
% 
% INPUT
% - vinf  : excess velocity at infinity [km/s]
% - rpip  : periapsis radius of the hyperbolic trajectory [km]
% - rat   : apoapsis radius of the target orbit [km]
% - mu    : gravitational parameter of the central body [km^3/s^2]
% 
% OUTPUT
% - dv    : delta-v required for orbit insertion [km/s]
%
% -------------------------------------------------------------------------


[~, vpip]      = Vinf2Hyperbola(vinf, rpip, mu);

vel_peri        = @( rp, ra, mu ) sqrt( ( 2.*mu )./(rp + ra).*( ra/rp ) );
vp              = vel_peri( rpip, rat, mu );

% --> delta-v
dv = vpip - vp;

end