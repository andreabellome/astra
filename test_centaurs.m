%% --> add the toolboxes to current path

% --> add ASTRA toolbox
clearDeleteAdd;

% --> add MICE toolbox (NASA SPICE interface with MATLAB)
MICE_path = './MICE_TOOLBOX' ;
addpath(genpath(MICE_path));           % --> always include this
cspice_furnsh([MICE_path '/data.mk']); % --> include data

%% --> load the data

% --> put some pruning
inc_min = 30;
inc_max = Inf;
ecc_max = Inf;
sma_max = 7;

% --> load and apply some filters if needed
table        = readtable( ['sbdb_query_results_centaurs.csv'] );
table_pruned = table( table.i <= inc_max & table.i >= inc_min &...
                      table.e <= ecc_max & table.a <= sma_max,:);

%% --> download

% --> initial and final epochs of the ephemerides
t0    = [ 2030 1 1 12 0 0 ];
tf    = [ 2100 1 1 12 0 0 ];

% --> folder where to save the files
spk_dir = 'eph_centaurs';

for row = 1:size(table_pruned,1)

    % --> clean names
    name   = table_pruned.full_name(row);
    name   = name{1};
    cleaned_str = regexprep(name, '\s+', ' ');
    if cleaned_str(1) == ' '
        cleaned_str(1) = [];
    end
    
    % --> download SPK files
    spk_id  = table_pruned.spkid(row);
    success = getSPK(num2str(spk_id), num2str(t0), num2str(tf), spk_dir, 'overwrite', 'on');

    fprintf( 'Asteroid %d/%d completed -- Success: %d \n', [row, size(table_pruned,1), success] );

end

%% --> plot orbits

close all;

t0      = [ 2030 1 1 12 0 0 ];
tf      = [ 2100 1 1 12 0 0 ];

spk_dir = 'eph_centaurs';

INPUT.customEphemerides = @EphSS_NEOs;

fig_traj_cent = figure( 'Color', [1 1 1] );
hold on; grid on; axis equal;
for row = 1:size(table_pruned,1)
    
    spk_id  = table_pruned.spkid(row);
    sma     = table_pruned.a(row).*AU;
    period  = 2*pi*sqrt( sma^3/mu );

    cspice_furnsh([ pwd '\' spk_dir '\' num2str(spk_id) '.bsp']);

    tend = min( [date2mjd2000(t0)+period/86400, date2mjd2000(tf)] );
    tt   = linspace( date2mjd2000(t0), tend );
    
    rr = zeros( length(tt),3 );
    vv = zeros( length(tt),3 );
    for indt = 1:length(tt)
        [ rr(indt,:), vv(indt,:) ] = INPUT.customEphemerides( spk_id, tt(indt) );
    end

    plot3( rr(:,1)./AU, rr(:,2)./AU, rr(:,3)./AU, 'k-', 'HandleVisibility', 'off' );
    
    fprintf( 'Asteroid %d/%d completed \n', [row, size(table_pruned,1)] );
end

plotPLTS_tt(5, date2mjd2000(t0), date2mjd2000(tf), 1, [], 1, 'red', {'Jupiter'}, 2);
plotPLTS_tt(6, date2mjd2000(t0), date2mjd2000(tf), 1, [], 1, 'yellow', {'Saturn'}, 2);

%% --> test everything is working

seq = spk_id;

cspice_furnsh([ pwd '\' spk_dir '\' num2str(seq(end)) '.bsp']);

INPUT.customEphemerides = @EphSS_NEOs;

[ rr, vv ] = INPUT.customEphemerides( seq(end), date2mjd2000(tf) );
