function vinf_bplane_params = car2VinfBplane( cart, mu_planet )

% DESCRIPTION :
% This function computes the B-plane elements from cartesian elements.
%
% INPUT : 
% - cart      : 1x6 vector with (pos_x, pos_y, pos_z, vel_x, vel_y, vel_z)
% in [km] and [km/s]
% - mu_planet : gravitational parameter of the planet [km3/s2]
%
% OUTPUT : 
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
%
% -------------------------------------------------------------------------

pos = cart(1:3);
vel = cart(4:6);
r   = norm(pos);
v   = norm(vel);

posDir = pos / r;

v2 = v^2;
c3 = v2 - 2 * mu_planet / r;

if c3 < 0
    fprintf( "\n The cartesian state provided does not correspond to hyperbola" );
    vinf_bplane_params = NaN.*ones(1,6);
    return
end

vinf = sqrt(c3);
sma  = -mu_planet / c3;

h    = cross(pos, vel);
hDir = h / norm(h);

eccVec      = (v2 .* pos - dot(pos, vel).* vel) / mu_planet - posDir;
ecc         = norm(eccVec);
eccVecDir   = eccVec ./ ecc;

maDir = cross(hDir, eccVecDir);

tanInf    = acos(-1/ecc);
inVinfDir = -cos(tanInf) .* eccVecDir + sin(tanInf) .* maDir;
polarIn   = car2Spherical( inVinfDir );

zDir = [ 0, 0, 1 ];
tDir = cross(inVinfDir, zDir)./norm(cross(inVinfDir, zDir));
rDir = cross(inVinfDir, tDir);

bMag = -sma * sqrt( ecc^2 - 1 );
bVec = bMag .* cross( inVinfDir, hDir );
bt   = dot( tDir, bVec );
br   = dot( rDir, bVec );

tan = atan2( dot( pos, maDir ), dot( pos, eccVecDir ) );

vinf_bplane_params = [ vinf, polarIn(2), polarIn(3), bt, br, tan ];

end