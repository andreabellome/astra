%% --> ADD THE REQUIRED FOLDERS

% --> load ASTRA
clearDeleteAdd;

%%

% --> load MICE and kernels
MICE_path = './MICE_TOOLBOX' ;
addpath(genpath(MICE_path)); 
cspice_furnsh([MICE_path '/data.mk']);

% --> from EARTH to ASTEROID
load('SOLUTIONS_to_go.mat');
SOLUTIONS_to_go = SOLUTIONS;
clear SOLUTIONS;

% --> from ASTEROID to EARTH
load('SOLUTIONS_to_ret.mat');
SOLUTIONS_to_ret = SOLUTIONS;
clear SOLUTIONS;

%%

ASTEROID_to_ret = zeros( length(SOLUTIONS_to_ret),1 );
for inds = 1:length(SOLUTIONS_to_ret)
    ASTEROID_to_ret(inds,1) = SOLUTIONS_to_ret(inds).OUTPUT.seq(1);
end

ASTEROID_to_go = zeros( length(SOLUTIONS_to_go),1 );
for inds = 1:length(SOLUTIONS_to_go)
    ASTEROID_to_go(inds,1) = SOLUTIONS_to_go(inds).OUTPUT.seq(end);
end

missing_values = setdiff(ASTEROID_to_ret, ASTEROID_to_go);
indices        = find(ismember(ASTEROID_to_ret, missing_values));

%%

min_days_asteroid  = 30;

tofy_max           = 1;

vinf_Earth_dep_min = 3;
vinf_Earth_arr_min = 3;

dv_ast_arr_min     = 1.5;
dv_ast_dep_min     = 1.5;

min_dep_date       = date2mjd2000( [ 2028 1 1 12 0 0 ] );
max_dep_date       = date2mjd2000( [ 2029 1 1 12 0 0 ] );


max_ret_date       = date2mjd2000( [ 2028 12 31 12 0 0 ] );

%%

num_elements_1 = length(SOLUTIONS_to_go);
SAMPLE_RETURN = struct( ...
    'LEG_TO_GO', cell(1, num_elements_1), ...
    'REVS_TO_GO', cell(1, num_elements_1), ...
    'VINF_DEP_TO_GO', cell(1, num_elements_1), ...
    'VINF_ARR_TO_GO', cell(1, num_elements_1), ...
    'LEG_TO_RE', cell(1, num_elements_1), ...
    'REVS_TO_RE', cell(1, num_elements_1), ...
    'VINF_DEP_TO_RE', cell(1, num_elements_1), ...
    'VINF_ARR_TO_RE', cell(1, num_elements_1), ...
    'STAY_DAYS', cell(1, num_elements_1), ...
    'TOF_YEARS_TOT', cell(1, num_elements_1), ...
    'res_to_go', cell(1, num_elements_1), ...
    'res_to_ret', cell(1, num_elements_1), ...
    'seq_to_go', cell(1, num_elements_1), ...
    'seq_to_re', cell(1, num_elements_1), ...
    'tof_days_to_go', cell(1, num_elements_1), ...
    'tof_days_to_re', cell(1, num_elements_1) ...
);

%%

