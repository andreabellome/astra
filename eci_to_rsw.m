function [rr_RSW, vv_RSW, T] = eci_to_rsw( rr_tgt_eci, vv_tgt_eci )

rr = rr_tgt_eci(:);
vv = vv_tgt_eci(:);
hh = cross( rr, vv );

rr_hat = rr./norm( rr );
ww_hat = hh./norm( hh );
ss_hat = cross( ww_hat, rr_hat );

T = [rr_hat'; ss_hat'; ww_hat'];

rr_RSW = T * rr;
vv_RSW = T * vv;

rr_RSW = rr_RSW';
vv_RSW = vv_RSW';

% hh_RSW = cross( rr_RSW, vv_RSW );
% ee_RSW = 1/(mupl)*cross( vv_RSW, hh_RSW ) - rr_RSW./norm( rr_RSW );
% 
% lambda = atan2( ee_RSW(2), ee_RSW(1) );
% nu1    = -lambda;

end