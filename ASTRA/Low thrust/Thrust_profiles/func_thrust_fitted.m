function thrust_profile = func_thrust_fitted( dist_to_sun_au, thrustParam )

% DESCRIPTION
% Smooth Solar Electric Propulsion (SEP) thrust profile (see also
% func_thrust_true.m)
% 
% INPUT: 
% - dist_to_sun_au : Sun-spacecraft distance [AU]
% - thrustParam    : structure with the following fields:
%                   - Tmax          : max. thrust at 1 AU [N] (e.g., 1.05 N)
%                   - n_engines     : number of engines
%                   - thrust_max_N  : reference thrust for each engine [N]
%                   (e.g., 0.255 N)
%                   - epsilon       : smooth factor for the thrust profile
%                   (by default 0.002)
%
% OUTPUT:
% - thrust_profile : thrust magnitude w.r.t. the Sun-spacecraft distance [N] 
% 
% -------------------------------------------------------------------------

n_engines    = thrustParam.n_engines;
Tmax         = thrustParam.Tmax;
thrust_max_N = thrustParam.thrust_max_N;

if ~isfield(thrustParam, 'epsilon')
    epsilon = 0.002;
else
    epsilon = thrustParam.epsilon;
end

func_1         = Tmax ./ dist_to_sun_au.^2;
func_2         = n_engines * thrust_max_N;
thrust_profile = -epsilon.*log( exp( -(func_1)./epsilon ) + exp( -(func_2)./epsilon ));

end