function NumRevMax = maxRev_LP(tof_days, rr1, rr2, muCentral)

% DESCRIPTION
% This function computes the maximum number of revolutions allowed for a
% Lambert arc based on the given time of flight and positions. It provides
% an estimate of how many full revolutions can fit within the provided
% transfer time, assuming the minimum semi-major axis for the two-body
% orbit connecting the input positions.
%
% INPUT
% - tof_days   : time of flight for the transfer arc [days]
% - rr1        : initial position vector [km]
% - rr2        : final position vector [km]
% - muCentral  : gravitational parameter of the central body [km^3/s^2]
%
% OUTPUT
% - NumRevMax : maximum number of full revolutions feasible within the
%               given time of flight [-]
%
% -------------------------------------------------------------------------


% --> Understanding maximum number of revolutions
sma_min    = 1/4*(norm(rr1)+norm(rr2)+norm(rr2-rr1));
P_min_days = 2*pi*sqrt(sma_min^3/muCentral)/86400;
NumRevMax  = floor(tof_days/P_min_days);

end