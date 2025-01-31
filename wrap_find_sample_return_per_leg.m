function [LEG_TO_GO, REVS_TO_GO, VINF_DEP_TO_GO, VINF_ARR_TO_GO, ...
    LEG_TO_RE, REVS_TO_RE, VINF_DEP_TO_RE, VINF_ARR_TO_RE, STAY_DAYS, TOF_YEARS_TOT] = ...
    wrap_find_sample_return_per_leg(indleg, LEGS_to_go, REVS_to_go, VINFd_to_go, VINFa_to_go, ...
    LEGS_to_ret, REVS_to_ret, VINFd_to_ret, VINFa_to_ret, min_days_asteroid, tofy_max)


leg            = LEGS_to_go(indleg,:);
vinf_dep_Earth = VINFd_to_go(indleg);
dv_ast_arr     = VINFa_to_go(indleg);

t_dep_earth    = leg(2);
t_arrival      = leg(end);

LEG_TO_GO = zeros( 2e6, size(LEGS_to_go,2) );
LEG_TO_RE = zeros( 2e6, size(LEGS_to_ret,2) );

REVS_TO_GO = zeros( 2e6, size(REVS_to_go,2) );
REVS_TO_RE = zeros( 2e6, size(REVS_to_ret,2) );

VINF_DEP_TO_GO = zeros( 2e6, size(VINFd_to_go,2) );
VINF_ARR_TO_GO = zeros( 2e6, size(VINFa_to_go,2) );

VINF_DEP_TO_RE = zeros( 2e6, size(VINFd_to_ret,2) );
VINF_ARR_TO_RE = zeros( 2e6, size(VINFa_to_ret,2) );

STAY_DAYS     = zeros( 2e6, 1 );
TOF_YEARS_TOT = zeros( 2e6,1 );

INDEX = 1;

for indleg_ret = 1:size(LEGS_to_ret,1)
    
    leg_ret = LEGS_to_ret(indleg_ret,:);

    dv_ast_dep     = VINFd_to_ret(indleg_ret); 
    vinf_arr_Earth = VINFa_to_ret(indleg_ret);
    t_dep          = leg_ret( 2 );

    t_arr_earth = leg_ret(end);

    stay_days = t_dep - t_arrival;
    tofy      = (t_arr_earth - t_dep_earth)/365.25;

    if stay_days >= min_days_asteroid && tofy <= tofy_max

        LEG_TO_GO(INDEX,:) = leg;
        LEG_TO_RE(INDEX,:) = leg_ret;

        REVS_TO_GO(INDEX,:)    = REVS_to_go(indleg,:);
        REVS_TO_RE(INDEX,:)    = REVS_to_ret(indleg_ret,:);

        VINF_DEP_TO_GO(INDEX,:) = vinf_dep_Earth;
        VINF_ARR_TO_GO(INDEX,:) = dv_ast_arr;

        VINF_DEP_TO_RE(INDEX,:) = dv_ast_dep;
        VINF_ARR_TO_RE(INDEX,:) = vinf_arr_Earth;

        STAY_DAYS(INDEX,:)       = stay_days;

        TOF_YEARS_TOT(INDEX,:)   = tofy;
        
        INDEX = INDEX + 1;

    end

end

indxs = find( TOF_YEARS_TOT == 0 );

LEG_TO_GO(indxs,:)      = [];
LEG_TO_RE(indxs,:)      = [];

REVS_TO_GO(indxs,:)     = [];
REVS_TO_RE(indxs,:)     = [];

VINF_DEP_TO_GO(indxs,:) = [];
VINF_ARR_TO_GO(indxs,:) = [];

VINF_DEP_TO_RE(indxs,:) = [];
VINF_ARR_TO_RE(indxs,:) = [];

STAY_DAYS(indxs,:)      = [];
TOF_YEARS_TOT(indxs,:)  = [];

