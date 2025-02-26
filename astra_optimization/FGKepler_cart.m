function [rrf, vvf, kep2] = FGKepler_cart(rr1, vv1, dt, mu)

kep1 = car2kep([rr1, vv1], mu);

if kep1(2) < 1
    n    = sqrt(mu/kep1(1)^3);
elseif kep1(2) > 1
    n = sqrt(mu/(-kep1(1)^3));
end
M1   = theta2M(kep1(6), kep1(2));
M2   = M1 + n*dt;
th2  = M2theta(M2,kep1(2));

kep2 = [kep1(1) kep1(2) kep1(3) kep1(4) kep1(5) th2];
car2 = kep2car(kep2,mu);

rrf = car2(1:3);
vvf = car2(4:6);

end