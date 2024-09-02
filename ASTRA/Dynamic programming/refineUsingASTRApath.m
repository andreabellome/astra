function [OUTPUTref] = refineUsingASTRApath(path, INPUT)

% DESCRIPTION
% This function refines a given trajectory path using the ASTRA tool by searching for
% nearby trajectories with a finer grid resolution. The refined search is performed 
% around the specified initial path parameters.
% 
% INPUT
% - path   : Matrix containing the trajectory path to be refined. Includes information 
%            on sequence, initial time, time of flights, and other relevant parameters.
% - INPUT  : Struct containing various input parameters for the refinement process, 
%            including time windows, step sizes, revolution options, and resolution settings.
% 
% OUTPUT
% - OUTPUTref : Struct containing the refined trajectory information obtained from ASTRA. 
%               This includes the optimal trajectory parameters based on the finer search grid.
% 
% -------------------------------------------------------------------------


seq  = path(:,7)';
t0   = path(1,8);
tofs = path(2:end,11)';

t0days  = INPUT.t0days;
tofdays = INPUT.tofdays;
dt      = INPUT.dt;
revs    = INPUT.revs;
res     = INPUT.res;

t0min  = t0 - t0days;
t0max  = t0 + t0days;
tofmin = ( tofs - tofdays ).* ( ( tofs - tofdays ) >= 0 );
tofmax = ( tofs + tofdays );

INPUT.opt          = 1;
INPUT.vInfOpts     = [max([path(1,9)-0.5 min(INPUT.vInfOpts)]) min([path(1,9)+0.5 max(INPUT.vInfOpts)])];
INPUT.dsmOpts      = [max(path(:,10)) Inf];    % --> max defect DSM, and total DV (km/s)
INPUT.plot         = [0 0];      % --> plot(1) for pareto front, plot(2) for best traj.
INPUT.tstep        = dt;
INPUT.TOF_LIM      = [tofmin' tofmax']; % --> TOF limits per leg (days)
INPUT.chosenRevs   = revs;
INPUT.res          = res;
INPUT.depOpts      = [t0min t0max dt];

% --> solve using ASTRA
OUTPUTref = ASTRA_DP(seq, INPUT);

end
