
clear all; close all; clc; format long g;

% --> variables
syms p f g h k L m
syms lambda_rx lambda_ry lambda_rz lambda_vx lambda_vy lambda_vz lambda_m
syms u1 u2 u3 sigma

% --> constants
syms mu Tmax_1AU_N thrust_max_N c epsilon n_engines scaling_param_thrust a0 a1 a2 b1 b2

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


radius        = p / q;
% Tmax          = (-epsilon.*log( exp( -(Tmax_1AU_N ./ radius.^2)./epsilon ) + exp( -(n_engines * thrust_max_N)./epsilon ))) * scaling_param_thrust;


factor = (a0 + a1 ./ radius + a2 ./ radius.^2)./( 1 + b1.*radius + b2.*radius.^2 );

func_1 = Tmax_1AU_N ./ radius.^2 .* factor;
func_2 = n_engines * thrust_max_N;
Tmax   = -epsilon.*log( exp( -(func_1)./epsilon ) + exp( -(func_2)./epsilon )) * scaling_param_thrust .* 0.99 .*0.95 ;


xx         = [p; f; g; h; k; L];
lambda_mee = [lambda_rx; lambda_ry; lambda_rz; lambda_vx; lambda_vy; lambda_vz];

H = Tmax * sigma / c + lambda_mee.'*(A + Tmax * sigma / m*B*[u1; u2; u3]) - lambda_m * Tmax * sigma / c;

dH_dx = jacobian(H, xx);
dH_dm = diff(H, m);
