function [EPH] = generateEPH(M, idcentral, customEphemerides)

% DESCRIPTION:
% This function generates an ephemeris matrix by computing the Cartesian position and velocity vectors for each
% time pair in the provided matrix. The result includes both the input time pairs and the computed vectors.
% 
% INPUT:
% M                 : Matrix where each row contains a time pair with the format [planet ID, time]. The matrix represents either
%                     departure or arrival times.
% idcentral         : ID of the central body. See constants.m 
% customEphemerides : user-defined custom ephemerides. See EphSS_cartesian.m for reference
%
% OUTPUT:
% EPH : Matrix where each row includes the original time pair followed by the Cartesian position (rr) and velocity (vv) vectors.
%       The matrix has 8 columns in total: [planet ID, time, rr (3 columns), vv (3 columns)].
% 
% NOTES:
% - `EphSS_cartesian` is a helper function that computes the Cartesian position and velocity vectors for given object ID and time.
% 
% -------------------------------------------------------------------------

if nargin == 1
    idcentral = 1;
elseif nargin == 2
    customEphemerides = @EphSS_cartesian;
end

EPH = zeros( size(M,1) , 8);
for indm1 = 1:size(M,1)
    try
    [rr, vv]     = customEphemerides(M(indm1,1), M(indm1,2), idcentral);
    catch
        st = 1;
    end
    EPH(indm1,:) = [M(indm1,:) rr vv];
end

end