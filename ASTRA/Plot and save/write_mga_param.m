function write_mga_param( struc, INPUT, name )

% DESCRIPTION
% This function generates a formatted text file summarizing a multi-leg interplanetary transfer sequence, including launch conditions, intermediate planetary flybys, and final arrival conditions. It computes and reports hyperbolic excess velocity vectors, launch asymptotic direction, flyby B-plane parameters, and periapsis altitude using ephemerides and planetary constants. The output is structured as a human-readable report suitable for trajectory design analysis and mission documentation.
%
% INPUT
% - struc : Structure array defining the trajectory sequence. Each element contains:
%           - idD [--] departing body ID for leg i
%           - idA [--] arriving body ID for leg i
%           - tD [MJD2000] departure epoch of leg i
%           - tA [MJD2000] arrival epoch of leg i
%           - xxDtar [km, km/s] state vector at departure (position and velocity)
%           - xxAtar [km, km/s] state vector at arrival (position and velocity)
%           - dvA [km/s] arrival impulsive velocity change (optional)
%
% - INPUT : Structure containing global parameters:
%           idcentral [--] central body identifier
%           customEphemerides [km, km/s] function handle returning body state;
%           if not provided defaults to EphSS_cartesian
%
% - name : Output filename string. If relative path is provided, it is
%          appended to the current working directory; otherwise an absolute
%          path is used. 
%
% OUTPUT
% - out : File identifier of the generated text file containing:
%         launch conditions (v∞, RA, Dec),
%         flyby parameters (v∞, B-plane parameters, true anomaly, periapsis
%         altitude), and arrival conditions (v∞ at target body). 
%
% -------------------------------------------------------------------------

if isfield(INPUT,'customEphemerides')
    customEphemerides = INPUT.customEphemerides;
else
    customEphemerides = @EphSS_cartesian;
end

idcentral = INPUT.idcentral;

FLYBYPARAM  = [];
FLYBYPLANET = [];
FLYBYDATE   = [];
for inds = 1:length(struc) - 1

    idD = struc(inds).idD;
    idA = struc(inds).idA;

    tD = struc(inds).tD;
    tA = struc(inds).tA; 

    xxDtar      = struc(inds).xxDtar;
    xxAtar      = struc(inds).xxAtar;
    xxDtarNext  = struc(inds+1).xxDtar;
    
    [ ~, vvga ]              = customEphemerides( idA, tA, idcentral );
    vvinfIn                  = xxAtar(4:6) - vvga;
    vvinfOu                  = xxDtarNext(4:6) - vvga;
    [~, mu_planet, ~, radpl] = constants(idcentral, idA);

    [flyby_param, periapsis] = vinfVec2VinfBplane( vvinfIn, vvinfOu, mu_planet );
    periapsis_altitude       = periapsis - radpl;
    
    FLYBYDATE   = [ FLYBYDATE; tA ];
    FLYBYPLANET = [ FLYBYPLANET; idA ];
    FLYBYPARAM  = [ FLYBYPARAM; flyby_param ];

end

% --> first leg of the transfer
inds        = 1;
tD          = struc(inds).tD;
idD         = struc(inds).idD;
xxDtar      = struc(inds).xxDtar;
[ ~, vvga ] = customEphemerides( idD, tD, idcentral );

[Dec, Asc]          = findDeclinationLaunch(xxDtar(:,4:6), vvga);
declination_degrees = rad2deg(Dec);
right_asc_degrees   = rad2deg(Asc);
vinf_dep            = norm(xxDtar(:,4:6) - vvga);
name_pl_launch      = planetIdToName(idD, idcentral);

% --> arrival leg of the transfer
inds        = length(struc);
tA          = struc(inds).tA;
idA         = struc(inds).idA;
xxAtar      = struc(inds).xxAtar;
[ ~, vvga ] = customEphemerides( idA, tA, idcentral );
vinf_arr    = norm(xxAtar(:,4:6) - vvga);
name_pl_arr = planetIdToName(idA, idcentral);
dv_arr      = struc(inds).dvA;

