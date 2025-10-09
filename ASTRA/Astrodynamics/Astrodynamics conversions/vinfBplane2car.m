function cart = vinfBplane2car( vinf_bplane_params, mu_planet )

% DESCRIPTION :
% This function computes the cartesian elements (pos_x, pos_y, pos_z,
% vel_x, vel_y, vel_z) in a planetary-centered inertial reference frame
% from the B-plane elements. 
%
% This is only valid for hyperbolic trajectories.
%
% INPUT :
% - vinf_bplane_params : 1x6 vector with the following parameters
%                       - vinf_mag        = vinf_bplane_params(1) magnitude
%                       of infinity velocity [km/s]
%                       - right_ascension = vinf_bplane_params(2) right
%                       ascension of the infinity velocity vector [rad]
%                       - declination     = vinf_bplane_params(3)
%                       declination of the infinity velocity vector [rad]
%                       - bt              = vinf_bplane_params(4) BT
%                       component of the B-vector [km]
%                       - br              = vinf_bplane_params(5) BR
%                       component of the B-vector [km]
%                       - th              = vinf_bplane_params(6) true
%                       anomaly along the hyperbola [rad]
% - mu_planet : gravitational parameter of the planet [km3/s2]
%
% OUTPUT :
% - cart : 1x6 vector with (pos_x, pos_y, pos_z, vel_x, vel_y, vel_z) in
% [km] and [km/s]
%
% -------------------------------------------------------------------------

vinf_mag        = vinf_bplane_params(1);
right_ascension = vinf_bplane_params(2);
declination     = vinf_bplane_params(3);
bt              = vinf_bplane_params(4);
br              = vinf_bplane_params(5);
th              = vinf_bplane_params(6);

c3  = vinf_mag^2;
sma = -mu_planet / c3;

slr     = ( bt^2 + br^2 )/(-sma);
ecc     = sqrt( 1 - slr/sma );
tanInf  = acos(-1/ecc);

polarIn   = [1, right_ascension, declination];
inVinfDir = spherical2Car( polarIn );

zDir = [0, 0, 1];
tDir = cross( inVinfDir, zDir )./norm(cross(inVinfDir, zDir));
rDir = cross( inVinfDir, tDir );
bVec = bt .* tDir + br .* rDir;

h       = cross( bVec, vinf_mag.*inVinfDir );
hDir    = h./norm(h);

nDir        = cross(hDir, inVinfDir);
angle       = tanInf - pi;
eccVecDir   = cos(angle) .* inVinfDir + sin(angle) .* nDir;

maDir = cross(hDir, eccVecDir);

ctan    = cos(th);
stan    = sin(th);
r       = slr / ( 1 + ecc * ctan );

rr = (r * ctan).* eccVecDir + (r * stan).* maDir;
vv = sqrt(mu_planet / slr) * ( -stan .* eccVecDir + (ecc + ctan) .* maDir ); 

cart = [rr, vv];

end
