function [ date_mjd2000 ] = datetime_string_to_mjd2000( dt_str )

% DESCRIPTION
% This function converts a date-time string in ISO 8601 format 
% ('yyyy-MM-ddTHH:mm:ss.SSSSSS') into the corresponding Modified Julian 
% Date referenced to epoch J2000 (MJD2000). It is useful for converting 
% human-readable timestamps into a numerical format commonly used in 
% astrodynamics and orbital mechanics.
%
% INPUT
% - dt_str       : date-time string in the format 'YYYY-MM-DDTHH:MM:SS.SSSSSS'
%
% OUTPUT
% - date_mjd2000 : scalar value representing the Modified Julian Date 
%                  referenced to epoch J2000 (days since 01 Jan 2000 12:00 TT)
%
% -------------------------------------------------------------------------


vec          = datetime_string_to_vector(dt_str);
date_mjd2000 = date2mjd2000( vec );

end