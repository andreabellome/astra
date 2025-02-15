%% --> ADD THE REQUIRED FOLDERS

% --> load ASTRA
clearDeleteAdd;

%%

% --> load MICE and kernels
MICE_path = './MICE_TOOLBOX' ;
addpath(genpath(MICE_path)); 
cspice_furnsh([MICE_path '/data.mk']);

%% --> SELECT THE ASTEROIDS TO ANALYSE

moid_th      = 0.01;
ecc_th       = 0.1;
table        = readtable( ['sbdb_query_results.csv'] );
table_pruned = table( table.moid <= moid_th & table.e <= ecc_th ,:);

t0    = [ 2030 1 1 12 0 0 ];
tf    = [ 2100 1 1 12 0 0 ];

objs    = 'NEOs';
spk_dir = ['Ephemerides_' objs '_' num2str(t0(1)) '_' num2str(tf(1)) ];

%% --> DOWNLOAD ASTEROIDS EPHEMERIDES

id_not_succ = zeros( size(table_pruned,1),1 );
for row = 1:size(table_pruned,1)

    fprintf( 'Computing: %f \% \n', row/size(table_pruned,1)*100 );
    
    % --> clean names
    name   = table_pruned.full_name(row);
    name   = name{1};
    cleaned_str = regexprep(name, '\s+', ' ');
    if cleaned_str(1) == ' '
        cleaned_str(1) = [];
    end
    
    fprintf( 'Computing asteroids: %s \n', cleaned_str );
    
    fprintf( 'Downloading ephemerides ... \n');
    spk_id = table_pruned.spkid(row);

    try
        success = getSPK(num2str(spk_id), num2str(t0), num2str(tf), spk_dir, 'overwrite', 'on');
    
        if success 
            
            fprintf( 'Success! \n');
    
        else
    
            id_not_succ(row,1) = spk_id;
    
        end
    catch
        id_not_succ(row,1) = spk_id;
    end

end
id_not_succ(id_not_succ==0,:) = [];

%% --> ASTRA ROUTINE FOR ALL THE ASTEROIDS -- TO GO

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

% --> perform the search
SOLUTIONS = struct( 'OUTPUT', cell(1, length(bsp_files)) );
for ind_bsp = 1:length(bsp_files)

    % --> load the ephemerides
    bsp_ast  = bsp_files{ind_bsp};
    name_ast = bsp_ast(1:end-4);
    cspice_furnsh([ pwd '\' spk_dir '\' bsp_ast]);

    % --> sequence
    pl1 = 3;
    pl2 = str2double(name_ast);
    seq = [ pl1 pl2 ];

    % --> write the input
    INPUT = writeInputASTRA(seq, res, inputParam);

    % --> launch ASTRA optimization
    OUTPUT = ASTRA_DP(seq, INPUT);
    
    % --> save the results
    if ~isempty(OUTPUT)

        if ~isempty(OUTPUT(1).LEGSpf)
            % --> process the OUTPUT and save
            processed_OUTPUT = postProcessOutputASTRA( OUTPUT );
            SOLUTIONS(ind_bsp).OUTPUT = processed_OUTPUT;
            save -v7.3 SOLUTIONS_to_go SOLUTIONS
        end

    end

    st = 1;
    
end

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

% --> perform the search
SOLUTIONS = struct( 'OUTPUT', cell(1, length(bsp_files)) );
for ind_bsp = 1:length(bsp_files)

    % --> load the ephemerides
    bsp_ast  = bsp_files{ind_bsp};
    name_ast = bsp_ast(1:end-4);
    cspice_furnsh([ pwd '\' spk_dir '\' bsp_ast]);

    % --> sequence
    pl2 = 3;
    pl1 = str2double(name_ast);
    seq = [ pl1 pl2 ];

    % --> write the input
    INPUT = writeInputASTRA(seq, res, inputParam);

    % --> launch ASTRA optimization
    OUTPUT = ASTRA_DP(seq, INPUT);
    
    % --> save the results
    if ~isempty(OUTPUT)

        if ~isempty(OUTPUT(1).LEGSpf)
            % --> process the OUTPUT and save
            processed_OUTPUT = postProcessOutputASTRA( OUTPUT );
            SOLUTIONS(ind_bsp).OUTPUT = processed_OUTPUT;
            save -v7.3 SOLUTIONS_to_ret SOLUTIONS
        end

    end

    st = 1;
    
end

%%

close all; clc;

indsol = 57;

processed_OUTPUT = SOLUTIONS(indsol).OUTPUT;

tofyMax = Inf;
costMax = Inf;

figure( 'Color', [1 1 1] );
hold on; grid on;

depDates = [processed_OUTPUT.depDates];
costs    = [processed_OUTPUT.COSTS];
tof      = [processed_OUTPUT.TOFYS];

indxs = find( tof <= tofyMax & costs <= costMax );

depDates = depDates(indxs);
costs    = costs(indxs);
tof      = tof(indxs);

N = zeros( size(depDates,1),1 );
for indi = 1:size(depDates,1)
    date = mjd20002date(depDates(indi,1));
    date = date(1:3);
    N(indi,1) = datenum(date);
end

% Creazione del grafico
scatter(depDates, costs, 50, tof, 'filled'); % '50' è la dimensione dei marker
datetick('x','mmm.dd,yy' );

colormap('cool'); % Seleziona una colormap (es. 'jet', 'parula', 'hot', etc.)
cb = colorbar; % Mostra la barra dei colori per riferimento
ylabel(cb, 'ToF [years]'); % Aggiungi l'etichetta alla barra dei colori

ylabel('Cost [km/s]');

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 
