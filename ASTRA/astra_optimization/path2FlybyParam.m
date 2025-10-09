function [RP, DELTA, path] = path2FlybyParam(path, idcentral, customEphemerides)

if nargin == 1
    idcentral         = 1;
    customEphemerides = @EphSS_cartesian;
elseif nargin == 2
    customEphemerides = @EphSS_cartesian;
end

mu = constants(idcentral, 1);

RP    = zeros(size(path,1)-2,4);
DELTA = zeros(size(path,1)-2,3);
for row = 2:size(path,1)-1
   
    vvIN  = path(row,4:6);
    plIN  = path(row,7);
    tIN   = path(row,8);
    
    rrIN2  = path(row+1,1:3);
    vvIN2  = path(row+1,4:6);
    tIN2   = path(row+1,8);
    kepIN2 = car2kep([rrIN2, vvIN2], mu);
    
    dt = (tIN2 - tIN)*86400;
    [~, vvOU] = FGKepler_dt(kepIN2, -dt, mu);
    
    [~, vvga] = customEphemerides(plIN, tIN, idcentral);
    
    vvrelIN = vvIN - vvga;
    vvrelOU = vvOU - vvga;
    
    [RP(row-1,:), DELTA(row-1,:)] = findFlyby_TE(vvrelIN, vvrelOU, plIN, tIN, idcentral, customEphemerides);
    
end

path(2:size(RP,1)+1,12:15) = RP;
path(2:size(RP,1)+1,16)    = rad2deg(RP(:,end));

end