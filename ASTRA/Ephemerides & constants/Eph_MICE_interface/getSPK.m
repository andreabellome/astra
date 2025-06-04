function [success] = getSPK(spk_id,date_i,date_f,spk_dir,varargin)%ovrwrt_flag,varargin)

% DESCRIPTION
% This function retrieves a Spacecraft and Planet Kernel (SPK) file from NASA's 
% Horizons API for a specified object and time range, saving it to a given directory.
% If a file with the same name already exists, the function either overwrites it 
% (if the overwrite flag is set) or stops execution with a warning.
%
% INPUT
% - spk_id  : string specifying the SPK ID of the target object.
% - date_i  : string specifying the start date for the SPK file in a format 
%             accepted by the Horizons API.
% - date_f  : string specifying the end date for the SPK file in a format 
%             accepted by the Horizons API.
% - spk_dir : string specifying the directory where the SPK file should be saved. 
%             If empty, the file is saved in the current directory.
% - varargin: optional parameters:
%             'overwrite', 'on'  -> Overwrites an existing SPK file.
%             'overwrite', 'off' -> Prevents overwriting (default).
%             'warning', 'on'    -> Displays a warning if the file exists (default).
%             'warning', 'off'   -> Suppresses warnings if the file exists.
%
% OUTPUT
% - success : binary flag indicating success (1) or failure (0) in retrieving and 
%             saving the SPK file.
%
% -------------------------------------------------------------------------


%% Create directory if needed
if isempty(spk_dir)
    spk_dir = '.';
else
    if ~exist(spk_dir,'dir')
        mkdir(spk_dir);
    end
end

%% Create full path with directory and file name

spk_path = [spk_dir '/' spk_id '.bsp'];

%% Check existence of the file.
% If overwrite active, delete the old file, else throw error.
if exist(spk_path,'file')
    if any(strcmp(varargin,'overwrite')) && strcmp(varargin{find(strcmp(varargin,'overwrite'))+1},'on')
        cspice_unload(spk_path);
        delete(spk_path)
    elseif ~any(strcmp(varargin,'overwrite')) || strcmp(varargin{find(strcmp(varargin,'overwrite'))+1},'off')
        if ~any(strcmp(varargin,'warning')) || strcmp(varargin{find(strcmp(varargin,'warning'))+1},'on')
            warning('File already existing, function stopping. If new download is desired, activate overwrite flag.')
            success = 1;
            return
        elseif strcmp(varargin{find(strcmp(varargin,'warning'))+1},'off')
            success = 1;
            return
        else
            error('Wrong command for the optional input "warning". Choose "on" or "off"')
        end
    else
        error('Wrong command for the optional input "overwrite". Choose "on" or "off"')
    end
end


%% Define API URL and SPK filename:
url = 'https://ssd.jpl.nasa.gov/api/horizons.api';


%% Build the appropriate URL for this API request:
% IMPORTANT: You must encode the "=" as "%3D" and the ";" as "%3B" in the
%            Horizons COMMAND parameter specification.

url_add_1 = '?format=json&EPHEM_TYPE=SPK&OBJ_DATA=NO';


% Substitute url space keyword to date strings
date_i = strrep(date_i,' ','%20');
date_f = strrep(date_f,' ','%20');

url_add_2 = ['&COMMAND=''DES%3D' spk_id '%3B''&START_TIME=''' date_i '''&STOP_TIME=''' date_f ''''];


request = matlab.net.http.RequestMessage;
response = send(request,[url url_add_1 url_add_2]);


% If the request was valid...
if strcmp(response.StatusCode,'OK')
    if isfield(response.Body.Data,'spk')
        % Normal case: SPK is found
        f = fopen(spk_path, "wb");
        fwrite(f,matlab.net.base64decode(response.Body.Data.spk));
        fclose('all');
        success = 1;
    elseif isfield(response.Body.Data,'result') && contains(response.Body.Data.result, 'Small-body Index Search Results')
        % Handle special case: index match returned
        lines = splitlines(response.Body.Data.result);
        record_lines = lines(contains(lines, spk_id));  % Or match by spk_id
        if isempty(record_lines)
            warning('No matching records found in index search.');
            success = 0;
            return
        end
        
        % Extract the most recent record number (last in list)
        last_line = strtrim(record_lines{end});
        tokens = regexp(last_line, '^\s*(\d+)', 'tokens');
        if isempty(tokens)
            warning('Failed to parse record number from index response.');
            success = 0;
            return
        end
        record_number = tokens{1}{1};  % Extracted record number
        
        % Build new request using record number
        url_add_2b = ['&COMMAND=''' record_number '''&START_TIME=''' date_i '''&STOP_TIME=''' date_f ''''];
        response2 = send(request, [url url_add_1 url_add_2b]);
        
        if strcmp(response2.StatusCode,'OK') && isfield(response2.Body.Data,'spk')
            f = fopen(spk_path, "wb");
            fwrite(f,matlab.net.base64decode(response2.Body.Data.spk));
            fclose('all');
            success = 1;
        else
            warning('Retry with record number failed.');
            success = 0;
        end
    else
        warning('Unknown response format. No SPK file retrieved.');
        success = 0;
    end
else
    error('Failed data retrieval from web. Check "request" data')
end



