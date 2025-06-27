function [optionsPSO, NVAR, MAXIT] = optPSO(lb, ub, useParallel)

if nargin == 2
    useParallel = false;
end

% set the options for the PSO
N       = 1200;         % number of particles
MAXIT   = 500;          % number of iterations
NVAR    = length(lb);   % number of optimization variables

optionsPSO                        = optimoptions('particleswarm','PlotFcn','pswplotbestf');
optionsPSO.FunctionTolerance      = 0;
optionsPSO.InitialSwarmSpan       = N*3;
optionsPSO.SwarmSize              = N*1.5;
optionsPSO.MaxIterations          = MAXIT;
optionsPSO.SocialAdjustmentWeight = 1.52;
optionsPSO.UseParallel            = useParallel;

end