for inds = 1:length(SOLUTIONS_to_go) % 1:length(SOLUTIONS_to_go)

    % --> extract the solutions
    LEGS_to_go  = SOLUTIONS_to_go(inds).OUTPUT.LEGS;
    REVS_to_go  = SOLUTIONS_to_go(inds).OUTPUT.REVS;
    VINFd_to_go = SOLUTIONS_to_go(inds).OUTPUT.VINFd; % --> infinity velocity at Earth dep.
    VINFa_to_go = SOLUTIONS_to_go(inds).OUTPUT.VINFa; % --> infinity velocity at asteroid
    
    LEGS_to_ret  = SOLUTIONS_to_ret(inds).OUTPUT.LEGS;
    REVS_to_ret  = SOLUTIONS_to_ret(inds).OUTPUT.REVS;
    VINFd_to_ret = SOLUTIONS_to_ret(inds).OUTPUT.VINFd; % --> infinity velocity at asteroid dep.
    VINFa_to_ret = SOLUTIONS_to_ret(inds).OUTPUT.VINFa; % --> infinity velocity at Earth arr.
    
    % --> prune solutions 
    [LEGS_to_go, REVS_to_go, VINFd_to_go, VINFa_to_go, ...
    LEGS_to_ret, REVS_to_ret, VINFd_to_ret, VINFa_to_ret] = ...
    prune_sample_return(LEGS_to_go, REVS_to_go, VINFd_to_go, VINFa_to_go, ...
        LEGS_to_ret, REVS_to_ret, VINFd_to_ret, VINFa_to_ret, ...
        vinf_Earth_dep_min, dv_ast_arr_min, ...
        dv_ast_dep_min, vinf_Earth_arr_min, ...
        min_dep_date, max_dep_date, max_ret_date );

    st = 1;

    res_to_go             = SOLUTIONS_to_go(inds).OUTPUT.res;
    res_to_ret            = SOLUTIONS_to_ret(inds).OUTPUT.res;
    
    if ~isempty(LEGS_to_go) && ~isempty(LEGS_to_ret)
        
        num_elements = size(LEGS_to_go, 1);
        structure = struct( ...
            'LEG_TO_GO', cell(1, num_elements), ...
            'REVS_TO_GO', cell(1, num_elements), ...
            'VINF_DEP_TO_GO', cell(1, num_elements), ...
            'VINF_ARR_TO_GO', cell(1, num_elements), ...
            'LEG_TO_RE', cell(1, num_elements), ...
            'REVS_TO_RE', cell(1, num_elements), ...
            'VINF_DEP_TO_RE', cell(1, num_elements), ...
            'VINF_ARR_TO_RE', cell(1, num_elements), ...
            'STAY_DAYS', cell(1, num_elements), ...
            'TOF_YEARS_TOT', cell(1, num_elements) ...
        );
        parfor indleg = 1:size( LEGS_to_go,1 )

            indleg/size(LEGS_to_go,1)*100

            [LEG_TO_GO, REVS_TO_GO, VINF_DEP_TO_GO, VINF_ARR_TO_GO, ...
                LEG_TO_RE, REVS_TO_RE, VINF_DEP_TO_RE, VINF_ARR_TO_RE, STAY_DAYS, TOF_YEARS_TOT] = ...
                wrap_find_sample_return_per_leg(indleg, LEGS_to_go, REVS_to_go, VINFd_to_go, VINFa_to_go, ...
                LEGS_to_ret, REVS_to_ret, VINFd_to_ret, VINFa_to_ret, min_days_asteroid, tofy_max);
            
            structure(indleg).LEG_TO_GO      = LEG_TO_GO;
            structure(indleg).REVS_TO_GO     = REVS_TO_GO;
            structure(indleg).VINF_DEP_TO_GO = VINF_DEP_TO_GO;
            structure(indleg).VINF_ARR_TO_GO = VINF_ARR_TO_GO;
            structure(indleg).LEG_TO_RE      = LEG_TO_RE;
            structure(indleg).REVS_TO_RE     = REVS_TO_RE;
            structure(indleg).VINF_DEP_TO_RE = VINF_DEP_TO_RE;
            structure(indleg).VINF_ARR_TO_RE = VINF_ARR_TO_RE;
            structure(indleg).STAY_DAYS      = STAY_DAYS;
            structure(indleg).TOF_YEARS_TOT  = TOF_YEARS_TOT;

        end
        
        % --> find optimal solutions
        [ov_LEG_TO_GO, ov_REVS_TO_GO, ov_VINF_DEP_TO_GO, ov_VINF_ARR_TO_GO, ...
         ov_LEG_TO_RE, ov_REVS_TO_RE, ov_VINF_DEP_TO_RE, ov_VINF_ARR_TO_RE, ...
         ov_STAY_DAYS, ov_TOF_YEARS_TOT] = wrap_find_unique_sample_return( structure );


        st = 1;
        
        if ~isempty(ov_TOF_YEARS_TOT)

            seq_to_go = ov_LEG_TO_GO(1,1:3:end-1);
            seq_to_re = ov_LEG_TO_RE(1,1:3:end-1);

            tof_days_to_go = ov_LEG_TO_GO(:,end) - ov_LEG_TO_GO(:,2);
            tof_days_to_re = ov_LEG_TO_RE(:,end) - ov_LEG_TO_RE(:,2);

            % --> save the solutions
            SAMPLE_RETURN(inds).LEG_TO_GO      = ov_LEG_TO_GO;
            SAMPLE_RETURN(inds).REVS_TO_GO     = ov_REVS_TO_GO;
            SAMPLE_RETURN(inds).VINF_DEP_TO_GO = ov_VINF_DEP_TO_GO;
            SAMPLE_RETURN(inds).VINF_ARR_TO_GO = ov_VINF_ARR_TO_GO;

            SAMPLE_RETURN(inds).LEG_TO_RE      = ov_LEG_TO_RE;
            SAMPLE_RETURN(inds).REVS_TO_RE     = ov_REVS_TO_RE;
            SAMPLE_RETURN(inds).VINF_DEP_TO_RE = ov_VINF_DEP_TO_RE;
            SAMPLE_RETURN(inds).VINF_ARR_TO_RE = ov_VINF_ARR_TO_RE;
    
            SAMPLE_RETURN(inds).STAY_DAYS      = ov_STAY_DAYS;
            SAMPLE_RETURN(inds).TOF_YEARS_TOT  = ov_TOF_YEARS_TOT;
        
            SAMPLE_RETURN(inds).res_to_go      = res_to_go;
            SAMPLE_RETURN(inds).res_to_re      = res_to_ret;
    
            SAMPLE_RETURN(inds).seq_to_go      = seq_to_go;
            SAMPLE_RETURN(inds).seq_to_re      = seq_to_re;

            SAMPLE_RETURN(inds).tof_days_to_go = tof_days_to_go;
            SAMPLE_RETURN(inds).tof_days_to_re = tof_days_to_re;
            
            save -v7.3 SAMPLE_RETURN SAMPLE_RETURN

            st = 1;

        end

    end

