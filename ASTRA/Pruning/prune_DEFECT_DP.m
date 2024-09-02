function [LEGSnext, VASnext, VINFnext] = prune_DEFECT_DP(LEGSnext, VASnext, VINFnext, defectMax)

% DESCRIPTION:
% This function prunes (removes) trajectory legs that have defects exceeding a specified maximum value. 
% It filters out the legs based on the defect values, along with their associated velocity vectors and final velocity norms.
% 
% INPUTS:
% LEGSnext : Matrix of trajectory legs, where each row contains details of the legs, including defect values.
% VASnext  : Matrix of velocity vectors associated with each trajectory leg.
% VINFnext : Matrix of final velocity norms for each trajectory leg.
% defectMax: Maximum allowed defect value. Legs with defects greater than this value will be removed.
% 
% OUTPUTS:
% LEGSnext : Updated matrix of trajectory legs after pruning.
% VASnext  : Updated matrix of velocity vectors after pruning.
% VINFnext : Updated matrix of final velocity norms after pruning.
% 
% FUNCTION CALLS:
% find   : Finds indices of elements that meet the specified condition (defect value > defectMax).
% 
% -------------------------------------------------------------------------

if ~isempty(LEGSnext)
    indxs             = find(LEGSnext(:,end-2) > defectMax);
    LEGSnext(indxs,:) = [];
    VASnext(indxs,:)  = [];
    VINFnext(indxs,:) = [];
end

end