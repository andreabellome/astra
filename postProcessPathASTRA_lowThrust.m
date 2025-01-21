function struc = postProcessPathASTRA_lowThrust(path, vdep, varr, idcentral)

if nargin == 1
    vdep = 0;
    varr = 0;
    idcentral = 1;
elseif nargin == 2
    if isempty(vdep)
        vdep = 0;
    end
    varr = 0;
    idcentral = 1;
elseif nargin == 3
    if isempty(vdep)
        vdep = 0;
    end
    
    if isempty(varr)
        varr = 0;
    end

    idcentral = 1;
elseif nargin == 4
    if isempty(vdep)
        vdep = 0;
    end
    
    if isempty(varr)
        varr = 0;
    end
end

[~, vvd, vva, rrd, rra] = path2Vinfs(path);
legs                    = fromSeq2Legs(path(:,7)');
epochs                  = [path(1:end-1,8) path(2:end,8) ];

% --> start: first leg of the transfer
p0           = legs(1,1);
t0           = epochs(1,1);
[~, vvga]    = EphSS_cartesian(p0, t0, idcentral);
if norm(vvga - vvd(1,:)) > vdep % --> DSM on the first leg
    vvinfPM = vvd(1,:) - vvga;
    vvinfPM = vdep.*vvinfPM./norm( vvinfPM ) ;
    vvBM    = vvinfPM + vvga;
else
    vvBM = vvd(1,:);
end
% --> end: first leg of the transfer

% --> start: other legs
dv     = zeros( size(legs,1)-1,1 );
vvouBM = zeros( size(legs,1)-1,3 );
for indl = 1:size(legs,1)-1
    
    plin          = legs(indl,2);

    if idcentral == 1 % --> central body is SUN
        if plin > 11 % --> perform the flyby with an asteroid/comet
            muPL  = 0;
            rpmin = 1000;
        else % --> perform the flyby with a planet
            [muPL, radius] = planetConstants(plin);
            rpmin          = maxmin_flybyAltitude(plin) + radius;
        end
    
    else % --> moon's system
        [~, muPL, ~, radpl, hmin] = constants(idcentral, plin);
        rpmin                     = radpl + hmin;
    end

    [~, vvga] = EphSS_cartesian(plin, epochs(indl,2), idcentral);

    vvin = vva(indl,:);
    vvou = vvd(indl+1,:);
    
    [dv(indl,:), delta, deltaMax] = findDV(vvin - vvga, vvou - vvga, muPL, rpmin);
    if delta <= deltaMax
        vvinfouBM = norm(vvin - vvga).*(vvou - vvga)./norm(vvou - vvga); % --> inf. vel. out. BM
    else
        b1        = (vvin - vvga)./norm((vvin - vvga));
        b2        = (cross(b1, vvga)./norm(vvga))./norm((cross(b1, vvga)./norm(vvga)));
        b3        = cross(b1, b2);
        MAT       = [b1' b2' b3'];
        vvInfOU   = norm((vvin - vvga)).*(vvou - vvga)./norm((vvou - vvga));
        vec       = 1/norm(vvInfOU).*(inv(MAT)*vvInfOU');
        gam       = atan2(vec(3),vec(2)); % from Izzo
        gam       = wrapTo2Pi(gam);       % gam in [0, 360] deg
        vvinfouBM = norm(vvin - vvga).*[cos(deltaMax).*b1 + cos(gam)*sin(deltaMax).*b2 + sin(gam)*sin(deltaMax).*b3];
    end
    vvouBM(indl,:) = vvinfouBM + vvga;

end
vvouBM = [ vvBM; vvouBM ];
dv     = [ norm( vvBM - vvd(1,:) ); dv ];
% --> end: other legs

% --> start: objects ephemerides
statesObjDep = zeros( size(legs,1),6 );
statesObjArr = zeros( size(legs,1),6 );
for indl = 1:size(legs,1)
    [rr, vv] = EphSS_cartesian(legs(indl,1), epochs(indl,1), idcentral);
    statesObjDep(indl,:) = [ rr, vv ];
    [rr, vv] = EphSS_cartesian(legs(indl,2), epochs(indl,2), idcentral);
    statesObjArr(indl,:) = [ rr, vv ];
end
% --> end: objects ephemerides

% --> start: last leg of the transfer
p1           = legs(end,2);
t1           = epochs(end,2);
[~, vvga]    = EphSS_cartesian(p1, t1, idcentral);
if norm(vvga - vva(end,:)) > varr % --> DSM on the first leg
    dvv  = abs( norm(vvga - vva(end,:)) - varr ).*(vvga - vva(end,:))./norm(vvga - vva(end,:));
    vvPM = vva(end,:) + dvv;
else
    dvv  = abs(norm(vvga - vva(end,:)) - varr);
    vvPM = vva(end,:);
end
vvaTAR        = vva;
vvaTAR(end,:) = vvPM;
% --> end: last leg of the transfer

% --> save the structure
for indl = 1:size(legs,1)
    
    % --> IDs and epochs
    struc(indl).idD    = legs(indl,1);
    struc(indl).idA    = legs(indl,2);
    struc(indl).tD     = epochs(indl,1);
    struc(indl).tA     = epochs(indl,2);

    % --> these are for LT
    struc(indl).xxDtar    = [ rrd(indl,:) vvouBM(indl,:) ];
    struc(indl).xxAtar    = [ rra(indl,:) vvaTAR(indl,:) ];

    % --> these are from Lambert
    struc(indl).xxDlam    = [ rrd(indl,:) vvd(indl,:) ];
    struc(indl).xxAlam    = [ rra(indl,:) vva(indl,:) ];

    % --> these are of the objects
    struc(indl).xxObjD = statesObjDep(indl,:);
    struc(indl).xxObjA = statesObjArr(indl,:);
    
    % --> DV defects
    struc(indl).dvvD = vvd(indl,:) - vvouBM(indl,:);
    struc(indl).dvvA = vvaTAR(indl,:) - vva(indl,:);

    struc(indl).dvD = norm( struc(indl).dvvD );
    struc(indl).dvA = norm( struc(indl).dvvA );

end


% seq = path(:,7)';
% seq(seq >= 12) = seq(seq >= 12) - 11;
% legs = fromSeq2Legs(seq);
% 
% tt     = path(:,8);
% tt     = mjd20002mjd(tt);
% epochs = [tt(1:end-1) tt(2:end) ];
% vecDV  = [ dv; norm(dvv) ];
% 
% struc.id1           = seq(1);
% struc.id2           = seq(end) + 11;
% 
% struc.id1GTOC       = seq(1);
% struc.id2GTOC       = seq(end);
% 
% struc.t1            = epochs(1,1);
% struc.t2            = epochs(end,2);
% struc.tof12         = epochs(end,2) - epochs(1,1);
% struc.tof12y        = ( epochs(end,2) - epochs(1,1) )/365.25;
% struc.dv1           = vecDV(1);
% struc.dv2           = vecDV(end);
% struc.dvtot         = sum(vecDV);
% 
% struc.legsASTRA     = fromSeq2Legs(path(:,7)');
% struc.epochsMJD2000 = [path(1:end-1,8) path(2:end,8) ];
% 
% struc.legsGTOC     = legs;
% struc.epochsMJD    = epochs;
% 
% struc.statesObjDep  = statesObjDep;
% struc.statesObjArr  = statesObjArr;
% struc.statesDepBM   = [ rrd vvouBM ];
% struc.statesDep     = [ rrd vvd ];
% struc.statesArr     = [ rra vva ];
% struc.statesArrTAR  = [ rra vvaTAR ];
% struc.dv            = vecDV;
% struc.path          = path;

end
