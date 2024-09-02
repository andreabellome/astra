function [OUTPUT] = ASTRA_DP(seq, INPUT)

% DESCRIPTION :
% This is a wrapper for all ASTRA functionalities.
% 
% INPUT :
% seq      : vector with planets IDs in the MGA sequence
% INPUT    : structure with the following mandatory fields:
%                - chosenRevs : 
%                - res        : vector with N:M resonant ratio and number
%                of leg at which the resonant transfer is needed. If no
%                resonant transfer is needed, leave it empty. E.g. EVEMMMJ
%                with 2:1 and 3:1 on MM legs would have:
%                res = [ 2 1 4 3 1 5 ], where 4 and 5 are the legs in which
%                the 2:1 and 3:1 occurr. 
%                - depOpts    : 1x2 vector. depOpts(1) is for initial date
%                range (MJD2000), depOpts(2) is for final date range
%                (MJD2000), and depOpts(3) is for step size (days)
%                - opt        : (1) is for SODP, (2) is for MODP, (3) is
%                for DATES, (4) is for YEARS - MODP 
%                - vInfOpts   : min/max departing infinity velocities (km/s)
%                - dsmOpts    : max defect DSM (km/s), and total DSMs (km/s)
%                - plot       : 1x2 vector. plot(1) is for plotting the
%                best DV trajectory, plot(2) is for plotting the Pareto
%                front. Please put plot(i)=1 if you want to plot the results. 
%                - parallel   : if 1, then parallel computing is used
%                - tstep      : (days) discretization time step
% tofs  : vector with time of fligth for each leg of the sequence (days)
% NREVS : nx3 matrix (n=length(seq)-1) on which the multiple revolutions
%         options are passed. If NREVS(i,3)~=0, then a resonance is
%         included in the transfer.
%
% OUTPUT :
% path : is the path matrix
% fig  : if requested by the user, a figure with the trajectory is returned
%
% -------------------------------------------------------------------------


clc;

% --> check parallel pool
if INPUT.parallel == true
    try
        parpool
    catch
    end
end

if ( INPUT.depOpts(2) - INPUT.depOpts(1) )/365.25 >= 3 && INPUT.opt == 2
    INPUT.opt = 4;
elseif ( INPUT.depOpts(2) - INPUT.depOpts(1) )/365.25 >= 3 && INPUT.opt == 1
    INPUT.opt = 5;
end

% --> run ASTRA
if INPUT.opt == 1 % --> 1.SODP
    OUTPUT = ASTRA_SODP_v2(INPUT, seq);
elseif INPUT.opt == 2 % --> 2.MODP
    OUTPUT = ASTRA_MODP_v2(INPUT, seq);
elseif INPUT.opt == 3 % --> 3.DATES w. SODP
    OUTPUT = ASTRA_dates(INPUT, seq);
elseif INPUT.opt == 4 % --> 4.YEARS w. MODP
    OUTPUT = ASTRA_years(seq, INPUT);
elseif INPUT.opt == 5 % --> 5.YEARS w. SODP
    
end

% --> post-process
try
    res = OUTPUT(1).res;
    for indo = 1:length(OUTPUT)
        OUTPUT(indo).res = res;
    end
catch
end

end
