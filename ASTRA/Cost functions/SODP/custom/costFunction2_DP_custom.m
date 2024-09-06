function [minCOST, row, COSTS, TOFYS] = costFunction2_DP_custom(legn, vvf, vinff)

COSTS          = sum( [ legn(:,6:3:end-2) ], 2);
TOFYS          = (legn(:,end) - legn(:,2))./365.25;
[minCOST, row] = min(COSTS);

end