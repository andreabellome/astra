function [vinflim, TOF_LIM, tstep, tofyMax, ...
    costFunc1, costFunc2, costFunc1_BS, costFunc2_BS, ...
    costFunc1_MODP, costFunc2_MODP] = check_INPUT(INPUT)

% DESCRIPTION:
% This function checks and extracts various input parameters from the input structure `INPUT`
% to be used in trajectory optimization calculations. The function ensures that default values 
% or functions are assigned if specific fields are not present or empty in the input structure.
%
% INPUT:
% INPUT : structure containing the following fields:
%    - vInfLim        : (Optional) Vector defining the range of departure infinity velocities (km/s).
%                       If not provided, defaults to an empty array.
%    - TOF_LIM        : (Optional) Vector defining the range of times of flight (days).
%                       If not provided, defaults to an empty array.
%    - tstep          : (Optional) Scalar specifying the discretization time step (days).
%                       If not provided, defaults to 2 days.
%    - tofyMax        : (Optional) Scalar defining the maximum time of flight (days).
%                       If not provided, defaults to an empty array.
%    - costFunc1      : (Optional) Function handle for the first cost function in single-objective optimization.
%                       If not provided, defaults to `costFunction1_DP`.
%    - costFunc2      : (Optional) Function handle for the second cost function in single-objective optimization.
%                       If not provided, defaults to `costFunction2_DP`.
%    - costFunc1_BS   : (Optional) Function handle for the first cost function with a specific approach.
%                       If not provided, defaults to `costFunction1_BS`.
%    - costFunc2_BS   : (Optional) Function handle for the second cost function with a specific approach.
%                       If not provided, defaults to `costFunction2_BS`.
%    - costFunc1_MODP : (Optional) Function handle for the first cost function in multi-objective optimization.
%                       If not provided, defaults to `costFunction1_MODP`.
%    - costFunc2_MODP : (Optional) Function handle for the second cost function in multi-objective optimization.
%                       If not provided, defaults to `costFunction2_MODP`.
% 
% OUTPUT:
% vinflim           : Extracted or default value for the vInfLim field.
% TOF_LIM           : Extracted or default value for the TOF_LIM field.
% tstep             : Extracted or default value for the tstep field.
% tofyMax           : Extracted or default value for the tofyMax field.
% costFunc1         : Extracted or default function handle for costFunc1.
% costFunc2         : Extracted or default function handle for costFunc2.
% costFunc1_BS      : Extracted or default function handle for costFunc1_BS.
% costFunc2_BS      : Extracted or default function handle for costFunc2_BS.
% costFunc1_MODP    : Extracted or default function handle for costFunc1_MODP.
% costFunc2_MODP    : Extracted or default function handle for costFunc2_MODP.
%
% -------------------------------------------------------------------------

% --> extract the vinfinity ranges (km/s)
if isfield(INPUT, 'vInfLim')
    if isempty(INPUT.vInfLim)
        vinflim = [];
    else
        vinflim = INPUT.vInfLim;
    end
else
    vinflim = [];
end

% --> extract the tofs ranges (days)
if isfield(INPUT, 'TOF_LIM')
    if isempty(INPUT.TOF_LIM)
        TOF_LIM = [];
    else
        TOF_LIM = INPUT.TOF_LIM;
    end
else
    TOF_LIM = [];
end

% --> extract step size (days)
if isfield(INPUT, 'tstep')
    if isempty(INPUT.tstep)
        tstep = 2;
    else
        tstep = INPUT.tstep;
    end
else
    tstep = 2;
end

% --> extract maximum TOFy
if isfield(INPUT, 'tofyMax')
    if isempty(INPUT.tofyMax)
        tofyMax = [];
    else
        tofyMax = INPUT.tofyMax;
    end
else
    tofyMax = [];
end

% --> extract cost function (1) - SINGLE OBJECTIVE optimization
if isfield(INPUT, 'costFunc1')
    if isempty(INPUT.costFunc1)
        costFunc1 = @(legn, vvf, vinff) costFunction1_DP(legn, vvf, vinff);
    else
        costFunc1 = INPUT.costFunc1;
    end
else
    costFunc1 = @(legn, vvf, vinff) costFunction1_DP(legn, vvf, vinff);
end

% --> extract cost function (2) - SINGLE OBJECTIVE optimization
if isfield(INPUT, 'costFunc2')
    if isempty(INPUT.costFunc2)
        costFunc2 = @(legn, vvf, vinff) costFunction2_DP(legn, vvf, vinff);
    else
        costFunc2 = INPUT.costFunc2;
    end
else
    costFunc2 = @(legn, vvf, vinff) costFunction2_DP(legn, vvf, vinff);
end


% --> extract cost function (1) - MULTI OBJECTIVE optimization
if isfield(INPUT, 'costFunc1_MODP')
    if isempty(INPUT.costFunc1_MODP)
        costFunc1_MODP = @(legn, vvf, vinff) costFunction1_MODP(legn, vvf, vinff);
    else
        costFunc1_MODP = INPUT.costFunc1_MODP;
    end
else
    costFunc1_MODP = @(legn, vvf, vinff) costFunction1_MODP(legn, vvf, vinff);
end

% --> extract cost function (2) - MULTI OBJECTIVE optimization
if isfield(INPUT, 'costFunc2_MODP')
    if isempty(INPUT.costFunc2_MODP)
        costFunc2_MODP = @(legn, vvf, vinff) costFunction2_MODP(legn, vvf, vinff);
    else
        costFunc2_MODP = INPUT.costFunc2_MODP;
    end
else
    costFunc2_MODP = @(legn, vvf, vinff) costFunction2_MODP(legn, vvf, vinff);
end

% --> extract cost function (1)
if isfield(INPUT, 'costFunc1_BS')
    if isempty(INPUT.costFunc1_BS)
        costFunc1_BS = @(legn, vvf, vinff) costFunction1_BS(legn, vvf, vinff);
    else
        costFunc1_BS = INPUT.costFunction1_BS;
    end
else
    costFunc1_BS = @(legn, vvf, vinff) costFunction1_BS(legn, vvf, vinff);
end

% --> extract cost function (1)
if isfield(INPUT, 'costFunc2_BS')
    if isempty(INPUT.costFunc1_BS)
        costFunc2_BS = @(legn, vvf, vinff) costFunction2_BS(legn, vvf, vinff);
    else
        costFunc2_BS = INPUT.costFunction2_BS;
    end
else
    costFunc2_BS = @(legn, vvf, vinff) costFunction2_BS(legn, vvf, vinff);
end

end