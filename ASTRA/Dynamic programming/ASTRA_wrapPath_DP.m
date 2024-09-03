function [path, fig] = ASTRA_wrapPath_DP(seq, t0, tofs, NREVS, idcentral)

% DESCRIPTION :
% this function allows for building the path matrix of an MGA sequence.
% 
% INPUT :
% seq   : vector with planets IDs in the MGA sequence
% t0    : departing epoch (MJD2000)
% tofs  : vector with time of fligth for each leg of the sequence (days)
% NREVS : nx3 matrix (n=length(seq)-1) on which the multiple revolutions
%         options are passed. If NREVS(i,3)~=0, then a resonance is
%         included in the transfer.
% idcentral  : ID of the central body. See constants.m
% 
% OUTPUT :
% path : is the path matrix
% fig  : if requested by the user, a figure with the trajectory is returned
%
% -------------------------------------------------------------------------

if nargin == 4
    idcentral = 1;
end

mu = constants(idcentral, 1);

% --> from tofs to epochs
T = zeros(1, length(tofs)+1);
T(1) = t0;
for indi = 2:length(tofs)+1
    T(indi) = T(indi-1) + tofs(indi-1);
end

legs = fromSeq2Legs(seq); % --> sequence and legs

dv   = zeros(1,length(seq));
path = zeros(length(seq),10);
for indi = 1:size(legs,1)
   
    pl1  = legs(indi,1);
    pl2  = legs(indi,2);
    Nrev = NREVS(indi,:);
    
    t1 = T(indi);
    t2 = T(indi+1);
    
    [r1, v1] = EphSS_cartesian(pl1, t1, idcentral);
    [r2, v2] = EphSS_cartesian(pl2, t2, idcentral);
    
    if Nrev(3) ~= 0 % --> then construct resonant transfers
        res   = [Nrev(3), Nrev(4)];
        legp  = [pl1 t1];
        vasp  = vvIN;
        vinfp = norm(vvIN - v1);
        [~, vasn, ~] = constructResonantOrbits_DP(legp, vasp, vinfp, pl2, res, deg2rad(1));

    else
        [v1Short, v2Short] = lambertMR_MEXIFY_mex(r1, r2, (t2 - t1)*86400, mu, Nrev(1), Nrev(2));
    end
    
    % --> save the path
    if indi == 1
        path(indi,:) = [r1 v1Short pl1 t1 norm(v1Short - v1) 0];
    else
        path(indi,:) = [rrIN vvIN pl1 t1 norm(vvIN - v1) 0];
    end
        
    if indi == 1
        dv(indi,1) = norm(v1Short - v1);
        rrIN = r2;
        vvIN = v2Short;
    elseif Nrev(3) ~= 0
        dv(indi) = 0;
        rrIN     = r1;
        vvIN     = vasn;
    else

        if idcentral == 1
            if pl1 > 11 % --> perform the flyby with an asteroid/comet
                muPL  = 0;
                rpmin = 1000;
            else % --> perform the flyby with a planet
                [muPL, radius] = planetConstants(pl1);
                rpmin          = maxmin_flybyAltitude(pl1) + radius;
            end
        else % --> moon's system
            [~, muPL, ~, radpl, hmin] = constants(idcentral, pl1);
            rpmin                     = radpl + hmin;
        end

        dv(indi) = findDV(vvIN - v1, v1Short - v1, muPL, rpmin); % DSM
        rrIN     = r2;
        vvIN     = v2Short;
    end
        
end
path(end,:) = [rrIN vvIN pl2 t2 norm(v2Short - v2) 0];

% arrival infinity velocity
dv(end) = norm(v2Short - v2);

path(3:end,10) = dv(2:end-1);

path(:,11)    = [NaN; tofs'];
path(:,12:16) = NaN;
path(1,12)    = path(1,9) + sum(path(:,10)) + path(end,9); % --> total cost (km/s)
path(1,14)    = path(1,9);                                 % --> departing vinf (km/s)
path(1,15)    = path(end,9);                               % --> arrival vinf (km/s)
path(1,16)    = sum(path(2:end,11))/365.25;                % --> TOF (years)

if nargout > 1 % --> if requested from the user, plot the trajectory
    [fig] = plotPath(path, idcentral);
end

end