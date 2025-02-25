
clearDeleteAdd;

%%

seq  = [ 3 4 20000001 ];
revs = [ 0 0 ];
res  = [];

INPUT.idcentral = 1;

% --> load custom ephemerides
MICE_path = './MICE_TOOLBOX' ;
addpath(genpath(MICE_path)); % --> always include this

% --> load the kernels
cspice_furnsh( { [MICE_path '/' num2str(max(seq)) '_new.bsp'], ...
                 [MICE_path '/de435.bsp'], [MICE_path '/mar097.bsp'], ...
                 [MICE_path '/naif0012.tls'] } )

% --> define custom ephemerides
INPUT.customEphemerides = @EphSS_NEOs;

vdep_free = 3;

%%

t0     = date2mjd2000( [ 2003 6 5 0 0 0 ] );
t1     = date2mjd2000( [ 2004 3 16 0 0 0 ] );
t2     = date2mjd2000( [ 2005 8 21 0 0 0 ] );

tofs   = [t1 - t0, t2 - t1];

NREVS = [ 0 0 0 0; 0 0 0 0 ];

path = ASTRA_wrapPath_DP(seq, t0, tofs, NREVS, 1, INPUT.customEphemerides);


