function [dv1Min, dv1Max] = minMaxFirstMan(vinfMin, vinfMax, optFirstMan, NmanLeg)

NmanLegF = NmanLeg(1);
if optFirstMan == 1
    if NmanLegF < 2
        NmanLegF = 1;
    end
else
    if NmanLegF < 2
        NmanLegF = 0;
    end
end

if NmanLegF == 0
    dv1Min = [  0  0  0 ];
    dv1Max = [  0  0  0 ];
else
    dv1Min = [ vinfMin  0  0 ];
    dv1Max = [ vinfMax pi 2*pi ];
end

end