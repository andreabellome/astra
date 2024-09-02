function [tofs, minTOF, maxTOF, tstep] = TOF_per_LEGS_ASTRA(plIN, plT, Nrev, tstep, TOF_LIM, indleg)

if plT <= 1193
    
    if isempty(TOF_LIM)
        [tofs, minTOF, maxTOF, tstep] = tofGeneration_v2(plIN, plT, Nrev, tstep); % --> generate semi-automatic time of flight
    else
        minTOF = TOF_LIM(indleg,1);
        maxTOF = TOF_LIM(indleg,2);
        if plT > 4 || plIN > 4
            tstep = 2*tstep;
        end
        if Nrev(1) ~= 0
            tstep = 2*tstep;
        end
        tofs = minTOF:tstep:maxTOF;
    end
    
else
    if isempty(TOF_LIM)
        minTOF = 50;
        maxTOF = 2500;
        if tstep < 10
            tstep = 10;
        end
    else
        minTOF = TOF_LIM(indleg,1);
        maxTOF = TOF_LIM(indleg,2);
        if tstep < 10
            tstep  = 10;
        end
    end
    tofs = minTOF:tstep:maxTOF;
end

end