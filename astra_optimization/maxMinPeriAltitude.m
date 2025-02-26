function [rpMin, rpMax] = maxMinPeriAltitude(path, rpperc)

PLTs_flyby = path(2:end-1,7);

rp   = path(2:end-1,14)'; % rp (adim.)

rpMin_adim = zeros(1, length(PLTs_flyby));
for indi = 1:length(PLTs_flyby)
   [~, radius]      = planetConstants(PLTs_flyby(indi));
   hmin             = maxmin_flybyAltitude(PLTs_flyby(indi));
   rpMin_adim(indi) = (hmin + radius)/radius; 
end

rpMin      = rp*(1 - rpperc);
rpMax      = rp*(1 + rpperc);

indxs        = find(rpMin < rpMin_adim);
rpMin(indxs) = rpMin_adim(indxs);

end