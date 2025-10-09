function [STM, rr1, vv1, R, V, Rdash, Vdash] = compute_keplerian_STM(rr0, vv0, dt, mu, anNum)

% DESCRIPTION :
% this function computes the State Transition Matrix (STM) in keplerian
% dynamics (i.e. without orbital perturbations).
%
% INPUT :
% - anNum : if anNum = 1, then the STM is computed in ANALYTICAL way. If
%           not provided, ANALYTICAL way is chosen.
% - rr0   : initial position vector
% - vv0   : initial velocity vector
% - dt    : transfer time
% - mu    : gravitational parameter of the central body
%
% OUTPUT :
% - STM   : State Transition Matrix
% - rr1   : final position vector
% - vv1   : final position vector
% - R     : submatrix STM(1:3,4:6)
% - V     : submatrix STM(4:6,4:6)
% - Rdash : submatrix STM(1:3,1:3)
% - Vdash : submatrix STM(4:6,1:3)
% 
% -------------------------------------------------------------------------

if nargin < 5
    anNum = 1;
end

if anNum == 1
    % use ANALYTICAL computation for keplerian STM
    [STM, rr1, vv1, R, V, Rdash, Vdash] = STM_analytic_mex(rr0, vv0, dt, mu);
else
    % use NUMERICAL computation for keplerian STM
    PHI_0(1:6)  = [rr0 vv0];            % initial state
    PHI_0(7:42) = reshape(eye(6),36,1); % initial STM
    OPTIONS     = odeset('RelTol',3e-14,'AbsTol',1e-14);
    if dt == 0
        PHI = PHI_0;
        rr1 = rr0;
        vv1 = vv0;
    else
        [~,PHI]     = ode113(@(t, PHI) keplerianSTMdot(t, PHI, mu), [0 dt], PHI_0, OPTIONS);
        rr1         = PHI(end, 1:3);
        vv1         = PHI(end, 4:6);
    end
    STM         = reshape(PHI(end,7:42),6,6);
    R           = STM(1:3,4:6);
    V           = STM(4:6,4:6);
    Rdash       = STM(1:3,1:3);
    Vdash       = STM(4:6,1:3);
end

end
