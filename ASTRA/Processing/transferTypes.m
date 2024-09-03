function [TYPES, STATES, fig] = transferTypes(path, idcentral)

% DESCRIPTION :
% given a path from ASTRA output, find the transfer types (OO, OI, IO, II).
%
% INPUT : 
% - path      : MGA transfer as coming from ASTRA outputù
% - idcentral : ID of the central body
%
% OUTPUT :
% - TYPES  : matrix containing the follwing info : 
%            - TYPES(:,1) : departing planet
%            - TYPES(:,2) : arrival planet
%            - TYPES(:,3:4) : transfer type (88=OO, 81=OI, 18=IO, 11=II) 
% - STATES : matrix containing the following info :
%            - STATES(:,1)    : departing planet
%            - STATES(:,2)    : arrival planet
%            - STATES(:,3:8)  : SC state after the flyby with the dep. planet
%            - STATES(:,9:14) : SC state after the flyby with the arr. planet
%
% -------------------------------------------------------------------------

if nargin == 1
    idcentral = 1;
end

mu = constants(idcentral, 1);
if idcentral == 1
    AU = 149597870.7;
else
    [~, AU] = planetConstants(idcentral);
end

dep_pls = path(1:end-1,7);
arr_pls = path(2:end,7);

legs   = [dep_pls, arr_pls];

states      = zeros(size(path,1)-1,12);
states(1,:) = [path(1,1:6) path(2,1:6)];
for indi = 2:size(path,1)-1
       state_in = path(indi+1,1:6); % --> SC state at the next planet
       [~,state_ou] = propagateKepler(state_in(1:3), state_in(4:6), -(path(indi+1,11))*86400, mu);
       states(indi,:) = [state_ou state_in];
end

% --> save the states
STATES = [legs states];

% --> find the true anomaly at the encounters
TYPES = zeros(size(STATES,1),6);
for inds = 1:size(STATES,1)
    
    pl_ou = STATES(inds,1);
    pl_in = STATES(inds,2);
    
    kep_ou = car2kep(STATES(inds,3:8),mu);
    kep_in = car2kep(STATES(inds,9:14),mu);
    
    th_ou = kep_ou(6); % --> SC anomaly after the flyby with the dep. planet
    th_in = kep_in(6); % --> SC anomaly after the flyby with the arr. planet
    
    if th_ou >= 0 && th_ou <= pi
        type_ou = 8;
    else
        type_ou = 1;
    end
    
    if th_in >= 0 && th_in <= pi
        type_in = 8;
    else
        type_in = 1;
    end

    TYPES(inds,:) = [type_ou type_in th_ou th_in rad2deg(th_ou) rad2deg(th_in)];
end
TYPES = [STATES(:,1:2) TYPES];

if nargout > 2
    % --> plot the traj. to double check
    t0   = path(1,8);
    tend = path(end,8);
    fig  = plotPLTS_tt(path(:,7), t0, tend);
    tofs = path(2:end,11);
    for inds = 1:size(STATES,1)

        rr1 = STATES(inds,3:5);
        vv1 = STATES(inds,6:8);
        dt  = tofs(inds,1)*86400;
        tt  = [0:1*86400:dt]';
        hold on;
        [~,yy] = propagateKepler(rr1, vv1, tt, mu); % forward propagation
        plot3(yy(:,1)./AU, yy(:,2)./AU, yy(:,3)./AU, 'linewidth', 2, 'handlevisibility', 'off');
    end
end

end