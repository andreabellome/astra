function [VINFS, vvd, vva, rrd, rra] = path2Vinfs(path, idcentral)

% DESCRIPTION
% This function computes the v-infinity vectors at each leg of a trajectory
% path. It calculates both the departure and arrival v-infinity vectors and 
% their magnitudes based on the input path data.
% 
% INPUT
% - path : Matrix where each row represents a state in the trajectory with 
%          columns for position (x, y, z), velocity (vx, vy, vz), 
%          planetary ID, time, and v-infinity.
% - idcentral : ID of the central body. See constants.m
% OUTPUT
% - VINFS : Matrix containing the departure and arrival v-infinity vectors 
%           and their magnitudes for each leg of the trajectory.
% - vvd   : Matrix of v-infinity vectors at the departure of each leg.
% - vva   : Matrix of v-infinity vectors at the arrival of each leg.
% - rrd   : Matrix of position vectors at the departure of each leg.
% - rra   : Matrix of position vectors at the arrival of each leg.
% 
% -------------------------------------------------------------------------

if nargin == 1
    idcentral = 1;
end

mu = constants(idcentral, 1);

% --> find arrival and departing v-infinities
vvInfDep = zeros(size(path,1)-2,3);
vvd      = zeros(size(path,1)-2,3);
vInfDep  = zeros(size(path,1)-2,1);
for row = 3:size(path,1)
    
    rrIN  = path(row,1:3);
    vvIN  = path(row,4:6);
    plIN  = path(row,7);
    tIN   = path(row,8);
    kepIN = car2kep([rrIN vvIN], mu);
    
    dt        = (tIN - path(row-1,8))*86400;
    [~, vvOU] = FGKepler_dt(kepIN, -dt, mu);
    
    [~, vvga1] = EphSS_cartesian(path(row-1,7), path(row-1,8), idcentral);

    vvInfDep(row-2,:) = vvOU - vvga1;
    vInfDep(row-2,1)  = norm(vvInfDep(row-2,:));

    vvd(row-2,:) = vvOU;
    
end
vvd     = [ path(1,4:6); vvd ];
vva     = path(2:end,4:6);
vInfDep = [path(1,9); vInfDep];
vInfArr = path(2:end,9);
VINFS   = [vInfDep vInfArr];

seq  = path(:,7)';
legs = fromSeq2Legs(seq);

VINFS = [legs VINFS];

rrd = path(1:end-1,1:3);
rra = path(2:end,1:3);

end