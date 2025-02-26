function [date] = processDate(t)

% --> t is in mjd2000

date = mjd20002date(t);

D    = num2str(date(1:end-1));
D2   = num2str(date(end), '%.10f');
date = [D ' ' D2];

end