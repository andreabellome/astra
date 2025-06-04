function [tt,yy] = propagateKepler_tof(rr1, vv1, tof, mu, npoints)

% DESCRIPTION
% This function propagates in keplerian dynamics an initial state for a
% specified time of flight.
% 
% INPUT
% - rr1     : 1x3 vector with initial position [km]
% - vv1     : 1x3 vector with initial velocity [km/s]
% - tof     : time of flight [sec]
% - mu      : gravitational constant of the central body [km3/s2]
% - npoints : number of points for the propagation (default: 500)
% 
% OUTPUT 
% - tt   : same as in input
% - yy   : Nx6 matrix, where each row is the state, i.e., position and
%          velocity vectors evaluated at each tt(i)
% - kkep : Nx6 matrix, where each row is a set of keplerian elements (see
%          car2kep.m) evaluated at each tt(i)
% 
% -------------------------------------------------------------------------

if nargin == 4
    npoints = 500;
end

tt = linspace( 0, tof, npoints );

kep1 = car2kep([rr1, vv1], mu);

yy = zeros(length(tt), 6);
for indi = 1:length(tt)
    [rrf, vvf] = FGKepler_dt(kep1, tt(indi), mu);
    yy(indi,:) = [rrf vvf];
end

[rows,~] = size(tt);
if rows == 1
    tt = tt';
end

end
