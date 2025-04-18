function [sv_true] = true_diff( yy, yy1 )

% --> compute true RSW relative motion
sv_true = zeros(size(yy,1), 6);
for i = 1:size(yy,1)

    r_chief = yy(i,1:3)';
    v_chief = yy(i,4:6)';

    r_dep   = yy1(i,1:3)';
    v_dep   = yy1(i,4:6)';

    % RSW frame at time i
    R_hat = r_chief / norm(r_chief);
    W_hat = cross(r_chief, v_chief); W_hat = W_hat / norm(W_hat);
    S_hat = cross(W_hat, R_hat);
    T = [R_hat'; S_hat'; W_hat'];

    % Relative vectors in ECI
    dr_eci = r_dep - r_chief;
    dv_eci = v_dep - v_chief;

    % Project into RSW
    dr_rsw_t = T * dr_eci;
    dv_rsw_t = T * dv_eci;

    sv_true(i,1:3) = dr_rsw_t';
    sv_true(i,4:6) = dv_rsw_t';
end

end