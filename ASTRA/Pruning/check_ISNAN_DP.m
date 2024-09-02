function [LEGSnext, VASnext, VINFnext] = check_ISNAN_DP(LEGSnext, VASnext, VINFnext)

% DESCRIPTION:
% This function checks for and removes any invalid trajectory legs from the input matrices where the delta-v 
% value is `NaN` (not a number). It cleans up the corresponding entries in the associated velocity matrices as well.
% 
% INPUT:
% LEGSnext : Matrix containing the possible trajectory legs, where each row represents a leg with columns 
%            for departure and arrival planets, departure and arrival times, and the delta-v required.
% VASnext  : Matrix containing the arrival velocities at the destination planets for each leg.
% VINFnext : Vector containing the incoming velocities at the destination planets for each leg.
% 
% OUTPUT:
% LEGSnext : Cleaned matrix with invalid trajectory legs (those with `NaN` delta-v values) removed.
% VASnext  : Cleaned matrix with corresponding rows removed from the arrival velocities.
% VINFnext : Cleaned vector with corresponding entries removed from the incoming velocities.
% 
% -------------------------------------------------------------------------

if ~isempty(LEGSnext)

    indxs = find(isnan(LEGSnext(:,end-2)));

    LEGSnext(indxs,:) = [];
    VASnext(indxs,:)  = [];
    VINFnext(indxs,:) = [];

end

end