function [LEGSnext, VASnext, VINFnext] = prune_VINFn_DP(LEGSnext, VASnext, VINFnext, vinflim)

% DESCRIPTION:
% This function prunes the possible trajectory legs based on specified limits for the incoming velocity (`VINF`). 
% It removes any trajectory legs where the incoming velocity falls outside the specified range.
% 
% INPUT:
% LEGSnext : Matrix containing the possible trajectory legs, where each row represents a leg with columns 
%            for departure and arrival planets, departure and arrival times, and the delta-v required.
% VASnext  : Matrix containing the arrival velocities at the destination planets for each leg.
% VINFnext : Vector containing the incoming velocities at the destination planets for each leg.
% vinflim  : Matrix specifying the minimum and maximum allowable incoming velocities for each planet in the sequence.
% 
% OUTPUT:
% LEGSnext : Matrix with trajectory legs that have incoming velocities outside the specified limits removed.
% VASnext  : Matrix with corresponding rows removed from the arrival velocities.
% VINFnext : Vector with corresponding entries removed from the incoming velocities.
% 
% -------------------------------------------------------------------------


if ~isempty(LEGSnext)
    if ~isempty(vinflim)
        nplts   = length(LEGSnext(1,1:3:end-1));

        vinfMin = vinflim(nplts,1);
        vinfMax = vinflim(nplts,2);
        indxs   = find( VINFnext < vinfMin | VINFnext > vinfMax ) ;

        LEGSnext(indxs,:) = [];
        VASnext(indxs,:)  = [];
        VINFnext(indxs,:) = [];
    end
end

end