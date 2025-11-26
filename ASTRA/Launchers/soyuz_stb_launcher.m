function m0 = soyuz_stb_launcher( vinf, mass_adapter )

% DESCRIPTION:
% 1D exponential function with 4th degree polynominal to get the launch
% mass from infinity-velocity for Soyuz ST-B launcher (no info on
% declination). 
% This is obtained from Ariane 62 performances divided by 1.5.
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

m0 = ariane_62_launcher( vinf, mass_adapter );
m0 = m0 / 1.5;

end