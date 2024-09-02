function [Xsyn, L_ref, V_ref] = eci2synodic_eph(Xeci, svbody, mu1, mu2)

% DESCRIPTION
% This function converts state vectors from the ECI (Earth-Centered Inertial) 
% reference frame to the Synodic reference frame, given the state vector of 
% a secondary body (e.g., Moon), and the gravitational parameters of both 
% primary and secondary bodies.
% 
% INPUT
% - Xeci  : State vector in the ECI reference frame [position; velocity].
% - svbody: State vector of the secondary body at a particular epoch [position; velocity].
% - mu1   : Gravitational parameter of the primary body (e.g., Earth).
% - mu2   : Gravitational parameter of the secondary body (e.g., Moon).
% 
% OUTPUT
% - Xsyn  : State vector in the Synodic reference frame [position; velocity].
% - L_ref : Distance from the primary body to the secondary body.
% - V_ref : Velocity of the secondary body relative to the primary body.
% 
% -------------------------------------------------------------------------

% --> Converts Cartesian Inertial to Synodic RF
mu     = mu2/(mu1 + mu2);
Xeci   = Xeci(:);
svbody = svbody(:);
L_ref  = norm(svbody(1:3));
V_ref  = sqrt((mu1 + mu2)/L_ref);

x_syn = svbody(1:3)/L_ref;
h     = cross(svbody(1:3),svbody(4:6));
z_syn = h/norm(h);
y_syn = cross(z_syn, x_syn);
A_t   = [x_syn, y_syn, z_syn];

% --> Spacecraft
r = A_t'*Xeci(1:3);
v = A_t'*Xeci(4:6);
n = norm(h)/L_ref^2;             % --> Instantaneous angular velocity

% --> planet
r_moon     = A_t'*svbody(1:3);
v_moon     = A_t'*svbody(4:6);
v_moon_rot = v_moon - cross([0 0 n],r_moon)';

r_syn = (r/L_ref - [mu 0 0]');
v_syn = (v - cross([0 0 n],r)' - v_moon_rot)/V_ref;
Xsyn  = [r_syn; v_syn];

end

