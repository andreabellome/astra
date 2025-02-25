function [xx] = orbitalIndicator(rr, vv, DT)

% --> rr (km), vv (km/s), DT (sec)

% --> orbital indicator
xx = [(1./DT).*rr + vv , (1./DT).*rr];

end