function [rrOU, vvOU, vvInfIN, vvInfOU] = swingby_vA(rrIN, vvIN, plIN, tIN, kIN, rpIN, muPLIN, idcentral, customEphemerides)

% DESCRIPTION
% This function computes the output position and velocity vectors after a
% gravity assist (swing-by) maneuver. The maneuver is modeled as an
% instantaneous velocity rotation of the incoming hyperbolic excess vector
% with a specified turn angle and plane orientation. The central body
% ephemerides are retrieved using a default or user-defined function.
%
% INPUT
% - rrIN              : incoming position vector at swing-by (1×3) [km]
% - vvIN              : incoming velocity vector at swing-by (1×3) [km/s]
% - plIN              : ID of the flyby planet (integer, see constants.m)
% - tIN               : time of swing-by [TDB] (scalar, in seconds or days)
% - kIN               : rotation angle defining the plane of the flyby (rad)
% - rpIN              : pericenter radius of swing-by trajectory [km]
% - muPLIN            : gravitational parameter of the planet [km^3/s^2]
% - idcentral         : (optional) ID of the central body for ephemerides
%                       computation (default = 1)
% - customEphemerides : (optional) function handle to compute planetary
%                       ephemerides (default = @EphSS_cartesian)
%
% OUTPUT
% - rrOU    : output position vector after swing-by (1×3) [km]
% - vvOU    : output velocity vector after swing-by (1×3) [km/s]
% - vvInfIN : incoming hyperbolic excess velocity vector (1×3) [km/s]
% - vvInfOU : outgoing hyperbolic excess velocity vector (1×3) [km/s]
%
% -------------------------------------------------------------------------

if nargin == 7
    idcentral         = 1;
    customEphemerides = @EphSS_cartesian;
elseif nargin == 8
    if isempty(idcentral)
        idcentral = 1;
    end
    customEphemerides = @EphSS_cartesian;
elseif nargin == 9
    if isempty(idcentral)
        idcentral = 1;
    end
    if isempty(customEphemerides)
        customEphemerides = @EphSS_cartesian;
    end
end

[~, vvga] = customEphemerides(plIN, tIN, idcentral);

vvInfIN = vvIN - vvga;

mu_rp     = muPLIN/rpIN;
theta_inf = acos(-mu_rp/(norm(vvInfIN)^2+mu_rp)); % See Kaplan "Modern spacecraft dynamics and control", pag. 93
delta     = 2*theta_inf-pi;                       % Deflection angle

b1      = vvInfIN./norm(vvInfIN);
b2      = (cross(b1, vvga)./norm(vvga))./norm((cross(b1, vvga)./norm(vvga)));
b3      = cross(b1, b2);
vvInfOU = norm(vvInfIN).*[cos(delta).*b1 + cos(kIN)*sin(delta).*b2 + sin(kIN)*sin(delta).*b3]';

% n_r       = cross(vvInfIN, vvga)./norm(cross(vvInfIN, vvga)); % Reference vector
% n_pi      = eulerAxisAngle(n_r, vvInfIN, kIN);                % Rotates n_r around v1
% vvInfOU   = eulerAxisAngle(vvInfIN, n_pi, delta);             % Rotates v1 around n_pi

rrOU = rrIN;
vvOU = vvga + vvInfOU';

end