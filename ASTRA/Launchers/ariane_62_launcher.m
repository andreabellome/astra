function m0 = ariane_62_launcher( vinf, mass_adapter )

% DESCRIPTION:
% 1D exponential function with 4th degree polynominal to get the launch
% mass from infinity-velocity for Ariane 62 launcher (no info on
% declination)
%
% INPUT:
% - vinf         : infinity velocity at launch [km/s]
% - mass_adapter : adapter mass [kg]. By default = 110 kg
%
% OUTPUT:
% - m0 : max. launch mass [kg]
%
% -------------------------------------------------------------------------

if nargin == 1
    mass_adapter = 110;
elseif nargin == 2
    if isempty(mass_adapter)
        mass_adapter = 110;
    end
end

% coefficients
a1 =  2.928457e-06;
a2 = -1.933138e-04;
a3 = -2.624167e-02;
a4 =  8.103463;

% polynomial
C3          = vinf.^2;
poly_val    = a1.*C3.^3 + a2.*C3.^2 + a3.*C3 + a4;

% mass from exponential model
m  = exp(poly_val);
m0 = m - mass_adapter;

end