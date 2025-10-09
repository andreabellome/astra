function dv_tcn = dv_to_TCN(r, v, vec)

% DESCRIPTION
% This function rotates a vector from an inertial reference frame
% to the local orbital frame defined as Tangential–Cross-track–Radial-like
% (TCN). The transformation is based on the instantaneous position and
% velocity vectors of the spacecraft.
%
% INPUT
% - r   : position vector [3x1] or [1x3] in the inertial reference frame [km]
% - v   : velocity vector [3x1] or [1x3] in the inertial reference frame [km/s]
% - vec : vector [3x1] or [1x3] to rotate in the inertial reference frame
%
% OUTPUT
% - dv_tcn : delta-v components in the TCN frame [1x3] = [dv_T, dv_C, dv_N],
%            where:
%            dv_T = component along the tangential direction (velocity)
%            dv_C = component along the cross-track direction (orbital angular momentum)
%            dv_N = component along the radial-like direction (toward position vector)
%
% -------------------------------------------------------------------------

% Ensure column vectors
r = r(:);
v = v(:);
dv = vec(:);

% Norms
r_norm = norm(r);
v_norm = norm(v);

if r_norm < 1e-12
    error('Position vector norm too small.');
end
if v_norm < 1e-12
    error('Velocity vector norm too small.');
end

% Tangential direction (T)
T = v / v_norm;

% Cross-track direction (C) = normalized angular momentum vector
h = cross(r, v);
h_norm = norm(h);
if h_norm < 1e-12
    error('Angular momentum (r × v) too small - orbit may be degenerate.');
end
C = h / h_norm;

% Radial-like direction (N) = C × T
N = cross(C, T);
N = N / norm(N);
% Ensure N points roughly along the position vector
if dot(N, r / r_norm) < 0
    N = -N;
end

% Rotation matrix from inertial to TCN
R_inertial_to_TCN = [T'; C'; N'];

% Convert delta-v
dv_tcn = R_inertial_to_TCN * dv;

% Return as row vector for readability
dv_tcn = dv_tcn(:).';

end