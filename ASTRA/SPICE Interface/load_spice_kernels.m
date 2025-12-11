function out = load_spice_kernels( path_to_data_metakernel )

% DESCRIPTION:
%   This function clears any previously loaded SPICE kernels and loads a
%   user-specified meta-kernel. It is primarily intended for use inside 
%   parallel workers, where each worker needs to load SPICE kernels 
%   independently. The function returns a boolean flag indicating whether 
%   the kernel loading operation was successful.
%
% INPUT:
%   - path_to_data_metakernel : full path to a SPICE meta-kernel (.tm or .mk)
%                               that lists all kernels to be loaded.
%
% OUTPUT:
%   - out : logical flag:
%               true  → kernels loaded successfully
%               false → an error occurred while loading kernels
%
% -------------------------------------------------------------------------

try
    cspice_kclear;
    cspice_furnsh(path_to_data_metakernel);
    out = true;
catch
    out = false;
end

if ~out
    warning('Something went wrong in loading SPICE kernels. Retry.');
end

end