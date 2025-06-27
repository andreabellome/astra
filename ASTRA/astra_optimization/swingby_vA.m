function [rrOU, vvOU, vvInfIN, vvInfOU] = swingby_vA(rrIN, vvIN, plIN, tIN, kIN, rpIN, muPLIN, idcentral, customEphemerides)

% rpIN is in DIMENSIONAL UNITS (km)!!!!

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