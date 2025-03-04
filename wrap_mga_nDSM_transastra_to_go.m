function [DV, dv, t0, tofs, MAT, output] = wrap_mga_nDSM_transastra_to_go(seq, x, NmanLeg, customEphemerides, plotsol)

if nargin == 3
    customEphemerides = @EphSS_cartesian;
    plotsol           = 0;
elseif nargin == 4
    plotsol           = 0;
else
    if isempty(plotsol) || plotsol == 0 || plotsol == false
        plotsol = 0;
    else
        plotsol = 1;
    end
end

t0   = x(1);
x(1) = [];

tofs               = x(1:length(seq)-1);
x(1:length(seq)-1) = [];

dv1    = x(1:3);
x(1:3) = [];

ndvs        = sum(NmanLeg);
dvs         = x(1:ndvs*3);
x(1:ndvs*3) = [];

eps               = x(1:sum(NmanLeg));
x(1:sum(NmanLeg)) = [];

nfbs      = length(seq)-2;
eta       = x(1:nfbs);
x(1:nfbs) = [];
rps       = x(1:nfbs);
x(1:nfbs) = [];

try
    [DV, dv, MAT, output] = mga_nDSM_customEph(seq, t0, tofs, dv1, dvs, eps, eta, rps, NmanLeg, customEphemerides, plotsol);

%     [ dv_end ] = deltaV_hyperbola( dv(end), 500e3, 1e6, 398600.446192176 );
%     dv(end)    = dv_end;
%     DV         = sum(dv);

%     DV = dv(end);

    tf = t0 + sum(tofs);

    if tf < 10376.5
        if dv(2) > 4 || tf > 10376.5
            DV = 1e99;
        else
            DV = dv(end);
        end
        DV = sum(dv(2:end));
    else
        DV = 1e99;
    end

%     muPlanet = 62.68;
%     sma      = 2487.3;
%     ecc      = 0.7;
%     rp       = sma*( 1 - ecc );
%     ra       = sma*( 1 + ecc );
% 
%     [~, vpip] = Vinf2Hyperbola(dv(end), rp, muPlanet);
%     vp        = sqrt((2*muPlanet)/(rp + ra)*(ra/rp));
%     dv(end)   = vpip - vp;
%     
%     vinf_free   = 3;
%     dv(1)       = (dv(1) - vinf_free).*(dv(1) - vinf_free >= 0);
%     DV          = sum(dv);

catch
    DV  = 1e3;
    dv  = [];
    MAT = [];
end

end
