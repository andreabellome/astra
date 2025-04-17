function [ tt, sv ] = hcw_equations( rr0, vv0, tt, rtgt, mupl )

om = sqrt( mupl/(rtgt^3) );

x0 = rr0(1);
y0 = rr0(2);
z0 = rr0(3);

x0_dot = vv0(1);
y0_dot = vv0(2);
z0_dot = vv0(3);

xx    = x0_dot/om.*sin( om.*tt ) - ( 3*x0 + 2*y0_dot/om ).*cos( om.*tt ) + ( 4*x0 + 2*y0_dot/om );
yy    = ( 6*x0 + 4*y0_dot/om ).*sin( om.*tt ) + ( 2*x0_dot/om ).*cos( om.*tt ) - ( 6*om*x0 + 3*y0_dot ).*tt + ( y0 - 2*x0_dot/om );
zz    = z0.*cos( om.*tt ) + z0_dot/om.*sin( om.*tt );

xx_dot = x0_dot.*cos( om.*tt ) + ( 3*om*x0 + 2*y0_dot ).*sin( om.*tt );
yy_dot = ( 6*om*x0 + 4*y0_dot ).*cos( om.*tt ) - 2*x0_dot.*sin( om.*tt ) - ( 6*om*x0 + 3*y0_dot );
zz_dot = -z0*om.*sin( om.*tt ) + z0_dot.*cos( om.*tt );

sv = [ xx', yy', zz', xx_dot', yy_dot', zz_dot' ];

end