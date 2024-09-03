function [rr, vv] = EphSS_cartesian(pl, t, idcentral)

% DESCRIPTION:
% This function computes the Cartesian position (rr) and velocity (vv) vectors for a given celestial body at a specific time.
% It uses different ephemeris functions depending on the type of body, such as planets, asteroids, or other objects.
% 
% INPUT:
% pl : Identifier for the celestial body. 
%      - Values <= 10 correspond to planets in the Solar System.
%      - Values between 11 and 473 correspond to Jupiter-family comets.
%      - Values between 474 and 1183 correspond to Centaurs.
%      - Value 1194 corresponds to the asteroid Lutetia.
%      - Other values are handled by a default ephemeris function.
% 
% t          : Time at which the position and velocity vectors are to be computed.
% idcentral  : ID of the central body. See constants.m
% 
% OUTPUT:
% rr : Cartesian position vector of the celestial body (3x1 vector).
% vv : Cartesian velocity vector of the celestial body (3x1 vector).
% 
% FUNCTION CALLS:
% EphSS_car    : Computes ephemeris for planets in the Solar System.
% EphCA_car    : Computes ephemeris for Jupiter-family comets.
% EphCE_car    : Computes ephemeris for Centaurs.
% EphLutetia   : Computes ephemeris for the asteroid Lutetia.
% EphLOWq      : Computes ephemeris for other celestial bodies not covered by the specific cases.
% 
% -------------------------------------------------------------------------

if nargin == 2
    idcentral = 1;
end

if idcentral == 1 % --> central body is SUN

    if pl <= 10
        [rr, vv] = EphSS_car(pl, t);
    %     [rr, vv] = EphAA_car(pl, t);
    elseif pl >= 1 + 10 && pl <= 463 + 10 % --> JFC
        pl       = pl - 10;
        [rr, vv] = EphCA_car(pl, t);
    elseif pl >= 1 + 10 + 463 && pl <= 720 + 10 + 463 % --> CENTAURS
        pl       = pl - (10 + 463);
        [rr, vv] = EphCE_car(pl, t);
    elseif pl == 1194 % --> Lutetia
        [rr, vv] = EphLutetia(pl, t);
    else
        [rr, vv] = EphLOWq(pl, t);
    end

else % --> moon's systems

    [rr, vv] = approxEphem_CC(pl, t, idcentral);

end

end