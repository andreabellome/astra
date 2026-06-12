function [struc] = postProcessPathASTRA_dsm_lowThrust( dv, ...
    output, MAT, vdep_free, varr_free, idcentral, customEphemerides, decl_min, decl_max)

% DESCRIPTION
%
% THIS FUNCTION IS STILL WORK IN PROGRESS!!
%
% This function processes the output of a low-thrust trajectory optimization 
% problem to generate a structured output. It calculates velocity adjustments 
% (DSM), ephemerides, and departure/arrival states, while considering constraints 
% such as flyby conditions and central body parameters.
%
% INPUT
% - dv        : list of impulsive DVs along the MGA as from the function
%               wrap_mga_nDSM.m
% - output    : structure of the MGA trajectory with DSMs as from the
%               function wrap_mga_nDSM.m
% - MAT       : matrix with details of the MGA trajectory as from the
%               function wrap_mga_nDSM.m
% - vdep_free : departure infinity velocity provided by the launcher 'for
%               free' - if 0, then a departure manoeuvre is imparted by the
%               SC [km/s] 
% - varr_free : scalar, maximum arrival velocity (default is 0 if not
%               provided) [km/s] - if 0, a rendezvous with the final object
%               is assumed.
% - idcentral : scalar, central body identifier (default is 1 for Sun) -
%               see also constants.m
% - customEphemerides : anonymous function defining the custom ephemerides.
% - decl_min  : min. declination angle at launch [rad] (by dafault -Inf)
% - decl_max  : max. declination angle at launch [rad] (by dafault +Inf)
%
% OUTPUT
% - struc : structure containing detailed information about the trajectory,
%           including departure and arrival states, velocity adjustments,
%           and ephemerides for each transfer leg.
%
% -------------------------------------------------------------------------

if nargin == 7
    decl_min = -Inf;
    decl_max = +Inf;
end

vdep = vdep_free; % --> free
varr = varr_free; % --> free (0 implies a rendezvous -- match position and velocity with final planet)

for inds = 1:size(MAT,1)
    
    struc(inds).idD = MAT(inds,1);
    struc(inds).idA = MAT(inds,3);

    struc(inds).tD  = MAT(inds,2);
    struc(inds).tA  = MAT(inds,4);
    
    rrd = output(inds).yy(1,1:3);
    vvd = output(inds).yy(1,4:6);
    
    rra = output(inds).yy(end,1:3);
    vva = output(inds).yy(end,4:6);

    if inds == 1
        
        % --> start: first leg of the transfer
        p0           = MAT(inds,1);
        t0           = MAT(inds,2);
        % [rrga, vvga] = customEphemerides(p0, t0, idcentral);
        % if norm(vvga - vvd(1,:)) > vdep % --> DSM on the first leg
        %     vvinfPM = vvd(1,:) - vvga;
        %     vvinfPM = vdep.*vvinfPM./norm( vvinfPM ) ;
        %     vvBM    = vvinfPM + vvga;
        %     dv(inds) = norm(vvd(1,:) - vvBM);
        % else
        %     vvBM     = vvd(1,:);
        %     dv(inds) = 0;
        % end
        [vvBM, dv(inds)] = first_leg_of_the_transfer( idcentral, ...
            customEphemerides, p0, t0, ...
            vvd(1,:), vdep, decl_min, decl_max);
        vvdTar = vvBM;
        % --> end: first leg of the transfer

    else
        vvdTar = vvd;
    end
    
    % --> these are for LT
    struc(inds).xxDtar    = [ rrd(1,:) vvdTar(1,:) ];
    struc(inds).xxAtar    = [ rra(1,:) vva(1,:) ];

    % --> these are from Lambert
    struc(inds).xxDlam    = [ rrd(1,:) vvd(1,:) ];
    struc(inds).xxAlam    = [ rra(1,:) vva(1,:) ];
    
    if struc(inds).idD < 1e99
        [rrga1, vvga1] = customEphemerides(struc(inds).idD, struc(inds).tD, idcentral);
    else
        rrga1 = rrd;
        vvga1 = vvd;
    end
    statesObjDep = [ rrga1, vvga1 ];

    if struc(inds).idA < 1e99
        [rrga2, vvga2] = customEphemerides(struc(inds).idA, struc(inds).tA, idcentral);
    else
        rrga2 = rra;
        vvga2 = vva;
    end
    statesObjArr = [ rrga2 vvga2 ];

    % --> these are of the objects
    struc(inds).xxObjD = statesObjDep(1,:);
    struc(inds).xxObjA = statesObjArr(1,:);

    struc(inds).dvvD = [NaN NaN NaN];
    struc(inds).dvvA = [NaN NaN NaN];

    dvD = dv(inds);

    if inds == size(MAT,1)
        dvA = dv(inds+1);
    else
        dvA = 0;
    end

    struc(inds).dvD = norm( dvD );
    struc(inds).dvA = norm( dvA );

end

% --> start: last leg of the transfer
p1           = MAT(end,3);
t1           = MAT(end,4);
[~, vvga]    = customEphemerides(p1, t1, idcentral);

vva = output(end).yy(end,4:6);
if norm(vvga - vva(end,:)) > varr % --> DSM on the first leg
    dvv  = abs( norm(vvga - vva(end,:)) - varr ).*(vvga - vva(end,:))./norm(vvga - vva(end,:));
    vvPM = vva(end,:) + dvv;
else
    vvPM = vva(end,:);
    dvv  = vvPM - vva;
end
vvaTAR        = vva;
vvaTAR(end,:) = vvPM;

struc(end).xxAtar = [ rra(1,:) vvaTAR(1,:) ];
struc(inds).dvA   = norm( dvv );
% --> end: last leg of the transfer

IDA   = [ struc.idA ];
IDD   = [ struc.idD ];

indxsIDD = find( IDD < 1e99 )';
indxsIDA = find( IDA < 1e99 )';

indxs = [ indxsIDD, indxsIDA ];

for indddd = 1:size(indxs,1)
    
    strucNew(indddd).idD = struc(indxs(indddd,1)).idD;
    strucNew(indddd).idA = struc(indxs(indddd,2)).idA;

    strucNew(indddd).tD = struc(indxs(indddd,1)).tD;
    strucNew(indddd).tA = struc(indxs(indddd,2)).tA;

    strucNew(indddd).xxDtar = struc(indxs(indddd,1)).xxDtar;
    strucNew(indddd).xxAtar = struc(indxs(indddd,2)).xxAtar;

    
    strucNew(indddd).xxDlam = struc(indxs(indddd,1)).xxDlam;
    strucNew(indddd).xxAlam = struc(indxs(indddd,2)).xxAlam;

    strucNew(indddd).xxObjD = struc(indxs(indddd,1)).xxObjD;
    strucNew(indddd).xxObjA = struc(indxs(indddd,2)).xxObjA;
    
    strucNew(indddd).dvvD = struc(indxs(indddd,1)).dvvD;
    strucNew(indddd).dvvA = struc(indxs(indddd,2)).dvvA;

    strucNew(indddd).dvD = sum([struc(indxs(indddd,1):indxs(indddd,2)).dvD]);
    strucNew(indddd).dvA = sum([struc(indxs(indddd,1):indxs(indddd,2)).dvA]);

end

struc = strucNew;

end