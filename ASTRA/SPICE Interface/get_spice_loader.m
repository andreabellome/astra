function spice_loader = get_spice_loader(path_to_kernel, INPUT)

% DESCRIPTION:
%   This function prepares a SPICE kernel loader to be used in both serial
%   and parallel MATLAB workflows. First, kernels listed in the provided
%   meta-kernel are loaded in the client session. Then, a parallel.pool.Constant
%   is created to ensure that each parallel worker loads the SPICE kernels
%   exactly once. If requested, the function also starts a parallel pool with
%   a user-specified or default number of workers and forces each worker to
%   load the kernels.
%
% INPUT:
%   - path_to_kernel : full path to a SPICE meta-kernel (.tm or .mk) that
%                      defines the set of kernels to load.
%
%   - INPUT          : structure with those fields:
%
%           INPUT.parallel   : boolean flag to enable/disable parallel mode.
%
%           INPUT.numWorkers : number of workers to use. 
%                              If not provided, defaults to the number of
%                              physical CPU cores returned by feature('numcores').
%
% OUTPUT:
%   - spice_loader : a parallel.pool.Constant object. Its Value property,
%                    when accessed inside a parfor loop, ensures that the
%                    SPICE kernels are loaded on the corresponding worker.
%
% -------------------------------------------------------------------------

% --> spice loader
load_spice_kernels(path_to_kernel);
spice_loader = parallel.pool.Constant(@() load_spice_kernels(path_to_kernel));

% --> check parallel pool
if isfield(INPUT, 'numWorkers')
    numWorkers = INPUT.numWorkers;
else
    numWorkers = feature('numcores');
end
if INPUT.parallel == true
    if isempty(gcp('nocreate'))
        start_safe_parpool(numWorkers);        
    end
end

% --> load the SPICE kernels on all the cores
parfor ii = 1:numWorkers
    spice_loader.Value;
end

end