currentFolder = pwd;
if name(1) == '\' || name(1) == '/'
    title         = [currentFolder name];
else
    title         = [currentFolder '\' name];
end
out           = fopen(title,'w');

fprintf(out,'\n');

fprintf(out, '          _/_/_/     _/_/_/  _/_/_/_/_/  _/_/_/    _/_/_/ \n');
fprintf(out, '        _/    _/   _/           _/     _/    _/  _/    _/ \n');
fprintf(out, '       _/_/_/_/     _/_/       _/     _/_/_/    _/_/_/_/  \n');
fprintf(out, '      _/    _/         _/     _/     _/    _/  _/    _/   \n');       
fprintf(out, '     _/    _/    _/_/_/      _/     _/    _/  _/    _/    \n');     

fprintf(out,'\n');

fprintf(out,'\n');

fprintf(out,'               - ASTRA solution - \n');

fprintf(out,'\n');

fprintf(out,'-------------------------------------------------------------- \n');

fprintf(out,'\n');

fprintf(out,'             - Launch parameters - \n');

fprintf(out,'\n');

% ---- Write nice formatted block ----
fprintf(out, ['Launch at            : ' name_pl_launch '\n']);
fprintf(out, '   Date              : ['); fprintf(out, num2str(floor(mjd20002date(tD)), '%d')); fprintf(out, ']'); fprintf(out,'\n');
fprintf(out, '   Departing v_inf   : %8.4f km/s\n', vinf_dep);
fprintf(out, '   Right Ascension   : %8.4f deg\n', right_asc_degrees);
fprintf(out, '   Declination       : %8.4f deg\n', declination_degrees);
fprintf(out, '\n');

fprintf(out,'-------------------------------------------------------------- \n');

fprintf(out,'\n');

fprintf(out,'             - Flyby parameters - \n');

fprintf(out,'\n');

if ~isempty(FLYBYPARAM)
    
    for inds = 1:size(FLYBYPARAM,1)

        name_pl = planetIdToName(FLYBYPLANET(inds), idcentral);

        flyby_param = FLYBYPARAM(inds,:);
        
        vinf = flyby_param(1);
        ra   = flyby_param(2);
        dec  = flyby_param(3);
        bt   = flyby_param(4);
        br   = flyby_param(5);
        th   = flyby_param(6);

        % ---- Write nice formatted block ----
        fprintf(out, ['Flyby at             : ' name_pl '\n']);
        fprintf(out, '   Date              : ['); fprintf(out, num2str(floor(mjd20002date(FLYBYDATE(inds))), '%d')); fprintf(out, ']'); fprintf(out,'\n');
        fprintf(out, '   Incoming v_inf    : %8.4f km/s\n', vinf);
        fprintf(out, '   Right Ascension   : %8.4f deg\n', rad2deg(ra));
        fprintf(out, '   Declination       : %8.4f deg\n', rad2deg(dec));
        fprintf(out, '   BT                : %8.3f km\n', bt);
        fprintf(out, '   BR                : %8.3f km\n', br);
        fprintf(out, '   True anomaly      : %8.4f deg\n', rad2deg(th));
        fprintf(out, '   Periapsis alt     : %8.3f km\n', periapsis_altitude);
        fprintf(out, '\n');

    end

end

fprintf(out,'-------------------------------------------------------------- \n');

fprintf(out,'\n');

fprintf(out,'           - Arrival parameters - \n');

fprintf(out,'\n');

% ---- Write nice formatted block ----
fprintf(out, ['Arrival at           : ' name_pl_arr '\n']);
fprintf(out, '   Date              : ['); fprintf(out, num2str(floor(mjd20002date(tA)), '%d')); fprintf(out, ']'); fprintf(out,'\n');
fprintf(out, '   Arrival v_inf     : %8.4f km/s\n', vinf_arr);
% fprintf(out, '   Delta-v           : %8.4f km/s\n', dv_arr);

fprintf(out, '\n');

fprintf(out,'-------------------------------------------------------------- \n');

fprintf(out, '\n');

fclose(out);

end