function [dv1] = v02dv1(v0, xp1, vp1)

mod_v = v0(1);      % --> Modulus of initial velocity relative to the departure planet
psi   = v0(2)-pi/2; % --> In-plane rotation
theta = v0(3);      % --> Out-of-plane rotation
% Transposed Euler angles matrix in the special case phi=0.
R_T=[cos(psi), -cos(theta)*sin(psi),  sin(theta)*sin(psi);...
     sin(psi),  cos(theta)*cos(psi), -sin(theta)*cos(psi);...
        0    ,       sin(theta)    ,       cos(theta)    ];
v_rel_tnh = R_T*[0;mod_v;0]; % Relative velocity in the tangent-normal-binormal (h) reference frame
dv1       = tnh2car(v_rel_tnh, [xp1, vp1] )'; % --> this is the initial DV

end