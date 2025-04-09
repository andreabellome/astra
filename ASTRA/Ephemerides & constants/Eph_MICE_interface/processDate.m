function [date] = processDate(t)

% DESCRIPTION
% This function converts an input time expressed in Modified Julian Date
% 2000 (MJD2000) into a formatted date string compatible with the NASA
% NAIF MICE Toolkit. It is primarily used for trajectory design problems
% involving multiple gravity assists.
%
% INPUT
% - t    : time in Modified Julian Date 2000 (MJD2000)
%
% OUTPUT
% - date : formatted date string 'YYYY MM DD HH.mmssssssss' (TDB time scale)
%          to be passed to SPICE functions such as cspice_str2et
%
% -------------------------------------------------------------------------


date = mjd20002date(t);

D    = num2str(date(1:end-1));
D2   = num2str(date(end), '%.10f');
date = [D ' ' D2];

end