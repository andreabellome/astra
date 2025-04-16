function [STM, rr1, vv1, R, V, Rdash, Vdash] = STM_analytic(rr0, vv0, dt, mu)

% --> compute analytic STM for elliptical keplerian orbits

r0 = norm(rr0);
v0 = norm(vv0);

a      = mu/(2*mu/r0 - v0^2);
DM     = sqrt(mu/a^3)*dt; % mean anomaly difference
sigma0 = dot(rr0,vv0)/sqrt(mu);

% evalaute the DE
func = @(DE) DM - (DE - (1 - r0/a)*sin(DE) - sigma0/sqrt(a)*(cos(DE) - 1));
x0   = DM;
DE   = fzero(func,x0);

% evaluate the Lagrange coefficients
F = 1 - a/r0*(1 - cos(DE));
G = dt + sqrt(a^3/mu)*(sin(DE) - DE);

rr1 = F.*rr0 + G.*vv0;
rf  = norm(rr1);

Fdot = -sqrt(mu*a)/(rf*r0)*sin(DE);
Gdot = 1 - (a/rf)*(1 - cos(DE));

vv1 = Fdot.*rr0 + Gdot.*vv0;

C = a*sqrt(a^3/mu)*(3*sin(DE) - (2 + cos(DE))*DE) - a*dt*(1 - cos(DE));

drr = rr1 - rr0;
dvv = vv1 - vv0;

R     = r0/mu*(1 - F)*(drr'*vv0 - dvv'*rr0) + C/mu*vv1'*vv0 + G*eye(3);
V     = r0/mu*(dvv'*dvv) + 1/(rf^3)*(r0*(1 - F)*rr1'*rr0 - C*rr1'*vv0) + Gdot*eye(3);
Rdash = rf/mu*(dvv'*dvv) + 1/(r0^3)*(r0*(1 - F)*rr1'*rr0 - C*vv1'*rr0) + F*eye(3);
Vdash = -1/(r0^2)*dvv'*rr0 - 1/(rf^2)*rr1'*dvv + ...
    Fdot*(eye(3) - 1/(rf^2)*(rr1'*rr1) + 1/(mu*rf)*(rr1'*vv1 - vv1'*rr1)*(rr1'*dvv)) - mu*C/(rf^3*r0^3)*(rr1'*rr0);

STM = [Rdash R; Vdash V];

end