end

%%

empty_indexes = find(arrayfun(@(SAMPLE_RETURN) isempty(SAMPLE_RETURN.LEG_TO_GO),SAMPLE_RETURN));
SAMPLE_RETURN(empty_indexes) = [];

%% --> SELECT THE ASTEROIDS TO ANALYSE

moid_th      = 0.01;
ecc_th       = 0.1;
table        = readtable( ['sbdb_query_results.csv'] );
table_pruned = table( table.moid <= moid_th & table.e <= ecc_th ,:);

% --> clean names
ind_row = find(table_pruned.spkid == SAMPLE_RETURN(1).seq_to_go(end));

name   = table_pruned.full_name(ind_row);
name   = name{1};
cleaned_str = regexprep(name, '\s+', ' ');
if cleaned_str(1) == ' '
    cleaned_str(1) = [];
end

%%

% --> now plot

ind_sample = 1;

seq_to_go = SAMPLE_RETURN(ind_sample).seq_to_go;
seq_to_re = SAMPLE_RETURN(ind_sample).seq_to_re;

res_to_go       = SAMPLE_RETURN(ind_sample).res_to_go;
res_to_re       = SAMPLE_RETURN(ind_sample).res_to_re;

leg_to_go       = SAMPLE_RETURN(ind_sample).LEG_TO_GO;
revs_to_go      = SAMPLE_RETURN(ind_sample).REVS_TO_GO;
vinf_dep_to_go  = SAMPLE_RETURN(ind_sample).VINF_DEP_TO_GO;
vinf_arr_to_go  = SAMPLE_RETURN(ind_sample).VINF_ARR_TO_GO;

leg_to_re       = SAMPLE_RETURN(ind_sample).LEG_TO_RE;
revs_to_re      = SAMPLE_RETURN(ind_sample).REVS_TO_RE;
vinf_dep_to_re  = SAMPLE_RETURN(ind_sample).VINF_DEP_TO_RE;
vinf_arr_to_re  = SAMPLE_RETURN(ind_sample).VINF_ARR_TO_RE;

stay_days       = SAMPLE_RETURN(ind_sample).STAY_DAYS;
tof_years_tot   = SAMPLE_RETURN(ind_sample).TOF_YEARS_TOT;

tof_days_to_go  = SAMPLE_RETURN(ind_sample).tof_days_to_go;
tof_days_to_re  = SAMPLE_RETURN(ind_sample).tof_days_to_re;

cost_tot  = vinf_dep_to_go + vinf_arr_to_go + vinf_dep_to_re + vinf_arr_to_re;
dep_dates = leg_to_go(:,2);

figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'Departing date' ); ylabel( 'Cost [km/s]' );

title_name = ['Asteroid: ' cleaned_str];
title(title_name);

scatter(dep_dates, cost_tot, 50, tof_years_tot, 'filled');

colormap('cool'); % Seleziona una colormap (es. 'jet', 'parula', 'hot', etc.)
cb = colorbar; % Mostra la barra dei colori per riferimento
ylabel(cb, 'ToF [years]'); % Aggiungi l'etichetta alla barra dei colori

datetick('x','mmm.dd,yy' );

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

%%

% --> now process the path
customEphemerides = @EphSS_NEOs;

