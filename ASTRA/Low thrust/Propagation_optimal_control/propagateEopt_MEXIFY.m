function [dx, thrust, m] = propagateEopt_MEXIFY( t, xvalues, pp )

% DESCRIPTION:
% This function propagates the spacecraft dynamics in two-body problem and
% applies the energy-optimal (time-fixed) control.
%
% INPUT:
% - t       : time [LU]
% - xvalues : 7x1 vector with MEE and mass (adimensional variables)
% - pp      : 4x1 vector with:
%               - pp(1) : mu [LU3/TU2] -- gravitational parameter of the
%               central body
%               - pp(2) : TmaxScl [adim] -- max. thrust
%               - pp(3) : IspScl [TU] -- specific impulse
%               - pp(4) : g0Scl [LU/TU2] -- Earth's gravitational
%               acceleration at sea level
%
% OUTPUT:
% - dx     : accelerations of the state vector (i.e., xvalues)
% - thrust : 3x1 thrust vector (adim.)
% - m      : mass (adim.)
% 
% -------------------------------------------------------------------------

mu      = pp(1);
TmaxScl = pp(2);
IspScl  = pp(3);
g0Scl   = pp(4);

p           = xvalues(1);
f           = xvalues(2);
g           = xvalues(3); 
h           = xvalues(4);
k           = xvalues(5);
L           = xvalues(6);
m           = xvalues(7);
lambda_rx   = xvalues(8);
lambda_ry   = xvalues(9);
lambda_rz   = xvalues(10);
lambda_vx   = xvalues(11);
lambda_vy   = xvalues(12);
lambda_vz   = xvalues(13);
lambda_m    = xvalues(14);

cosL        = cos(L);
sinL        = sin(L);
sqrt_p_mu   = sqrt(p/mu);
q           = 1+f*cosL+g*sinL; 
s2          = 1 + h^2 + k^2; 
A           = [ 0 0 0 0 0 sqrt(mu*p)*(q/p)^2]';

B = [0                      2*p/q*sqrt_p_mu                0;
    sqrt_p_mu*sinL  sqrt_p_mu/q*((q+1)*cosL+f) -sqrt_p_mu*g/q*(h*sinL-k*cosL);
    -sqrt_p_mu*cosL sqrt_p_mu*1/q*((q+1)*sinL+g) sqrt_p_mu*f/q*(h*sinL-k*cosL);
    0                      0                                   sqrt_p_mu*s2*cosL/(2*q);
    0                      0                                   sqrt_p_mu*s2*sinL/(2*q);
    0                      0                                   sqrt_p_mu*(h*sinL-k*cosL)/q];


