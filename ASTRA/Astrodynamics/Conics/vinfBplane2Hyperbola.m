function [delta, vpip, eip, Eip, aip] = vinfBplane2Hyperbola(vinf_bplane_params, mu_planet)

% DESCRIPTION : 
% This function computes the hyperbola parameters given B-plane parameters.
%
% INPUT : 
% - vinf_bplane_params : 1x6 vector with the following parameters
%                       - vinf_mag        = vinf_bplane_params(1) magnitude
%                       of infinity velocity [km/s]
%                       - right_ascension = vinf_bplane_params(2) right
%                       ascension of the infinity velocity vector [rad] -->
%                       NOT USED!!! Can be NaN.
%                       - declination     = vinf_bplane_params(3)
%                       declination of the infinity velocity vector [rad]
%                       --> NOT USED!!! Can be NaN.
%                       - bt              = vinf_bplane_params(4) BT
%                       component of the B-vector [km]
%                       - br              = vinf_bplane_params(5) BR
%                       component of the B-vector [km]
%                       - th              = vinf_bplane_params(6) true
%                       anomaly along the hyperbola [rad] --> NOT USED!!!
%                       Can be NaN. 
%
% OUTPUT :
% - delta : hyperbolic deflection (rad)
% - vpip  : hyperbolic pericentre velocity (km/s)
% - eip   : hyperbolic eccentricity
% - Eip   : hyperbolic energy (km2/s2)
% - aip   : hyperbolic semi-major axis (a<0) (km)
%
% -------------------------------------------------------------------------

vinf_mag        = vinf_bplane_params(1);
bt              = vinf_bplane_params(4);
br              = vinf_bplane_params(5);

c3              = vinf_mag^2;
aip             = -mu_planet / c3;

slr     = ( bt^2 + br^2 )/(-aip);
eip     = sqrt( 1 - slr/aip );
rpip    = slr / ( 1 + eip );
Eip     = 0.5*vinf_mag.^2; 
vpip  = sqrt(2.*(Eip + mu_planet./rpip));
delta = 2*asin(1./eip);
delta = wrapToPi(delta);

end