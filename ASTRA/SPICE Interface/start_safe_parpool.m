function pool = start_safe_parpool(nWorkers)

% DESCRIPTION:
% Start a parpool safely with physical or logical cores.
% 
% If requested number of workers is greater than the physical ones, then
% the logical ones are used. If requested number of workers is also greater
% than the logical ones, then an error is thrown.
% 
% INPUT:
% - nWorkers : number of workers (by default the physical ones)
%
% OUTPUT:
% - pool : MATLAB parpool structure
%
% -------------------------------------------------------------------------

    % Detect cores
    nPhysical = feature('numcores');
    nLogical  = java.lang.Runtime.getRuntime().availableProcessors;

    % Obtain current cluster profile
    c = parcluster('local');
    profileLimit = c.NumWorkers;

    % If user did not specify a number, use physical cores
    if nargin < 1 || isempty(nWorkers)
        nWorkers = nPhysical;
    end

    % Case 1: Within physical cores (nominal → OK)
    if nWorkers <= nPhysical
        request = nWorkers;

    % Case 2: Above physical but within logical
    elseif nWorkers <= nLogical
        warning(['Requested workers (%d) exceed physical cores (%d).\n' ...
                 'Using logical cores instead (hyper-threaded).'], ...
                 nWorkers, nPhysical);
        request = nWorkers;

    % Case 3: Above logical → clamp to logical
    else
        warning(['Requested workers (%d) exceed logical cores (%d).\n' ...
                 'Clamping to logical core count.'], ...
                 nWorkers, nLogical);
        request = nLogical;
    end

    % Check cluster profile limit
    if request > profileLimit
        warning(['Requested %d workers, but the local profile only allows %d.\n' ...
                 'To increase: c = parcluster(''local''); c.NumWorkers = X; saveProfile(c);'], ...
                 request, profileLimit);
        request = profileLimit;
    end

    % Close any existing pool
    currentPool = gcp('nocreate');
    if ~isempty(currentPool)
        if currentPool.NumWorkers == request
            pool = currentPool;
            return;
        else
            delete(currentPool);
        end
    end

    % Start the new parpool
    pool = parpool(request);

end
