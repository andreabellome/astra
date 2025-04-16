function [legn, vvf, vinff] = STM_derivation(legn, vvf, vinff, vv1, rr1, vasprev, legprev)

dvDEF = legn(:,end-2);             % --> defects
tf    = zeros(size(legprev,1),1);
dvDSM = zeros(size(legprev,1),1);

for indlprev = 1:size(legprev,1)

    t1                                  = legprev(indlprev,end-3);
    t2                                  = legprev(indlprev,end);
    [CC, tt0]                           = computeCC_DP(t1, t2, vv1, [rr1, vasprev(indlprev,:)]); % --> compute the control
    [dvDSM(indlprev,1), tf(indlprev,1)] = fromC2DSM(CC, dvDEF(indlprev));                        % --> compute the DSM
    
%     INPUT.res           = [];
%     newLEGS             = reconstructLEGS(legn(indlprev,:), zeros(size(legn(indlprev,:),1), 2), INPUT);
%     pathrow             = constructPath(newLEGS);
%     [~, DSM_prediction] = convertDefect_STM(pathrow);
%     dvDSM(indlprev,1)   = DSM_prediction(end-1).DSM;

end
legn(:,end-2) = dvDSM;

end