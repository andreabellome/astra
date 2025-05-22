function NumRevMax = maxRev_LP(tof_days, rr1, rr2, muCentral)

    % --> Understanding maximum number of revolutions
    sma_min    = 1/4*(norm(rr1)+norm(rr2)+norm(rr2-rr1));
    P_min_days = 2*pi*sqrt(sma_min^3/muCentral)/86400;
    NumRevMax  = floor(tof_days/P_min_days);

end