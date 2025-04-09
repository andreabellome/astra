function [TOFS, minTOF, maxTOF, tst] = wrap_TOFs(pl1, pl2, optMR, tstep, TOF_LIM, indl)

if ~isempty(TOF_LIM)
    minTOF = TOF_LIM(indl,1);
    maxTOF = TOF_LIM(indl,2);
    TOFS   = [minTOF:tstep:maxTOF]';
else
    if pl2 <= 1193
        [~, minTOF, maxTOF, tst] = TOF_per_LEGS_ASTRA(pl1, pl2, optMR, tstep, TOF_LIM, indl);       % --> TOF for the given leg
    else
        minTOF = 50;
        maxTOF = 2500;
        tst    = 10;
    end
    TOFS = [minTOF:tst:maxTOF]';
end


end