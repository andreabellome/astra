function [RP, DELTA, path] = path2FlybyParam(path)

mu = 132724487690;

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
    
    [~, vvga] = EphSS_car(plIN, tIN);
    
    vvrelIN = vvIN - vvga;
    vvrelOU = vvOU - vvga;
    
    [RP(row-1,:), DELTA(row-1,:)] = findFlyby_TE(vvrelIN, vvrelOU, plIN, tIN);
    
end

path(2:size(RP,1)+1,12:15) = RP;
path(2:size(RP,1)+1,16)    = rad2deg(RP(:,end));

end