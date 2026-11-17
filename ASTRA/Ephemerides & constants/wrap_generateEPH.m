function [EPH] = wrap_generateEPH(M1, M2, idcentral, customEphemerides)

% DESCRIPTION:
% This function generates a combined ephemeris matrix by generating ephemeris data for two sets of planetary time pairs,
% and then combining and deduplicating the results.
% 
% INPUT:
% - M1                : Matrix of unique departure time pairs, where each row contains departure planet ID and initial time.
% - M2                : Matrix of unique arrival time pairs, where each row contains arrival planet ID and arrival time.
% - idcentral         : ID of the central body. See constants.m
% - customEphemerides : user-defined custom ephemerides. See EphSS_cartesian.m for reference
%
% OUTPUT:
% - EPH : Combined ephemeris matrix containing unique rows of ephemeris data for both departure and arrival time pairs.
% 
% IMPLEMENTATION NOTE (drop-in replacement, identical input/output)
% The original evaluated the ephemerides for all rows of M1 and of M2 and
% only then removed duplicate rows. When departure and arrival share
% (body, epoch) pairs (e.g. Earth-Earth legs) the same ephemeris was
% evaluated twice. Here the (body, epoch) pairs are deduplicated first, in
% the same 'stable' order, so each ephemeris is evaluated once. Since the
% ephemeris is a deterministic function of (body, epoch), EPH is identical.
% 
% -------------------------------------------------------------------------

if nargin == 2
    idcentral = 1;
    customEphemerides = @EphSS_cartesian;
elseif nargin == 3
    customEphemerides = @EphSS_cartesian;
end

M   = unique([M1; M2], 'rows', 'stable');
EPH = generateEPH(M, idcentral, customEphemerides);

end
