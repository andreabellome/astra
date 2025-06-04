function vec = datetime_string_to_vector(dt_str)

% DESCRIPTION
% This function converts a date-time string in ISO 8601 format 
% ('yyyy-MM-ddTHH:mm:ss.SSSSSS') into a numerical vector of six elements 
% representing year, month, day, hour, minute, and second. It is useful 
% when date components are required in numerical form for further 
% computations or analysis.
%
% INPUT
% - dt_str : date-time string in the format 'YYYY-MM-DDTHH:MM:SS.SSSSSS'
%
% OUTPUT
% - vec    : 1x6 numerical vector [YYYY MM DD HH MM SS]. The seconds value 
%            is returned as an integer if it has no decimal part.
%
% -------------------------------------------------------------------------


% Convert string to datetime
dt = datetime(dt_str, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss.SSSSSS');

% Extract components
vec = [year(dt), month(dt), day(dt), hour(dt), minute(dt), second(dt)];

% Ensure second is an integer if it's whole
if mod(vec(6), 1) == 0
    vec(6) = int32(vec(6));
end

end