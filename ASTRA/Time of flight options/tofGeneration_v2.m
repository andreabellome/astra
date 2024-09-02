function [tofs, minTOF, maxTOF, tstep] = tofGeneration_v2(plIN, plT, Nrev, tstep)

% semi-automatic time of flight generation

if Nrev(1) == 0 % ZERO REVOLTUION (0-1)
    
    plts = [plIN plT];
    indxs = find(plts > 4);
    if isempty(indxs)
        plmax = max(plts);
        if plmax == 4
            minTOF = 50;
            maxTOF = 850;
        else
            minTOF = 50;
            maxTOF = 750;
        end
    else
        minTOF = 500;
        maxTOF = 2500;
    end
    
else % MULTI REVOLUTION (1-2)
   
    minTOF = 365;
    maxTOF = 2500;
    
end

if plT > 4
    tstep = 4;
end
tofs  = minTOF:tstep:maxTOF;

end