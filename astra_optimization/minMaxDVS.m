function [dvsMin, dvsMax] = minMaxDVS(dvsMaxMag, NmanLeg)

dvsMin = [];
dvsMax = [];
for indman = 1:length(NmanLeg)
    dvsMin = [ dvsMin zeros( 1, 3*(NmanLeg(indman)-1) ) 0 0 0 ];
    dvsMax = [ dvsMax dvsMaxMag.*ones( 1, 3*(NmanLeg(indman)-1) ) 0 0 0];
end

end