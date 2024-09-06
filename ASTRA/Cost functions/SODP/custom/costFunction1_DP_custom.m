function [legn, vvf, vinff] = costFunction1_DP_custom(legn, vvf, vinff)

costTOTn = sum( legn(:,6:3:end-2) , 2); 
[~, row] = min(costTOTn);

legn  = legn(row,:);
vvf   = vvf(row,:);
vinff = vinff(row,:);

end