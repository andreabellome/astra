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
chosenRevs                    = differentRuns_v2(seq, inputParam.maxrev);  % --> generate successive runs
[INPUT.chosenRevs, INPUT.res] = processResonances(chosenRevs, res);        % --> process the resonances options
[INPUT.chosenRevs]            = maxRevOuterPlanets(seq, INPUT.chosenRevs); % --> only zero revs. on outer planets
%%%%%%%%%% multi-rev. options %%%%%%%%%%

%%%%%%%%%% set additional constraints and cost functions %%%%%%%%%%
vInfMin            = zeros( length(seq), 1 );
vInfMax            = 1e99.*ones( length(seq), 1 );
vInfMax(end)       = inputParam.vInfMaxEnd;
INPUT.vInfLim      = [ vInfMin vInfMax ];

if isfield(inputParam, 'TOF_LIM')
    if ~isempty(inputParam.TOF_LIM)
        INPUT.TOF_LIM = inputParam.TOF_LIM;
    end
end

INPUT.tofyMax        = inputParam.tofyMax;   % --> (years) maximum TOF
INPUT.costFunc1      = inputParam.costFunc1;
INPUT.costFunc2      = inputParam.costFunc2;
INPUT.costFunc1_MODP = inputParam.costFunc1_MODP;
INPUT.costFunc2_MODP = inputParam.costFunc2_MODP;
%%%%%%%%%% set additional constraints and cost functions %%%%%%%%%%

%%%%%%%%%% NASA SPICE toolkit %%%%%%%%%%
if max(seq) > 9 && INPUT.idcentral == 1
    % --> load custom ephemerides
    MICE_path = './MICE_TOOLBOX';
    addpath(genpath(MICE_path)); % --> always include this
    cspice_furnsh([MICE_path '/data.mk']);
    
    if isfield(inputParam, 'spk_dir')
        spk_dir = inputParam.spk_dir;           % --> location of the bsp file with object ephemerides
    else
        spk_dir = [];
    end

    for inds = 1:length(seq)
        if seq(inds) > 9
            cspice_furnsh([ pwd '\' spk_dir '\' num2str(seq(inds)) '.bsp']); % --> load the object ephemerides
        end
    end

end
%%%%%%%%%% NASA SPICE toolkit %%%%%%%%%%

%%%%%%%%%% custom ephemerides %%%%%%%%%%
if isfield(inputParam, 'customEphemerides')
    INPUT.customEphemerides = inputParam.customEphemerides;
else
    INPUT.customEphemerides = @EphSS_cartesian;
end
%%%%%%%%%% custom ephemerides %%%%%%%%%%

end
