
% --> load ASTRA
clearDeleteAdd; % --> !!! ONLY CALL IT ONCE FOR SPEED

% --> load mice
MICE_path = './MICE_TOOLBOX';
addpath(genpath(MICE_path)); % --> always include this
cspice_furnsh([MICE_path '/data.mk']);

%%

% --> central ID (Sun in this case)
idcentral = 1;

% --> lower and upper bounds for ephemerides
t0 = [ 2030 1 1 12 0 0 ];
tf = [ 2100 1 1 12 0 0 ];

% --> SPKID of the object (found at https://ssd.jpl.nasa.gov/tools/sbdb_lookup.html#/)
spk_id = 20000001; % --> Ceres
% spk_id = 20000021; % --> Lutetia
% spk_id = 20150591;
% spk_id = 20348435; 
% spk_id = 1000004; % --> 85D/Boethin
% spk_id = 1000012; % --> 67P/Churyumov-Gerasimenko
% spk_id = 1000020; % --> 72P/Denning-Fujikawa

% --> set the path where to save the ephemerides
spk_dir = pwd;

% --> run the code (if success=1 then everything is okay)
success = getSPK(num2str(spk_id), num2str(t0), num2str(tf), spk_dir, 'overwrite', 'on');

%% --> check that you can use the ephemerides properly

% --> load custom ephemerides
cspice_furnsh([ spk_dir '\' num2str(spk_id) '.bsp']); % --> load the object ephemerides

INPUT.customEphemerides = @EphSS_from_mice;

t0_mjd2000 = date2mjd2000(t0);
[rr, vv]   = INPUT.customEphemerides( spk_id, t0_mjd2000, idcentral );

