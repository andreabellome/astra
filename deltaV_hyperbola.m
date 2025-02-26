function [ dv ] = deltaV_hyperbola( vinf, rpip, rat, mu )

[~, vpip]      = Vinf2Hyperbola(vinf, rpip, mu);

vel_peri        = @( rp, ra, mu ) sqrt( ( 2*mu )/(rp + ra)*( ra/rp ) );
vp              = vel_peri( rpip, rat, mu );

% --> delta-v
dv = vpip - vp;

end