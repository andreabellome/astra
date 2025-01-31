function INPUT = writeInputASTRA(seq, res, inputParam)

INPUT.idcentral = inputParam.idcentral;

%%%%%%%%%% set departing options %%%%%%%%%%
INPUT.depOpts = [inputParam.depOpts(1) inputParam.depOpts(2) inputParam.depOpts(3)];
%%%%%%%%%% set departing options %%%%%%%%%%

%%%%%%%%%% set options %%%%%%%%%%
INPUT.opt      = inputParam.opt;          % --> (1) is for SODP, (2) is for MODP, (3) is for DATES
INPUT.vInfOpts = inputParam.vInfOpts;      % --> min/max departing infinity velocities (km/s)
INPUT.dsmOpts  = inputParam.dsmOpts;    % --> max defect DSM, and total DSMs (km/s)
INPUT.plot     = inputParam.plot;      % --> plot(1) for Pareto front, plot(2) for best traj. DV
INPUT.parallel = inputParam.parallel;      % --> put true for parallel, false otherwise
INPUT.tstep    = inputParam.tstep;
%%%%%%%%%% set options %%%%%%%%%%

%%%%%%%%%% multi-rev. options %%%%%%%%%%
chosenRevs                    = differentRuns_v2(seq, inputParam.maxrev);             % --> generate successive runs
[INPUT.chosenRevs, INPUT.res] = processResonances(chosenRevs, res);        % --> process the resonances options
[INPUT.chosenRevs]            = maxRevOuterPlanets(seq, INPUT.chosenRevs); % --> only zero revs. on outer planets
%%%%%%%%%% multi-rev. options %%%%%%%%%%

%%%%%%%%%% set additional constraints and cost functions %%%%%%%%%%
vInfMin            = zeros( length(seq), 1 );
vInfMax            = 1e99.*ones( length(seq), 1 );
vInfMax(end)       = inputParam.vInfMaxEnd;
INPUT.vInfLim      = [ vInfMin vInfMax ];
INPUT.TOF_LIM      = inputParam.TOF_LIM;

% INPUT.forward        = inputParam.forward;
% INPUT.tofyMax        = inputParam.tofyMax;   % --> (years) maximum TOF
% INPUT.costFunc1      = inputParam.costFunc1;
% INPUT.costFunc2      = inputParam.costFunc2;
% INPUT.costFunc1_MODP = inputParam.costFunc1_MODP;
% INPUT.costFunc2_MODP = inputParam.costFunc2_MODP;
%%%%%%%%%% set additional constraints and cost functions %%%%%%%%%%

if ~isfield(inputParam, 'customEphemerides')
    INPUT.customEphemerides = @EphSS_cartesian;
else
    INPUT.customEphemerides = inputParam.customEphemerides;
end

end