if ~isempty(TOF_YEARS_TOT)

    % --> find unique arrival dates and keep the ones with lowest DV
    arrival_times = LEG_TO_RE(:, end);
    unique_times  = unique(arrival_times);

    filtered_rows_LEG_TO_RE      = [];
    filtered_rows_REVS_TO_RE     = [];
    filtered_rows_VINF_DEP_TO_RE = [];
    filtered_rows_VINF_ARR_TO_RE = [];
    filtered_rows_STAY_DAYS      = [];
    filtered_rows_TOF_YEARS_TOT  = [];
    for i = 1:length(unique_times)
        % Get all rows corresponding to the current unique arrival time
        idx    = find(arrival_times == unique_times(i));

        subMAT_LEG_TO_RE  = LEG_TO_RE(idx, :);
        subMAT_REVS_TO_RE = REVS_TO_RE(idx,:);

        subMAT_VINF_DEP_TO_RE = VINF_DEP_TO_RE(idx,:);
        subMAT_VINF_ARR_TO_RE = VINF_ARR_TO_RE(idx,:);

        subMAT_STAY_DAYS      = STAY_DAYS(idx,:);
        subMAT_TOF_YEARS_TOT  = TOF_YEARS_TOT(idx,:);

        % If there are multiple trajectories, select the one with min DV
        if size(subMAT_LEG_TO_RE, 1) > 1
            [~, minIdx]      = min(subMAT_LEG_TO_RE(:, end-2)); % Find row with min ΔV

            subMAT_LEG_TO_RE  = subMAT_LEG_TO_RE(minIdx, :);  % Keep only that row
            subMAT_REVS_TO_RE = subMAT_REVS_TO_RE(minIdx, :); % Keep only that row
            
            subMAT_VINF_DEP_TO_RE = subMAT_VINF_DEP_TO_RE(minIdx, :); % Keep only that row
            subMAT_VINF_ARR_TO_RE = subMAT_VINF_ARR_TO_RE(minIdx, :); % Keep only that row
            subMAT_STAY_DAYS      = subMAT_STAY_DAYS(minIdx, :);      % Keep only that row
            subMAT_TOF_YEARS_TOT  = subMAT_TOF_YEARS_TOT(minIdx, :);     % Keep only that row
            
        end
        
        % Append the selected row to filtered_rows
        filtered_rows_LEG_TO_RE      = [filtered_rows_LEG_TO_RE; subMAT_LEG_TO_RE];
        filtered_rows_REVS_TO_RE     = [filtered_rows_REVS_TO_RE; subMAT_REVS_TO_RE];
        filtered_rows_VINF_DEP_TO_RE = [filtered_rows_VINF_DEP_TO_RE; subMAT_VINF_DEP_TO_RE];
        filtered_rows_VINF_ARR_TO_RE = [filtered_rows_VINF_ARR_TO_RE; subMAT_VINF_ARR_TO_RE];
        filtered_rows_STAY_DAYS      = [filtered_rows_STAY_DAYS; subMAT_STAY_DAYS];
        filtered_rows_TOF_YEARS_TOT  = [filtered_rows_TOF_YEARS_TOT; subMAT_TOF_YEARS_TOT];

    end
    
    LEG_TO_RE      = filtered_rows_LEG_TO_RE;
    REVS_TO_RE     = filtered_rows_REVS_TO_RE;
    VINF_DEP_TO_RE = filtered_rows_VINF_DEP_TO_RE;
    VINF_ARR_TO_RE = filtered_rows_VINF_ARR_TO_RE;
    
    STAY_DAYS      = filtered_rows_STAY_DAYS;
    TOF_YEARS_TOT  = filtered_rows_TOF_YEARS_TOT;

    LEG_TO_GO  = LEG_TO_GO(1,:).*ones( size(LEG_TO_RE,1), size(LEG_TO_GO,2) );
    REVS_TO_GO = REVS_TO_GO(1,:).*ones( size(LEG_TO_RE,1), size(REVS_TO_GO,2) );

    VINF_DEP_TO_GO = VINF_DEP_TO_GO(1,:).*ones( size(LEG_TO_RE,1), size(VINF_DEP_TO_GO,2) );
    VINF_ARR_TO_GO = VINF_ARR_TO_GO(1,:).*ones( size(LEG_TO_RE,1), size(VINF_ARR_TO_GO,2) );
    
else
    LEG_TO_RE      = [];
    REVS_TO_RE     = [];
    VINF_DEP_TO_RE = [];
    VINF_ARR_TO_RE = [];
end

end