t0    = [ 2030 1 1 12 0 0 ];
tf    = [ 2100 1 1 12 0 0 ];
objs    = 'NEOs';
spk_dir = ['Ephemerides_' objs '_' num2str(t0(1)) '_' num2str(tf(1)) ];
cspice_furnsh([ pwd '\' spk_dir '\' num2str(seq_to_go(end)) '.bsp']);

[ min_cost, row ] = min(cost_tot);

path_to_go = leg_to_go(row,:);
path_to_re = leg_to_re(row,:);

[path_to_go] = ASTRA_wrapPath_DP(path_to_go(1:3:end-1), path_to_go(2), ...
    diff(path_to_go(2:3:end)),  generateDiffRuns(revs_to_go(row,:), res_to_go), 1, customEphemerides);

[path_to_re] = ASTRA_wrapPath_DP(path_to_re(1:3:end-1), path_to_re(2), ...
    diff(path_to_re(2:3:end)),  generateDiffRuns(revs_to_re(row,:), res_to_re), 1, customEphemerides);


% --> plot the path
figECI_to_go = plotPath(path_to_go, 1, customEphemerides);
figECI_to_re = plotPath(path_to_re, 1, customEphemerides);

%% --> LOW THRUST TO GO

INPUT.idcentral = 1;
INPUT.customEphemerides = customEphemerides;

Tmax        = 0.15;       % --> max. thrust                       [N]
Isp         = 3000;       % --> specific impulse                  [s]
m0          = 750;        % --> initial mass                      [kg]           
g0          = 9.80665;    % --> Earth acceleration at sea level   [m/s]
useParallel = true;       % --> if true, uses parallel for fsolve

% --> post-process the path
vinfFree = 1.5;
struc    = postProcessPathASTRA_lowThrust(path_to_go, vinfFree, 0, ...
                    INPUT.idcentral, INPUT.customEphemerides);

inds   = 1;
state1 = struc(inds).xxDtar;
state2 = struc(inds).xxAtar;
tof    = ( struc(inds).tA - struc(inds).tD ) * 86400;
dvD    = struc(inds).dvD;
dvA    = struc(inds).dvA;
accel  = ( dvD + dvA )*1000/tof;
revopt = rev2RevOpt(revs_to_go(row,:), res_to_go, inds);

if accel * 2 <= Tmax/m0

    % --> initialise the parameters
    param        = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0,...
                    revopt(1), INPUT.idcentral, useParallel);
    param.plot   = true;    % --> this plots the thrust evolution over time for different rho (default is false)
    param.gamma  = 0.5;
    param.rhoLim = 1e-5;
    
    % --> solve the problem
    LTsol_to_go = wrapSolveFopt( param );
    
    % --> plot the solution
    transfer = LTsol_to_go.transfer;
    [figTRAJ, figMASS, figTHRmag] = plotLT( transfer, param );
    
    figure(figTRAJ);
    colors = cool(2);
    plotPLTS_tt(3, 0, 0+365.25, 1, INPUT.customEphemerides, 1, 'k', {'Earth'}, 0.5, '--');  % --> plot the Earth
    plotPLTS_tt(struc(inds).idA, struc(inds).tA, struc(inds).tA+365.25, 1,...
        INPUT.customEphemerides, 1, 'red', ...
        {num2str(struc(inds).idA)}, 0.5, '--');  % --> plot the asteroid

else
    
    fprintf( 'Thrust system is not enough \n' );

end

%% --> LOW THRUST TO RETURN

m0 = LTsol_to_go.mf;

vinf_free_re = 4;
struc        = postProcessPathASTRA_lowThrust(path_to_re, 0, vinf_free_re, ...
                    INPUT.idcentral, INPUT.customEphemerides);

inds   = 1;
state1 = struc(inds).xxDtar;
state2 = struc(inds).xxAtar;
tof    = ( struc(inds).tA - struc(inds).tD ) * 86400;
dvD    = struc(inds).dvD;
dvA    = struc(inds).dvA;
accel  = ( dvD + dvA )*1000/tof;
revopt = rev2RevOpt(revs_to_go(row,:), res_to_go, inds);

if accel * 2 <= Tmax/m0

    % --> initialise the parameters
    param        = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, ...
                    revopt(1), INPUT.idcentral, useParallel);
    param.plot   = true;    % --> this plots the thrust evolution over time for different rho (default is false)
    param.gamma  = 0.5;
    param.rhoLim = 1e-5;

    % --> solve the problem
    LTsol_to_re = wrapSolveFopt( param );
    
    % --> plot the solution
    transfer = LTsol_to_re.transfer;
    figTRAJ  = plotLT( transfer, param );
    
    figure(figTRAJ);
    colors = cool(2);
    plotPLTS_tt(struc(inds).idD, struc(inds).tD, struc(inds).tA+365.25, 1,...
        INPUT.customEphemerides, 1, 'red',...
        {num2str(struc(inds).idD)}, 0.5, '--');  % --> plot the Earth
    plotPLTS_tt(struc(inds).idA, struc(inds).tA, struc(inds).tA+365.25, 1,...
        INPUT.customEphemerides, 1, 'k', ...
        {'Earth'}, 0.5, '--');  % --> plot the asteroid

else
    
    fprintf( 'Thrust system is not enough \n' );

end
