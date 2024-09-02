function [LEGSn, VASn, VINFn] = wrap_Pruning_DP(LEGSn, VASn, VINFn, INPUT)

% DESCRIPTION:
% This function applies a series of pruning steps to filter trajectory legs based on various criteria. 
% It sequentially checks for NaN values, then prunes based on defect limits, final velocity norms, and total time of flight.
% 
% INPUTS:
% LEGSn  : Matrix of trajectory legs to be pruned.
% VASn   : Matrix of velocity vectors corresponding to each trajectory leg.
% VINFn  : Matrix of final velocity norms corresponding to each trajectory leg.
% INPUT  : Structure containing pruning criteria:
%          - INPUT.dsmOpts(1) : Maximum allowed individual defect for pruning.
%          - INPUT.dsmOpts(2) : Maximum allowed total defect for pruning.
%          - INPUT.vInfLim    : Velocity norm limits for pruning.
%          - INPUT.tofyMax    : Maximum allowed total time of flight for pruning.
% 
% OUTPUTS:
% LEGSn  : Pruned matrix of trajectory legs.
% VASn   : Pruned matrix of velocity vectors.
% VINFn  : Pruned matrix of final velocity norms.
% 
% FUNCTION CALLS:
% check_ISNAN_DP   : Removes rows with NaN values in the trajectory legs matrix.
% prune_DEFECT_DP  : Removes rows where the individual defect exceeds the specified limit.
% prune_DEFECTtot_DP : Removes rows where the total defect exceeds the specified limit.
% prune_VINFn_DP   : Removes rows where the final velocity norm exceeds the specified limit.
% prune_TOFY_tot   : Removes rows where the total time of flight exceeds the specified limit.
% 
% -------------------------------------------------------------------------

[LEGSn, VASn, VINFn] = check_ISNAN_DP(LEGSn, VASn, VINFn);
[LEGSn, VASn, VINFn] = prune_DEFECT_DP(LEGSn, VASn, VINFn, INPUT.dsmOpts(1));    % --> prune those exceeding the defect limit
[LEGSn, VASn, VINFn] = prune_DEFECTtot_DP(LEGSn, VASn, VINFn, INPUT.dsmOpts(2)); % --> prune those exceeding the total defect limit
[LEGSn, VASn, VINFn] = prune_VINFn_DP(LEGSn, VASn, VINFn, INPUT.vInfLim);        % --> prune those exceeding the VINFn
[LEGSn, VASn, VINFn] = prune_TOFY_tot(LEGSn, VASn, VINFn, INPUT.tofyMax);        % --> prune those exceeding the total TOFy

end