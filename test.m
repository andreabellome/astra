
[muCentral, mu_earth] = constants(1, 3)

rpip = 500 + 6378;
rat  = 500 + 6378;

sma = 0.5*( rpip + rat )
ecc = ( rat - rpip )/( rpip + rat )
period = 2*pi*sqrt( sma*sma*sma/mu_earth )/86400

[ dv ] = deltaV_hyperbola( 0.65, rpip, rat, mu_earth );

[mf, k, mp] = rocketEq_givenDV(2e3, 1.943e3, 330);
mp
[mf, k, mp] = rocketEq_givenDV((20e3), 0.524e3, 330);
mp
