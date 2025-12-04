function [transfer] = postProcessLT_SEP( time, states, propFunction, pm )

% DESCRIPTION
% This function processes the results of a low-thrust trajectory optimization 
% by converting scaled states back to physical units, extracting the thrust 
% profile, and assembling all relevant trajectory data into a single matrix.
%
% INPUT
% - time         : Vector of time points (scaled units).
% - states       : Matrix of state vectors (scaled units), where each row 
%                  corresponds to a time step and contains [position, velocity, mass].
% - propFunction : Function handle for the propulsion model, which returns 
%                  the thrust profile in the RTN frame.
% - pm           : Parameter structure containing constants and scaling factors, 
%                  including:
%                  - MU        : Mass unit (kg).
%                  - LU        : Length unit (km).
%                  - TU        : Time unit (s).
%                  - muScl     : Scaled gravitational parameter.
%                  - TmaxScl   : Scaled maximum thrust.
%                  - IspScl    : Scaled specific impulse.
%                  - g0Scl     : Scaled gravitational acceleration.
%                  - rho       : Density parameter for the propulsion model.
%
% OUTPUT
% - transfer : Matrix containing the processed trajectory data with the 
%              following columns:
%              [time (days), position (km), velocity (km/s), mass (kg), 
%               thrust magnitude (N), thrust vector (N)].
% -------------------------------------------------------------------------


% --> extract the mass
massScl         = states(:,7);
mass            = massScl*pm.MU; % --> mass evolution (kg)

% --> convert the states back to cartesian
statevec        = states(:,1:6);
stateCartScl    = zeros( length(time),6 );
thrustRTN       = zeros( length(time),3 );
thrust          = zeros( length(time),3 );
thrustmag       = zeros( length(time),1 );
for indt = 1:length(time)
    stateCartScl(indt,1:6) = mee2car(statevec(indt,1:6), pm.muScl);

    % --> obtain the thrust profile
    [~, thrustRTN(indt,:)] = propFunction( time(indt), states(indt,:)', [ pm.muScl, ...
                                            pm.TmaxScl, ...
                                            pm.IspScl, ...
                                            pm.g0Scl, ...
                                            pm.rho, ...
                                            pm.LU, pm.TU, pm.MU, ...
                                            pm.thrust_max_N, pm.n_engines,...
                                            pm.epsilon,...
                                            ] );

    rtn2eci                = RTNtoECI(stateCartScl(indt,1:3)',stateCartScl(indt,4:6)');
    thrust(indt,:)         = rtn2eci*thrustRTN(indt,:)';
    thrustmag(indt)        = norm(thrust(indt,:));
end

stateCart           = stateCartScl;
stateCart(:,1:3)    = stateCart(:,1:3).*pm.LU;
stateCart(:,4:6)    = stateCart(:,4:6).*pm.LU/pm.TU;

% --> matrix with: [time, states, mass, Tmagnitude, Tvector]
transfer = [ time, stateCart, mass, thrustmag*pm.MU*1e3*pm.LU/pm.TU^2, thrust*pm.MU*1e3*pm.LU/pm.TU^2 ];

end
