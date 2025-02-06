
% --> INFO : this script downloads the kernel files from NASA SPKID
clearDeleteAdd;

%%

% --> select objects, start date and end date
objs  = 'NEOs';
table = readtable( ['sbdb_query_results_' objs '.csv'] );
spkid = table2array(table(:,1));

t0    = [ 2025 1 1 12 0 0 ];
tf    = [ 2100 1 1 12 0 0 ];

% --> select the folder where to save the kernels
spk_dir = ['Ephemerides_' objs '_' num2str(t0(1)) '_' num2str(tf(1)) '_v2' ];

% --> download the kernel files from NASA database
id_error  = zeros( size(spkid,1), 1 );
id_failed = zeros( size(spkid,1), 1 );
for inds = 1:size(spkid,1)

    fprintf('Computing at %f \n', inds/size(spkid,1)*100);

    ID = spkid(inds,1);
    try
        success = getSPK(num2str(ID), num2str(t0), num2str(tf), spk_dir, 'overwrite', 'on');
    catch
        id_error(inds,:) = ID;
        success          = NaN;
    end

    if success == 0
        id_failed(inds,:) = ID;
    end

end

try id_error(id_error == 0) = []; catch; end
try id_failed(id_failed == 0) = []; catch; end

%%

d  = dir([[pwd '\' spk_dir], '\*.bsp']);
n  = length(d);

fid = fopen( 'results.txt', 'wt' );
for inds = 1:n
    fprintf( fid, ['''$KERNELS/' d(inds).name ''' \n']);
end
fclose(fid);

%%

% --> load the kernels
warning('off','all');
currentPath = pwd;
rmpath(genpath(currentPath));

% --> load the data from SPICE
id_failed = zeros( size(spkid,1), 1 );
for inds = 1:size(spkid,1)
    inds/size(spkid,1)*100
    try
        cspice_furnsh('data.mk');
        cspice_furnsh([ pwd '\' spk_dir '\' num2str(spkid(inds,1)) '.bsp']);
        cspice_kclear;
    catch
        id_failed(inds,:) = inds;
    end
end
id_failed(id_failed==0) = [];

spkid(id_failed) = [];

cspice_kclear;
