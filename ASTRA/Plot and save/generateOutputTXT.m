function [out] = generateOutputTXT(path, idcentral, folder, nametemp)

% DESCRIPTION
% This function generates a text file containing detailed information about 
% a trajectory path, including departure and arrival planets, v-infinity 
% velocities, transfer types, and additional trajectory metrics.
% 
% INPUT
% - path   : Matrix where each row represents a state in the trajectory with 
%            columns for position (x, y, z), velocity (vx, vy, vz), 
%            planetary ID, time, and v-infinity information.
% - folder : (Optional) Directory path where the output text file will be saved.
%            If not specified, the file is saved in the "results" folder or 
%            created if it doesn't exist.
% - nametemp : (Optional) Name of the output text file. If not specified, 
%              a default name based on the trajectory sequence is used.
% 
% OUTPUT
% - out    : A file handle to the created text file containing the trajectory 
%            details and metrics formatted as specified.
% 
% -------------------------------------------------------------------------

if nargin == 1
    idcentral = 1;
    if exist('results','dir') == 7 % --> the folder exists on the current path
    else % --> the folder does not exist on the current path
        mkdir('results');
    end
end

% --> variables and constants
if idcentral == 1
    AU = 149597870.7;
else
    [~, AU] = planetConstants(idcentral);
end
plts = path(:,7);

% --> dep./arr. infinity velocities at each planet
[VINFS, vvd, vva, rrd, rra] = path2Vinfs(path, idcentral);

% --> transfer types per leg
[TYPES] = transferTypes(path, idcentral);

% --> write the sequence name
seqName = seq2SeqName(plts, idcentral);

% --> managing the inputs related to saving folder
if nargin == 1 % --> the user has not specified the folder

    if exist('results','dir') == 7 % --> the folder exists on the current path
        name = ['\results\ASTRA_result_' seqName '.txt'];
    else % --> the folder does not exist on the current path
        mkdir('results');
        name = ['\results\ASTRA_result_' seqName '.txt'];
    end

elseif nargin == 2 % --> the user has specified the folder

    if exist('results','dir') == 7 % --> the folder exists on the current path
        name = ['\results\ASTRA_result_' seqName '.txt'];
    else % --> the folder does not exist on the current path
        mkdir('results');
        name = ['\results\ASTRA_result_' seqName '.txt'];
    end
elseif nargin == 3
    if isempty(folder) % --> the user has not specified the folder
        if exist('results','dir') == 7 % --> the folder exists on the current path
            name = ['\results\ASTRA_result_' seqName '.txt'];
        else % --> the folder does not exist on the current path
            mkdir('results');
            name = ['\results\ASTRA_result_' seqName '.txt'];
        end
    else
        if exist(folder(2:end), 'dir') == 7 % --> the folder exists on the current path
            name = [folder '\ASTRA_result_' seqName '.txt'];
        else % --> the folder does not exist on the current path
            mkdir(folder(2:end));
            name = [folder '\ASTRA_result_' seqName '.txt'];
        end
    end
