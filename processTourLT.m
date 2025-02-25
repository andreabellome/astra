function LT_TRANSFER = processTourLT(strucToSave)

tEnd = 0;
TRANSFER = [];
ST_12    = [];
for inds = 1:length(strucToSave)
    
    transfer = strucToSave(inds).LTsol.transfer;
    
    if inds > 1
        tEnd = tEnd + strucToSave(inds-1).LTsol.param.tEnd;
        transfer(:,1) = transfer(:,1) + tEnd;
    end

    TRANSFER = [TRANSFER; transfer];
    state1   = transfer(1,2:7);
    state2   = transfer(end,2:7);
    ST_12    = [ ST_12; state1 state2 ];

end

LT_TRANSFER.TRANSFER = TRANSFER;
LT_TRANSFER.ST_12    = ST_12;

end