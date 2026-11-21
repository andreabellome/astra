function [ rr, vv ] = EphSS_cartesian_CC( pl, t, idcentral )

if nargin == 2
    idcentral = 1;
end

if pl <= 10
    % Gravitational constant of the Sun
    mu = 132724487690;

    ref_date        = date2mjd2000( [2000 1 1 0 0 0] );
    t_elapsed_sec   = ( t - ref_date ) * 86400;
    [~, ~, kepref]  = EphSS_car(pl, ref_date);

    kepref(2) = 1e-12;
    kepref(3) = 1e-12;
    
    [rr, vv] = FGKepler_dt(kepref, t_elapsed_sec, mu);

    % car = kep2car(kep, mu);
    % rr  = car(1:3);
    % vv  = car(4:6);

end

end