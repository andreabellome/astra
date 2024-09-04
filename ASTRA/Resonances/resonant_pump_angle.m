function pump_angle = resonant_pump_angle(gm, sc_orbital_period, r_flyby, v_body, vinf_norm)

% DESCRIPTION
% Returns the pump angle to obtain an orbit of a given period.
% Returns NaN if the given pump angle is not reachable.
%
% Parameters
% ----------
% gm : float
%     Gravitational parameter of the central body [km^3/s^2]
% sc_orbital_period : float
%     Period that the spacecraft orbit must have. [s]
% r_flyby : float
%     Radius of the flyby body. [km]
% v_body : float
%     Velocity of the flyby body. [km/s]
% vinf_norm : float
%     Norm of the vinf. [km]
%
% Returns
% -------
% float or NaN
%     Pump angle or NaN.
%
% -------------------------------------------------------------------------

% Extract the semi-major axis from the period
sc_sma = (gm * (sc_orbital_period / (2 * pi))^2)^(1 / 3);
if sc_sma <= r_flyby / 2
    pump_angle = NaN;
    return;
end

% Compute the velocity at the encounter radius using the vis-viva equation
v_sc = sqrt(gm * (2/r_flyby - 1/sc_sma));

if -v_sc < v_body - vinf_norm && v_body - vinf_norm < v_sc && v_sc < vinf_norm + v_body
    % Calculate the pump angle using the cosine rule
    cosalpha = (v_sc^2 - vinf_norm^2 - v_body^2) / (2 * vinf_norm * v_body);
    pump_angle = acos(cosalpha);
else
    pump_angle = NaN;
end

end
