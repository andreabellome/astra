function [LEGSnext, VASnext, VINFnext] = prune_VINF_DP(LEGSnext, VASnext, VINFnext, INPUT)

% DESCRIPTION
% This function prunes the sets of legs, velocity asymptotes (VAS), and 
% velocity-infinity vectors (VINF) based on specified velocity-infinity 
% limits. It removes entries where the velocity-infinity exceeds or is less 
% than the given limits.
% 
% INPUT
% - LEGSnext : Matrix containing the legs data, where the last column 
%              represents the velocity-infinity data.
% - VASnext  : Matrix containing the velocity asymptote data.
% - VINFnext : Matrix containing the velocity-infinity data.
% - INPUT    : Structure containing velocity-infinity options:
%              - vInfOpts : A 2-element vector with minimum and maximum 
%                           allowable velocity-infinity values.
% 
% OUTPUT
% - LEGSnext : Pruned matrix of legs data, with entries removed based on 
%              velocity-infinity limits.
% - VASnext  : Pruned matrix of velocity asymptote data, corresponding to 
%              the remaining entries in LEGSnext.
% - VINFnext : Pruned matrix of velocity-infinity data, corresponding to 
%              the remaining entries in LEGSnext.
% 
% PROCESS
% - Remove rows from LEGSnext, VASnext, and VINFnext where the velocity-infinity 
%   is outside the range defined by INPUT.vInfOpts.
% 
% -------------------------------------------------------------------------

indxs             = find(LEGSnext(:,end-2) > INPUT.vInfOpts(2));
LEGSnext(indxs,:) = [];
VASnext(indxs,:)  = [];
VINFnext(indxs,:) = [];

indxs             = find(LEGSnext(:,end-2) < INPUT.vInfOpts(1));
LEGSnext(indxs,:) = [];
VASnext(indxs,:)  = [];
VINFnext(indxs,:) = [];

end