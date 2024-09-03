function [statesSYN] = wrapECI2Synodic_SE(statesECI, epochs, idcentral, pl)

% This function transforms the states of an object from eclipticJ2000
% reference frame to Sun-Earth Synodic reference frame (i.e., co-rotating
% with the Earth).
%
% INPUT :
% - statesECI : (Nx6) [rr, vv] state vectors in eclipticJ2000 frame taken
%               at different epochs (km, km/s)
% - epochs    : (Nx1) epochs at which the state vectors are computed
%               (MJD2000) 
% - idcentral : ID of the central body. See constants.m
% 
% OUTPUT :
% - statesSYN : (Nx6) [rr, vv] state vectors in Sun-Earth Synodic frame
%               taken at the same epochs (Lref, Vref)
%
% -------------------------------------------------------------------------

if nargin == 2
    idcentral = 1;
    pl        = 3;
elseif nargin == 3
    if idcentral == 1
        pl = 3;
    elseif idcentral == 5
        pl = 5;
    elseif idcentral == 6
        pl = 5;
    elseif idcentral == 7
        pl = 5;
    end
end

if idcentral == 1 % --> SUN-EARTH
    mus = 132724487690;
    mue = 398600.446192176;
else % --> PLANED_ID-MOON_ID
    [mus, mue] = constants(idcentral, pl);   
end

statesSYN = zeros( size(statesECI,1), 6 );
for inds = 1:size(statesECI,1)
    [rr, vv]           = EphSS_cartesian(pl, epochs(inds), idcentral);
    [Xsyn]             = eci2synodic_eph(statesECI(inds,:), [rr, vv], mus, mue);
    statesSYN(inds,:)  = [Xsyn(1:3)' Xsyn(4:6)'];
end

end
