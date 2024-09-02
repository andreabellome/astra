function [LEGSnext, VASnext, VINFnext, indxs] = prune_TOFY_tot(LEGSnext, VASnext, VINFnext, tofyTOT)

% DESCRIPTION:
% This function prunes the possible trajectory legs based on the total time of flight (TOF). 
% It removes any trajectory legs where the total time of flight exceeds a specified limit.
%
% INPUT:
% LEGSnext : Matrix containing the possible trajectory legs, where each row represents a leg with columns 
%            for departure and arrival planets, departure and arrival times, and the delta-v required.
% VASnext  : Matrix containing the arrival velocities at the destination planets for each leg.
% VINFnext : Vector containing the incoming velocities at the destination planets for each leg.
% tofyTOT  : Scalar specifying the maximum allowable total time of flight in years.
%
% OUTPUT:
% LEGSnext : Matrix with trajectory legs that exceed the specified time of flight limit removed.
% VASnext  : Matrix with corresponding rows removed from the arrival velocities.
% VINFnext : Vector with corresponding entries removed from the incoming velocities.
% indxs    : Vector containing the indices of the removed trajectory legs.
% 
% -------------------------------------------------------------------------

if ~isempty(LEGSnext)
    if ~isempty(tofyTOT)
        tofys             = (LEGSnext(:,end) - LEGSnext(:,2))./365.25;
        indxs             = find(tofys > tofyTOT);
        LEGSnext(indxs,:) = [];
        VASnext(indxs,:)  = [];
        VINFnext(indxs,:) = [];
    end
end

end