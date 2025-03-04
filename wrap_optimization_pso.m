function [minsol, sol, fval] = wrap_optimization_pso( costFun, lb, ub, maxit )

if nargin == 3
    maxit = 1;
end

% --> optimize
optionsPSO = optPSO(lb, ub);
sol        = zeros(maxit, length(lb));
fval       = zeros(maxit, 1);
for ind = 1:maxit
    [sol(ind,:), fval(ind,:)] = particleswarm(costFun, length(lb), lb, ub, optionsPSO);
end

[~, row] = min(fval);
minsol   = sol(row,:);

end