elseif nargin == 4 % --> the user has specified the folder AND the file name

    if isempty(nametemp) % --> the user has not specified the file name
        nametemp = [ 'ASTRA_result_' seqName '.txt' ];
    end
    if isempty(folder) % --> the user has not specified the folder
        if exist('results','dir') == 7 % --> the folder exists on the current path
            name = ['\results\' nametemp '.txt'];
        else % --> the folder does not exist on the current path
            mkdir('results');
            name = ['\results\' nametemp '.txt'];
        end
    else
        if exist(folder(2:end), 'dir') == 7 % --> the folder exists on the current path
            name = [folder '\' nametemp '.txt'];
        else % --> the folder does not exist on the current path
            mkdir(folder(2:end));
            name = [folder '\' nametemp '.txt'];
        end
    end

end

currentFolder = pwd;
title         = [currentFolder name];

out = fopen(title,'w');

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

[~, ~, rpl1] = constants(idcentral, plts(1));
[~, ~, rplf] = constants(idcentral, plts(end));

fprintf(out,['Departing body                 : ' planetIdToName(plts(1), idcentral) '\n']);
if idcentral == 1
    fprintf(out,'Distance from the central body : %.4f AU \n', rpl1/AU);
elseif idcentral == 5
    fprintf(out,'Distance from the central body : %.4f Rj \n', rpl1/AU);
elseif idcentral == 6
    fprintf(out,'Distance from the central body : %.4f Rs \n', rpl1/AU);
elseif idcentral == 7
    fprintf(out,'Distance from the central body : %.4f Ru \n', rpl1/AU);
end

fprintf(out,'\n');

fprintf(out,'-------------------------------------------------------------- \n');

fprintf(out,'\n');

fprintf(out,['Arrival body                   : ' planetIdToName(plts(end), idcentral) '\n']);

if idcentral == 1
    fprintf(out,'Distance from the central body : %.4f AU \n', rplf/AU);
elseif idcentral == 5
    fprintf(out,'Distance from the central body : %.4f Rj \n', rplf/AU);
elseif idcentral == 6
    fprintf(out,'Distance from the central body : %.4f Rs \n', rplf/AU);
elseif idcentral == 7
    fprintf(out,'Distance from the central body : %.4f Ru \n', rplf/AU);
end

fprintf(out,'Departing C3                   : %.4f km^2/s^2 \n', path(1,9)^2);
fprintf(out,'Departing infinity velocity    : %.4f km/s \n', path(1,9));
fprintf(out,'Arrival infinity velocity      : %.4f km/s \n', path(end,9));
fprintf(out,'Total cost (DSMs)              : %.4f km/s \n', sum(path(:,10)));
fprintf(out,'Total cost                     : %.4f km/s \n', path(1,9)+path(end,9) + sum(path(:,10)));
fprintf(out,'Time of flight                 : %.4f years \n', path(1,16));

fprintf(out,'\n');

fprintf(out,'-------------------------------------------------------------- \n');

fprintf(out,'\n');

fprintf(out, 'MGA Details : \n');

fprintf(out,'\n');

fprintf(out, 'Swing-by sequence      : ');
fprintf(out, generateOutputSequenceTXT(path, idcentral)); fprintf(out,'\n');

fprintf(out,'\n');

fprintf(out, 'Departing date         : ['); fprintf(out, num2str(floor(mjd20002date(path(1,8))), '%d')); fprintf(out, ']'); fprintf(out,'\n');
fprintf(out, 'Arrival date           : ['); fprintf(out, num2str(floor(mjd20002date(path(end,8))), '%d')); fprintf(out, ']'); fprintf(out,'\n');
DTS = diff(path(:,8));
fprintf(out, ['Time of flight per leg : ' num2str(DTS(1)) ' days \n']);
for indi = 2:size(path,1)-1
fprintf(out, ['                         ' num2str(DTS(indi)) ' days \n']);
end

fprintf(out,'\n');

fprintf(out, ['DSMs magnitudes        : ' num2str(path(1,10)) ' km/s \n']);
for indi = 2:size(path,1)
fprintf(out, ['                         ' num2str(path(indi,10)) ' km/s \n']);
end

fprintf(out,'\n');

fprintf(out, 'Infinity velocities    : \n');
for indi = 1:size(VINFS,1)
    name_pl_1 = planetIdToName(VINFS(indi,1), idcentral);
    name_pl_2 = planetIdToName(VINFS(indi,2), idcentral);
    vinf_pl_1 = VINFS(indi,3);
    vinf_pl_2 = VINFS(indi,4);
    
    fprintf(out, [name_pl_1 ' - ' name_pl_2 '      : '  num2str(vinf_pl_1) ' - ' num2str(vinf_pl_2) ' km/s \n']);
end

fprintf(out,'\n');

fprintf(out, 'State at departure/arrival (km and km/s) : \n');
for indi = 1:size(VINFS,1)
    name_pl_1 = planetIdToName(VINFS(indi,1), idcentral);
    name_pl_2 = planetIdToName(VINFS(indi,2), idcentral);

    fprintf(out, [name_pl_1 '                       : '  '[' num2str([rrd(indi,:) vvd(indi,:)]) ']' '  \n']);
    fprintf(out, [name_pl_2 '                       : '  '[' num2str([rra(indi,:) vva(indi,:)]) ']' '  \n']);

    fprintf(out,'\n');

end

fprintf(out, 'Encounter dates        : \n');
for indp = 1:size(path,1)
    name_pl_1 = planetIdToName(path(indp,7));
    fprintf(out, [name_pl_1 '                : [']); fprintf(out, num2str(floor(mjd20002date(path(indp,8))), '%d')); fprintf(out, ']'); fprintf(out,'\n');    
end

fprintf(out,'\n');

fprintf(out, 'Transfer types         : \n');
for indi = 1:size(TYPES,1)
   
    name_pl_1 = planetIdToName(TYPES(indi,1), idcentral);
    name_pl_2 = planetIdToName(TYPES(indi,2), idcentral);
    
    if TYPES(indi,3) == 8
        type_1 = 'outbound';
    else
        type_1 = 'inbound';
    end
    if TYPES(indi,4) == 8
        type_2 = 'outbound';
    else
        type_2 = 'inbound';
    end
    
    fprintf(out, [name_pl_1 ' - ' name_pl_2 '      : '  type_1 ' - ' type_2 ' \n']);
    
end

fprintf(out,'\n');


fprintf(out,'-------------------------------------------------------------- \n');

fprintf(out,'\n');

fclose(out);

end