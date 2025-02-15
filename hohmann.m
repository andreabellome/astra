function [hohmann] = hohmann(r1, r2, mu)

v1 = sqrt(mu/r1);
v2 = sqrt(mu/r2);

rr1 = r1.*[1 0 0];
vv1 = v1.*[0 1 0];

rr2 = r2.*[-1 0 0];
vv2 = v2.*[0 -1 0];

if r1 < r2
    
    rp  = r1;
    ra  = r2;
    vpt = sqrt((2*mu)/(rp + ra)*(ra/rp));
    vat = sqrt((2*mu)/(rp + ra)*(rp/ra));
    
    dv1 = vpt - v1;
    dv2 = v2 - vat;
        
    at = 0.5*(r1 + r2);
    Tt = pi*sqrt(at^3/mu);
    
    vvpt = vpt.*[0 1 0];
    vvat = vat.*[0 -1 0];
        
    dvv1 = vvpt - vv1; 
    dvv2 = vv2 - vvat; 
    
    vvd = vvpt;
    vva = vvat;
        
elseif r1 > r2
    
    ra = r1;
    rp = r2;
    vpt = sqrt((2*mu)/(rp + ra)*(ra/rp));
    vat = sqrt((2*mu)/(rp + ra)*(rp/ra));

    dv1 = v1 - vat;
    dv2 = vpt - v2;
        
    at = 0.5*(r1 + r2);
    Tt = pi*sqrt(at^3/mu);
    
    vvpt = vpt.*[0 -1 0];
    vvat = vat.*[0 1 0];
    
    dvv1 = vv1 - vvat;
    dvv2 = vvpt - vv2;
    
    vvd = vvat;
    vva = vvpt;

elseif r1 == r2
    
    dv1 = 0;
    dv2 = 0;
    Tt  = 0;
    
    dvv1 = [0 0 0];
    dvv2 = [0 0 0];

end

% --> save the results
hohmann.r1   = r1;
hohmann.v1   = v1;
hohmann.rr1  = rr1;
hohmann.vv1  = vv1;
hohmann.r2   = r2;
hohmann.v2   = v2;
hohmann.rr2  = rr2;
hohmann.vv2  = vv2;
hohmann.vvd  = vvd;
hohmann.vva  = vva;
hohmann.dvv1 = dvv1;
hohmann.dvv2 = dvv2;
hohmann.dv1  = dv1;
hohmann.dv2  = dv2;
hohmann.dvt  = dv1 + dv2;
hohmann.Tt   = Tt;

end