
%%

% --> load ASTRA
clearDeleteAdd;


% --> load MICE and kernels
MICE_path = './MICE_TOOLBOX' ;
addpath(genpath(MICE_path)); 
cspice_furnsh([MICE_path '/data.mk']);


t0    = [ 2030 1 1 12 0 0 ];
tf    = [ 2100 1 1 12 0 0 ];

objs    = 'NEOs';
spk_dir = ['Ephemerides_' objs '_' num2str(t0(1)) '_' num2str(tf(1)) ];


spk_id = 3071939;

success = getSPK(num2str(spk_id), num2str(t0), num2str(tf), spk_dir, 'overwrite', 'on');


pl1 = 3;
pl2 = spk_id;
seq = [ pl1 pl2 ];

bsp_ast = [ num2str(pl2) '.bsp' ];

cspice_furnsh([ pwd '\' spk_dir '\' bsp_ast]);

%%

% --> clear INPUT and define new ones
try clear INPUT; catch; end; clc;

%%%%%%%%%% set default options %%%%%%%%%%
inputParam.idcentral = 1;
res                  = [];
inputParam.maxrev    = 1;
%%%%%%%%%% set default options %%%%%%%%%%

%%%%%%%%%% set departing options %%%%%%%%%%
t0 = date2mjd2000([2034 1 1 12 0 0]); % --> initial date range (MJD2000)
tf = t0 + 1*365.25;                  % --> final date range (MJD2000)
dt = 2;                               % --> step size (days)
inputParam.depOpts = [t0 tf dt];
%%%%%%%%%% set departing options %%%%%%%%%%

%%%%%%%%%% set options %%%%%%%%%%
inputParam.opt      = 3;          % --> (1) is for SODP, (2) is for MODP, (3) is for DATES, (4) is for YEARS - MODP
inputParam.vInfOpts = [0 5];      % --> min/max departing infinity velocities (km/s)
inputParam.dsmOpts  = [1 Inf];    % --> max defect DSM, and total DSMs (km/s)
inputParam.plot     = [1 0];      % --> plot(1) for Pareto front, plot(2) for best traj. DV
inputParam.parallel = false;      % --> put true for parallel, false otherwise
inputParam.tstep    = dt;         % --> step size for Time of flight            
%%%%%%%%%% set options %%%%%%%%%%

%%%%%%%%%% additional input options %%%%%%%%%%
% --> specify custom bounds for TOFs and VINFs
inputParam.vInfMaxEnd        = Inf;                                % --> max. DV at asteroid
inputParam.TOF_LIM           = [[10 300]];                         % --> TOF limits
inputParam.vInfLim           = [ 0 Inf; 0 inputParam.vInfMaxEnd ]; % --> PL1, PL2, PL3, ...   
inputParam.customEphemerides = @EphSS_NEOs; % --> custom ephemerides
%%%%%%%%%% additional input options %%%%%%%%%%

% --> perform the search for all the asteroids
files     = dir(fullfile(spk_dir, '*.bsp')); % Get all .bsp files
bsp_files = {files.name}; % Extract file names into a cell array

%%

% --> write the input
INPUT = writeInputASTRA(seq, res, inputParam);

% --> launch ASTRA optimization
OUTPUT = ASTRA_DP(seq, INPUT);

processed_OUTPUT    = postProcessOutputASTRA( OUTPUT );
SOLUTIONS_to_go(1).OUTPUT = processed_OUTPUT;

%% --> ASTRA ROUTINE FOR ALL THE ASTEROIDS -- TO RETURN

% --> clear INPUT and define new ones
try clear INPUT; catch; end; clc;

%%%%%%%%%% set default options %%%%%%%%%%
inputParam.idcentral = 1;
res                  = [];
inputParam.maxrev    = 1;
%%%%%%%%%% set default options %%%%%%%%%%

%%%%%%%%%% set departing options %%%%%%%%%%
t0 = date2mjd2000([2034 1 1 12 0 0]); % --> initial date range (MJD2000)
tf = t0 + 5*365.25;                  % --> final date range (MJD2000)
dt = 2;                               % --> step size (days)
inputParam.depOpts = [t0 tf dt];
%%%%%%%%%% set departing options %%%%%%%%%%

%%%%%%%%%% set options %%%%%%%%%%
inputParam.opt      = 3;          % --> (1) is for SODP, (2) is for MODP, (3) is for DATES, (4) is for YEARS - MODP
inputParam.vInfOpts = [0 5];      % --> min/max departing infinity velocities (km/s)
inputParam.dsmOpts  = [1 Inf];    % --> max defect DSM, and total DSMs (km/s)
inputParam.plot     = [1 1];      % --> plot(1) for Pareto front, plot(2) for best traj. DV
inputParam.parallel = false;      % --> put true for parallel, false otherwise
inputParam.tstep    = dt;         % --> step size for Time of flight            
%%%%%%%%%% set options %%%%%%%%%%

%%%%%%%%%% additional input options %%%%%%%%%%
% --> specify custom bounds for TOFs and VINFs
inputParam.vInfMaxEnd        = Inf;                                % --> max. DV at asteroid
inputParam.TOF_LIM           = [[10 300]];                         % --> TOF limits
inputParam.vInfLim           = [ 0 Inf; 0 inputParam.vInfMaxEnd ]; % --> PL1, PL2, PL3, ...   
inputParam.customEphemerides = @EphSS_NEOs; % --> custom ephemerides
%%%%%%%%%% additional input options %%%%%%%%%%

% --> perform the search for all the asteroids
files     = dir(fullfile(spk_dir, '*.bsp')); % Get all .bsp files
bsp_files = {files.name}; % Extract file names into a cell array

%%

seq = [ spk_id 3 ];

% --> write the input
INPUT = writeInputASTRA(seq, res, inputParam);

% --> launch ASTRA optimization
OUTPUT = ASTRA_DP(seq, INPUT);

processed_OUTPUT = postProcessOutputASTRA( OUTPUT );
SOLUTIONS_to_ret(1).OUTPUT = processed_OUTPUT;





