function [CC, tt0] = computeCC_DP(tpl1, tpl2, vvpl, cartIN)

tof   = tpl2 - tpl1;
tstep = tof/10;
tt0   = unique([0:tstep:tof]);

CC = zeros(4, 4, length(tt0));
for indt0 = 1:length(tt0)
    CC(:,:,indt0) = DSM_STM_v2(tof, vvpl, cartIN, tt0(indt0));
end

end