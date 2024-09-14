function [mjd] = date2mjd( date )

% DESCRIPTION:
% Gregorian calendar date to modified Julian day number.
%
% mjd = date2mjd(date) returns the modified Julian day
% number from Gregorian calendar date (year, month, day, hour, minute, and
% second) 
%
% Note: Since this function calls jd2date, MJD cannot be less than 
%       -2400000.5, that is 24 November -4713, 12:00 noon, Gregorian
%       proleptic calendar.
%
% INPUT
%   date        Date in the Gregorian calendar, as a 6-element vector
%               [year, month, day, hour, minute, second]. For dates before
%               1582, the resulting date components are valid only in the
%               Gregorian proleptic calendar. This is based on the
%               Gregorian calendar but extended to cover dates before its
%               introduction.
% OUTPUT
%   mjd         Date in modified Julian Day. The MJD count is from 00:00
%               midnight at the beginning of Wednesday November 17, 1858.
%               It must be a real greater or equal than -2400000.5.
%

mjd = mjd20002mjd( date2mjd2000(date) );

end