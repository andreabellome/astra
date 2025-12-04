function thrust_law = func_thrust_true( dist_to_sun_au, thrustParam )

% DESCRIPTION
% Smooth Solar Electric Propulsion (SEP) thrust profile.
% 
% INPUT: 
% - dist_to_sun_au : Sun-spacecraft distance [AU]
% - thrustParam    : structure with the following fields:
%                   - Tmax          : max. thrust at 1 AU [N] (e.g., 1.05 N)
%                   - n_engines     : number of engines
%                   - thrust_max_N  : reference thrust for each engine [N]
%                   (e.g., 0.255 N)
%
% OUTPUT:
% - thrust_profile : thrust magnitude w.r.t. the Sun-spacecraft distance [N] 
% 
% -------------------------------------------------------------------------

n_engines    = thrustParam.n_engines;
Tmax         = thrustParam.Tmax;
thrust_max_N = thrustParam.thrust_max_N;

func_1         = Tmax ./ dist_to_sun_au.^2;
func_2         = n_engines * thrust_max_N;

thrust_law = min(func_1, func_2);

end