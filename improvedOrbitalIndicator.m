function xx = improvedOrbitalIndicator(rrs, vvs, rrt, vvt, DT)

% --> rr (km), vv (km/s), DT (sec)

% --> improved orbital indicator
xx = [ (1./DT).*rrs + vvs , (1./DT).*rrs, (1./DT).*rrt - vvt, (1./DT).*rrt ];

end