% --> start: fuel-optimal control
% sigmaStar   = (g0Scl*IspScl/m) * norm(B'*xvalues(8:13)) + lambda_m;
% sigmaStar   = norm(B'*xvalues(8:13)) + lambda_m*m/(g0Scl*IspScl); % --> this should be the correct one...
sigmaStar   = norm(B'*xvalues(8:13)) + lambda_m;


if sum(xvalues(8:13)) ~= 0
    uStar = -B'*xvalues(8:13)/(norm(B'*xvalues(8:13)));
else
    uStar = [0;0;0];
end

uuStar = sigmaStar.*uStar;
u1     = uStar(1);
u2     = uStar(2);
u3     = uStar(3);

thrust = TmaxScl*uuStar;
% --> end: fuel-optimal control

% --> dynamics
dx          = zeros( 14,1 );
dx(1:6,1)   = A + (TmaxScl/m)*B*uuStar;                                             % --> states
dx(7,1)     = -TmaxScl/( g0Scl*IspScl )*sigmaStar;    % --> mass

% --> costates
dx(8,1)     = conj(lambda_vz)*((2*conj((mu*p)^(1/2))*(cos(conj(L))*conj(f) + sin(conj(L))*conj(g) + 1)^2)/conj(p)^3 - (conj(mu)*(cos(conj(L))*conj(f) + sin(conj(L))*conj(g) + 1)^2)/(2*conj(p)^2*conj((mu*p)^(1/2))) + (TmaxScl*sigmaStar*u3*(k*cos(L) - h*sin(L)))/(2*m*mu*(p/mu)^(1/2)*(f*cos(L) + g*sin(L) + 1))) - sigmaStar*conj(lambda_ry)*((TmaxScl*u1*sin(L))/(2*m*mu*(p/mu)^(1/2)) + (TmaxScl*u2*(f + cos(L)*(f*cos(L) + g*sin(L) + 2)))/(2*m*mu*(p/mu)^(1/2)*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*g*u3*(k*cos(L) - h*sin(L)))/(2*m*mu*(p/mu)^(1/2)*(f*cos(L) + g*sin(L) + 1))) + sigmaStar*conj(lambda_rz)*((TmaxScl*u1*cos(L))/(2*m*mu*(p/mu)^(1/2)) - (TmaxScl*u2*(g + sin(L)*(f*cos(L) + g*sin(L) + 2)))/(2*m*mu*(p/mu)^(1/2)*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*f*u3*(k*cos(L) - h*sin(L)))/(2*m*mu*(p/mu)^(1/2)*(f*cos(L) + g*sin(L) + 1))) - (2*TmaxScl*sigmaStar*u2*conj(lambda_rx)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) - (TmaxScl*p*sigmaStar*u2*conj(lambda_rx))/(m*mu*(p/mu)^(1/2)*(f*cos(L) + g*sin(L) + 1)) - (TmaxScl*sigmaStar*u3*cos(L)*conj(lambda_vx)*(h^2 + k^2 + 1))/(2*m*mu*(p/mu)^(1/2)*(2*f*cos(L) + 2*g*sin(L) + 2)) - (TmaxScl*sigmaStar*u3*sin(L)*conj(lambda_vy)*(h^2 + k^2 + 1))/(2*m*mu*(p/mu)^(1/2)*(2*f*cos(L) + 2*g*sin(L) + 2));
dx(9,1)     = sigmaStar*conj(lambda_ry)*((TmaxScl*u2*cos(L)*(f + cos(L)*(f*cos(L) + g*sin(L) + 2))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2) - (TmaxScl*u2*(cos(L)^2 + 1)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*g*u3*cos(L)*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2)) - conj(lambda_vz)*((2*cos(conj(L))*conj((mu*p)^(1/2))*(cos(conj(L))*conj(f) + sin(conj(L))*conj(g) + 1))/conj(p)^2 + (TmaxScl*sigmaStar*u3*cos(L)*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2)) + sigmaStar*conj(lambda_rz)*((TmaxScl*u3*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) - (TmaxScl*u2*cos(L)*sin(L)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*u2*cos(L)*(g + sin(L)*(f*cos(L) + g*sin(L) + 2))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2) - (TmaxScl*f*u3*cos(L)*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2)) + (2*TmaxScl*p*sigmaStar*u2*cos(L)*conj(lambda_rx)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2) + (2*TmaxScl*sigmaStar*u3*cos(L)^2*conj(lambda_vx)*(p/mu)^(1/2)*(h^2 + k^2 + 1))/(m*(2*f*cos(L) + 2*g*sin(L) + 2)^2) + (2*TmaxScl*sigmaStar*u3*cos(L)*sin(L)*conj(lambda_vy)*(p/mu)^(1/2)*(h^2 + k^2 + 1))/(m*(2*f*cos(L) + 2*g*sin(L) + 2)^2);
dx(10,1)    = (2*TmaxScl*p*sigmaStar*u2*sin(L)*conj(lambda_rx)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2) - sigmaStar*conj(lambda_rz)*((TmaxScl*u2*(sin(L)^2 + 1)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) - (TmaxScl*u2*sin(L)*(g + sin(L)*(f*cos(L) + g*sin(L) + 2))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2) + (TmaxScl*f*u3*sin(L)*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2)) - sigmaStar*conj(lambda_ry)*((TmaxScl*u3*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*u2*cos(L)*sin(L)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) - (TmaxScl*u2*sin(L)*(f + cos(L)*(f*cos(L) + g*sin(L) + 2))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2) - (TmaxScl*g*u3*sin(L)*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2)) - conj(lambda_vz)*((2*sin(conj(L))*conj((mu*p)^(1/2))*(cos(conj(L))*conj(f) + sin(conj(L))*conj(g) + 1))/conj(p)^2 + (TmaxScl*sigmaStar*u3*sin(L)*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2)) + (2*TmaxScl*sigmaStar*u3*sin(L)^2*conj(lambda_vy)*(p/mu)^(1/2)*(h^2 + k^2 + 1))/(m*(2*f*cos(L) + 2*g*sin(L) + 2)^2) + (2*TmaxScl*sigmaStar*u3*cos(L)*sin(L)*conj(lambda_vx)*(p/mu)^(1/2)*(h^2 + k^2 + 1))/(m*(2*f*cos(L) + 2*g*sin(L) + 2)^2);
dx(11,1)    = (TmaxScl*g*sigmaStar*u3*sin(L)*conj(lambda_ry)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) - (2*TmaxScl*h*sigmaStar*u3*cos(L)*conj(lambda_vx)*(p/mu)^(1/2))/(m*(2*f*cos(L) + 2*g*sin(L) + 2)) - (TmaxScl*f*sigmaStar*u3*sin(L)*conj(lambda_rz)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) - (TmaxScl*sigmaStar*u3*sin(L)*conj(lambda_vz)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) - (2*TmaxScl*h*sigmaStar*u3*sin(L)*conj(lambda_vy)*(p/mu)^(1/2))/(m*(2*f*cos(L) + 2*g*sin(L) + 2));
dx(12,1)    = (TmaxScl*sigmaStar*u3*cos(L)*conj(lambda_vz)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*f*sigmaStar*u3*cos(L)*conj(lambda_rz)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) - (TmaxScl*g*sigmaStar*u3*cos(L)*conj(lambda_ry)*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) - (2*TmaxScl*k*sigmaStar*u3*cos(L)*conj(lambda_vx)*(p/mu)^(1/2))/(m*(2*f*cos(L) + 2*g*sin(L) + 2)) - (2*TmaxScl*k*sigmaStar*u3*sin(L)*conj(lambda_vy)*(p/mu)^(1/2))/(m*(2*f*cos(L) + 2*g*sin(L) + 2));
dx(13,1)    = sigmaStar*conj(lambda_ry)*((TmaxScl*u2*(f + cos(L)*(f*cos(L) + g*sin(L) + 2))*(g*cos(L) - f*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2) - (TmaxScl*u2*(cos(L)*(g*cos(L) - f*sin(L)) - sin(L)*(f*cos(L) + g*sin(L) + 2))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) - (TmaxScl*u1*cos(L)*(p/mu)^(1/2))/m + (TmaxScl*g*u3*(h*cos(L) + k*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*g*u3*(g*cos(L) - f*sin(L))*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2)) - sigmaStar*conj(lambda_rz)*((TmaxScl*u1*sin(L)*(p/mu)^(1/2))/m + (TmaxScl*u2*(cos(L)*(f*cos(L) + g*sin(L) + 2) + sin(L)*(g*cos(L) - f*sin(L)))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) - (TmaxScl*u2*(g + sin(L)*(f*cos(L) + g*sin(L) + 2))*(g*cos(L) - f*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2) + (TmaxScl*f*u3*(h*cos(L) + k*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*f*u3*(g*cos(L) - f*sin(L))*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2)) - conj(lambda_vz)*((2*conj((mu*p)^(1/2))*(cos(conj(L))*conj(g) - sin(conj(L))*conj(f))*(cos(conj(L))*conj(f) + sin(conj(L))*conj(g) + 1))/conj(p)^2 + (TmaxScl*sigmaStar*u3*(h*cos(L) + k*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*sigmaStar*u3*(g*cos(L) - f*sin(L))*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2)) - (TmaxScl*sigmaStar*u3*cos(L)*conj(lambda_vy)*(p/mu)^(1/2)*(h^2 + k^2 + 1))/(m*(2*f*cos(L) + 2*g*sin(L) + 2)) + (TmaxScl*sigmaStar*u3*sin(L)*conj(lambda_vx)*(p/mu)^(1/2)*(h^2 + k^2 + 1))/(m*(2*f*cos(L) + 2*g*sin(L) + 2)) + (2*TmaxScl*p*sigmaStar*u2*conj(lambda_rx)*(g*cos(L) - f*sin(L))*(p/mu)^(1/2))/(m*(f*cos(L) + g*sin(L) + 1)^2) + (TmaxScl*sigmaStar*u3*cos(L)*conj(lambda_vx)*(2*g*cos(L) - 2*f*sin(L))*(p/mu)^(1/2)*(h^2 + k^2 + 1))/(m*(2*f*cos(L) + 2*g*sin(L) + 2)^2) + (TmaxScl*sigmaStar*u3*sin(L)*conj(lambda_vy)*(2*g*cos(L) - 2*f*sin(L))*(p/mu)^(1/2)*(h^2 + k^2 + 1))/(m*(2*f*cos(L) + 2*g*sin(L) + 2)^2);
dx(14,1)    = sigmaStar*conj(lambda_ry)*((TmaxScl*u1*sin(L)*(p/mu)^(1/2))/m^2 + (TmaxScl*u2*(f + cos(L)*(f*cos(L) + g*sin(L) + 2))*(p/mu)^(1/2))/(m^2*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*g*u3*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m^2*(f*cos(L) + g*sin(L) + 1))) - sigmaStar*conj(lambda_rz)*((TmaxScl*u1*cos(L)*(p/mu)^(1/2))/m^2 - (TmaxScl*u2*(g + sin(L)*(f*cos(L) + g*sin(L) + 2))*(p/mu)^(1/2))/(m^2*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*f*u3*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m^2*(f*cos(L) + g*sin(L) + 1))) - (TmaxScl*sigmaStar*u3*conj(lambda_vz)*(k*cos(L) - h*sin(L))*(p/mu)^(1/2))/(m^2*(f*cos(L) + g*sin(L) + 1)) + (2*TmaxScl*p*sigmaStar*u2*conj(lambda_rx)*(p/mu)^(1/2))/(m^2*(f*cos(L) + g*sin(L) + 1)) + (TmaxScl*sigmaStar*u3*cos(L)*conj(lambda_vx)*(p/mu)^(1/2)*(h^2 + k^2 + 1))/(m^2*(2*f*cos(L) + 2*g*sin(L) + 2)) + (TmaxScl*sigmaStar*u3*sin(L)*conj(lambda_vy)*(p/mu)^(1/2)*(h^2 + k^2 + 1))/(m^2*(2*f*cos(L) + 2*g*sin(L) + 2));

end