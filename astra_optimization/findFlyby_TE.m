function [RP, DELTA] = findFlyby_TE(vvrelIN, vvrelOU, plIN, tIN)

[muPL, radius] = planetConstants(plIN);
rpmin          = maxmin_flybyAltitude(plIN) + radius;

delta   = acos(dot(vvrelIN, vvrelOU)/(norm(vvrelIN)*norm(vvrelOU))); % turning angle
e_A     = 1 + (rpmin*norm(vvrelIN)^2)/muPL;                          % max. deflection hyperbola eccentricity
delta_A = 2*asin(1/e_A);                                             % max. deflection turning angle

delta   = wrapToPi(delta);
delta_A = wrapToPi(delta_A);

vvInfIN = vvrelIN;
vvInfOU = norm(vvrelIN).*vvrelOU./norm(vvrelOU);
deltacheck = delta <= delta_A;
if delta <= delta_A
    e      = 1/sin(delta/2);
    a      = -muPL/(norm(vvInfIN)^2);
    rp     = a*(1 - e);
    hp     = rp - radius;
else
    rp       = rpmin;
    hp       = rp - radius;  
    delta    = delta_A;
end

[~, vvga] = EphSS_car(plIN, tIN);

% find b-plane angle
b1 = vvInfIN./norm(vvInfIN);
b2 = (cross(b1, vvga)./norm(vvga))./norm((cross(b1, vvga)./norm(vvga)));
b3 = cross(b1, b2);

MAT = [b1' b2' b3'];
vec = 1/norm(vvInfOU).*(inv(MAT)*vvInfOU');
gam = atan2(vec(3),vec(2)); % from Izzo
gam = wrapTo2Pi(gam);       % gam in [0, 360] deg
% end b-plane angle

RP    = [rp hp rp/radius gam];
DELTA = [delta delta_A deltacheck];

end