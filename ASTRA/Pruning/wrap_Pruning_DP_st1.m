function [LEGSn, VASn, VINFn] = wrap_Pruning_DP_st1(LEGSn, VASn, VINFn, INPUT)

% DESCRIPTION:
% This function applies a series of pruning operations to filter out invalid or undesirable trajectory legs
% based on several criteria. It first removes any legs with invalid data, then prunes legs based on incoming 
% velocity limits and total time of flight constraints.
% 
% INPUT:
% LEGSn  : Matrix containing the possible trajectory legs, where each row represents a leg with columns 
%           for departure and arrival planets, departure and arrival times, and the delta-v required.
% VASn   : Matrix containing the arrival velocities at the destination planets for each leg.
% VINFn  : Vector containing the incoming velocities at the destination planets for each leg.
% INPUT  : Structure containing various constraints and limits, including:
%           - vInfLim : Matrix specifying the minimum and maximum allowable incoming velocities.
%           - tofyMax : Scalar specifying the maximum allowable total time of flight in years.
% 
% OUTPUT:
% LEGSn  : Matrix with trajectory legs filtered based on the pruning criteria.
% VASn   : Matrix with corresponding rows removed from the arrival velocities.
% VINFn  : Vector with corresponding entries removed from the incoming velocities.
%
% -------------------------------------------------------------------------


% --> pruning criteria for the first leg
[LEGSn, VASn, VINFn] = check_ISNAN_DP(LEGSn, VASn, VINFn);
[LEGSn, VASn, VINFn] = prune_VINFn_DP(LEGSn, VASn, VINFn, INPUT.vInfLim); % --> prune those exceeding the VINFn
[LEGSn, VASn, VINFn] = prune_TOFY_tot(LEGSn, VASn, VINFn, INPUT.tofyMax); % --> prune those exceeding the total TOFy

end