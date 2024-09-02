function [legn, vvf, vinff] = costFunction1_DP(legn, vvf, vinff)

% DESCRIPTION:
% This function selects the optimal trajectory based on the minimum total cost,  
% defined by the user. The function takes in multiple candidate trajectories 
% and their associated velocities, evaluates them, and returns the best one 
% according to the defined cost criteria.
%
% INPUT:
% legn   : Matrix where each row represents a different candidate trajectory,
%          and the columns correspond to different legs of the trajectory. 
%          The cost for each leg is stored in the 3rd column of each group of three columns.
% vvf    : Matrix where each row contains the final velocities for the corresponding 
%          candidate trajectories.
% vinff  : Matrix where each row contains the incoming velocities for the corresponding 
%          candidate trajectories.
%
% OUTPUT:
% legn   : The optimal trajectory (row) from the input `legn` matrix, based on the minimum total cost.
% vvf    : The final velocities associated with the optimal trajectory.
% vinff  : The incoming velocities associated with the optimal trajectory.
%
% -------------------------------------------------------------------------

costTOTn = sum( legn(:,3:3:end-2) , 2); 
[~, row] = min(costTOTn);

legn  = legn(row,:);
vvf   = vvf(row,:);
vinff = vinff(row,:);

end