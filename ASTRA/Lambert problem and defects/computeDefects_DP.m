function [legn, vvf, vinff] = computeDefects_DP(legprev, vasprev, pl2, t2,...
    vv1, vv2, vvd, vva, dvLim, muPL, rpmin)

% DESCRIPTION:
% This function computes the "defects" in a trajectory optimization problem. 
% It calculates changes in velocity (delta-V) and assesses whether these changes are within acceptable limits.
% 
% INPUTS:
% legprev : Matrix where each row represents a previous trajectory leg with details of the planets and times involved.
% vasprev : Matrix of velocity vectors at the start of the previous legs.
% pl2     : Identifier for the target planet of the current leg.
% t2      : Time of arrival at the target planet.
% vv1     : Velocity vector at the departure from the initial planet.
% vv2     : Velocity vector at the arrival at the target planet.
% vvd     : Velocity vector required for the current leg's trajectory.
% vva     : Velocity vector of the spacecraft at the end of the current leg.
% dvLim   : Maximum allowed change in delta-V for the current leg.
% muPL    : Gravitational parameter of the planet for the current leg.
% rpmin   : Minimum allowed flyby altitude during the leg.
% 
% OUTPUTS:
% legn   : Updated trajectory legs including computed delta-V values, target planet, and arrival time.
% vvf    : Updated velocity vectors of the spacecraft at the end of the current leg.
% vinff  : Final velocity vector norm after the end of the current leg.
% 
% FUNCTION CALLS:
% vecnorm   : Computes the norm (magnitude) of vectors.
% findDV_mex : Computes the delta-V required for the trajectory optimization, using a mex function for performance.
% 
% -------------------------------------------------------------------------

% --> compute the DEFECTS
vvrel_A   = vasprev - vv1;
vrel_A    = vecnorm(vvrel_A')';
vvrel_D   = vvd - vv1;
vrel_D    = norm(vvrel_D);
dvapp     = abs( vrel_D - vrel_A );
indxs_app = (dvapp <= dvLim);
dv        = dvapp;
if ~isempty(find(indxs_app == 1,1))
    for indlp = 1:size(legprev,1)
        if indxs_app(indlp)
            dv(indlp,:) = findDV_mex(vvrel_A(indlp,:), vvrel_D, muPL, rpmin);
        end
    end
end
vvf   = vva.*ones( size(dv,1) , 3 );
vinff = norm( vva - vv2 ).*ones( size(dv,1) , 1);
legn  = [ legprev [dv pl2.*ones(size(dv,1),1) t2.*ones(size(dv,1),1)]];

end
