function [DV, dv, t0, tofs, MAT, output] = wrap_mga_nDSM(seq, x, struc_revs_man, customEphemerides, plotsol)

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

NmanLeg = struc_revs_man.NmanLeg;

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

if isfield(struc_revs_man, 'maxTofy')
    maxTofy = struc_revs_man.maxTofy;
    if isempty(maxTofy)
        maxTofy = 0;
    end
else
    maxTofy = 0;
end

try
    [DV, dv, MAT, output] = mga_nDSM_customEph(seq, t0, tofs, dv1, dvs, eps, eta, rps, struc_revs_man, customEphemerides, plotsol);
    % DV
%     if max(dv(end)) < 2
% %         DV = dv(1) + dv(end);
%         DV = 1e3;
%     end

    % if maxTofy > 0
    % 
    %     if sum(tofs)/365.25 > maxTofy
    %         DV = 1e3;
    %     end
    % 
    % end

    % % indxs = find(dv(2:end-1)>3);
    % % if isempty(indxs)
    % % else
    % %     DV = 20;
    % % end

    % if dv(1) < struc_revs_man.vinfMax
    %     DV = sum(dv(2:end));
    % end

%     if dv(1) < struc_revs_man.vinfMax
%         DV = sum(dv(2:end));
%         if max(dv(2:end-1)) < struc_revs_man.dvsMaxMag
%             DV = dv(end);
%             disp( 'yes' );
%         end
%     end

%     if dv(1) < struc_revs_man.vinfMax && dv(end) < struc_revs_man.vinfMaxArr
%         DV = sum(dv(2:end-1));
% %         if max(dv(2:end-1)) < struc_revs_man.dvsMaxMag
% %             DV = dv(end);
% %             disp( 'yes' );
% %         end
%     end

%     if max(dv(2:end-1)) < struc_revs_man.dvsMaxMag
%         DV = dv(1) + dv(end);
%         disp( 'yes' );
%     end

%     if max(dv(2:end-1)) < struc_revs_man.dvsMaxMag
%         DV = dv(1) + dv(end);
%         disp( 'yes' );
%     end

%     [ dv_end ] = deltaV_hyperbola( dv(end), 500e3, 1e6, 398600.446192176 );
%     dv(end)    = dv_end;
%     DV         = sum(dv);

%     DV = dv(end);

%     if dv(2) > 4
%         DV = 1e99;
%     else
%         DV = dv(end);
%     end
%     DV = sum(dv(2:end));

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
