function [DV, dv, t0, tofs, MAT, output] = wrap_mga_nDSM(seq, x, NmanLeg, customEphemerides, plotsol)

if nargin == 3
    customEphemerides = @EphSS_cartesian;
    plotsol   = 0;
elseif nargin == 4
    plotsol   = 0;
else
    if isempty(plotsol) || plotsol == 0 || plotsol == false
        plotsol = 0;
    else
        plotsol = 1;
    end
end

t0   = x(1);
x(1) = [];

tofs = x(1:length(seq)-1);
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
    DV = dv(end);
catch
    DV  = 1e3;
    dv  = [];
    MAT = [];
end

end
