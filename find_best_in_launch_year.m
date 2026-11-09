function [path, revs, res, minCOST] = find_best_in_launch_year( processed_OUTPUT, date_0, date_1, INPUT )

dep_dates = processed_OUTPUT.LEGS(:,2);
indxs     = find( dep_dates >= date_0 & dep_dates <= date_1 );

[vinflim, TOF_LIM, tstep, tofyMax, costFunc1, costFunc2] = check_INPUT(INPUT); % --> extract the limits on TOF and Vinf, and time step
INPUT.vInfLim                                            = vinflim;            % --> update the INPUT
INPUT.tofyMax                                            = tofyMax;            % --> update the INPUT
INPUT.costFunc1                                          = costFunc1;          % --> update the INPUT
INPUT.costFunc2                                          = costFunc2;          % --> update the INPUT

if isempty(indxs)
    warning('No solutions in the selected dates.');
    path = [];
    revs = [];
    res  = [];
else
    
    LEGSseleted     = processed_OUTPUT.LEGS(indxs,:);
    VASselected     = processed_OUTPUT.VAS(indxs,:);
    VINFselected    = processed_OUTPUT.VINFa(indxs,:);
    REVSselected    = processed_OUTPUT.REVS(indxs,:);

    % --> compute here the SO
    [minCOST, row, COSTS, TOFYS] = INPUT.costFunc2(LEGSseleted, VASselected, VINFselected);
    
    minPATH = LEGSseleted(row,:);
    runOpts = generateDiffRuns(REVSselected(row,:), processed_OUTPUT.res);
    path    = ASTRA_wrapPath_DP(minPATH(1:3:end-1), minPATH(2), diff(minPATH(2:3:end)), runOpts, INPUT.idcentral, INPUT.customEphemerides);
    revs    = REVSselected(row,:);
    res     = processed_OUTPUT.res;

end


end