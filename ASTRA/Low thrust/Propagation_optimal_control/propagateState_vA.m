function F = propagateState_vA(lambda0, propFunction, pm)

% DESCRIPTION:
% This function is used to compute the difference between target final
% state and final state resulting from the propagation. The states are
% given in Mean Equinoctial Elements (MEE).
%
% INPUT:
% - lambda0      : 7x1 vector with initial conditions for co-states
% - propFunction : MATLAB anonymous function of time and states (e.g., see
% propagateFopt_MEXIFY.m or propagateEopt_MEXIFY.m)
% - pm           : structure with parameters for the propagation
% 
% OUTPUT:
% F : 6x1 vector with difference between target final state and final state
% resulting from the propagation.
%
% -------------------------------------------------------------------------

param = pm;
pm.odeoptions.Events = @stopconditions;
[time, states] = ode45(@(t,x) propFunction(t, x, ...
    [ param.muScl, param.TmaxScl, param.IspScl, param.g0Scl, param.rho ]),...
    [ pm.tStart,pm.tEnd],[pm.x0, pm.m0Scl, lambda0 ],pm.odeoptions);

% residualangle = states(end,6) - pm.xf(6);
% residual_modified = sin(0.5*residualangle);
% F = [states(end,1:5) - pm.xf(1:5), residual_modified];

F = [states(end,1:6) - pm.xf(1:6)];

end


function [value, isterminal, direction] = stopconditions(times, states)

% DESCRIPTION:
% This function defines the stop conditions for the ODE integration, 
% stopping the integration when the object enters the Sun's radius.
%
% INPUT:
% - times  : Current time of the integration (scalar).
% - states : Current state vector during the integration, where the first 
%            element represents the position relative to the Sun (vector).
%
% OUTPUT:
% - value      : Scalar indicating the distance condition relative to the 
%                Sun's surface. The integration stops when this value 
%                reaches zero.
% - isterminal : Scalar indicating whether the integration should stop 
%                when the condition is met (1 for stopping).
% - direction  : Scalar indicating the direction of the zero-crossing 
%                condition (0 for both directions).
%
% -------------------------------------------------------------------------

% stop if its inside the sun
disttoSun  = abs(states(1)) -696340/1.496e+08;
value      = [disttoSun];
isterminal = 1;   % Stop the integration
direction  = 0;

end
