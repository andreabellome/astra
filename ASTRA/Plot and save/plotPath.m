function [fig, YY, TT, PLANETS, R, V] = plotPath(path)

% DESCRIPTION
% This function plots the trajectory of a spacecraft given a path matrix, 
% which includes information on position and velocity at different times.
% It also plots the orbits of planets and computes the distance and velocity 
% of the spacecraft relative to the Sun over time. Additionally, it determines 
% the positions of planets at specific times based on the provided path.
% 
% INPUT
% - path : Matrix where each row represents a leg of the trajectory and 
%          contains position and velocity vectors, time of flybys, and other
%          relevant information. Columns represent:
%          1-3  : Position vectors (x, y, z)
%          4-6  : Velocity vectors (vx, vy, vz)
%          7    : Planet ID
%          8    : Time of flyby (in seconds)
% 
% OUTPUT
% - fig      : Figure handle for the plot of the spacecraft trajectory and planets' orbits.
% - YY       : Matrix of spacecraft positions and velocities over time.
% - TT       : Vector of times corresponding to spacecraft positions.
% - PLANETS  : Structure array containing the positions of planets at various times.
% - R        : Vector of distances of the spacecraft from the Sun over time.
% - V        : Vector of velocities of the spacecraft over time.
% 
% PROCESS
% - Plot the orbits of planets based on the provided time range.
% - For each leg of the trajectory:
%   - Compute the spacecraft's trajectory by propagating its orbit.
%   - Plot the spacecraft's trajectory and mark the flyby points.
%   - Store the positions and velocities over time.
% - Compute the distance and velocity of the spacecraft relative to the Sun.
% - Determine the positions of planets at the times specified in the path matrix.
% - Update the plot legend to indicate the departing location and flyby points.
% 
% -------------------------------------------------------------------------

mu = 132724487690;
AU = 149597870.7;

PLTS = path(:,7);
TFBS = path(:,8);
DTS  = [0; diff(TFBS)];

%%%%% plot planets orbits %%%%%
t0   = path(1,8);
tend = path(end,8);
fig  = plotPLTS_tt(PLTS, t0, tend);
%%%%% plot planets orbits %%%%%

%%%%% plot trajectory %%%%%
YY = []; TT = [];
for NLEG = 2:size(path,1)
    
    RR  = path(NLEG, 1:3);
    VV  = path(NLEG, 4:6);
    
    [rr1, vv1] = FGKepler_dt(car2kep([RR VV], mu), -DTS(NLEG)*86400, mu); % backward propagation
    tt         = [0:1*86400:DTS(NLEG)*86400]';
    [~,yy]     = propagateKepler(rr1, vv1, tt, mu); % forward propagation

    if NLEG == 2
        hold on;
        plot3(yy(1,1)./AU, yy(1,2)./AU, yy(1,3)./AU, 'ks', 'markersize', 10);
    end
    
    if NLEG  == 2
        hold on;
        plot3(yy(:,1)./AU, yy(:,2)./AU, yy(:,3)./AU, 'b', 'linewidth', 2, 'handlevisibility', 'off');
        plot3(yy(end,1)./AU, yy(end,2)./AU, yy(end,3)./AU, 'ro', 'markersize', 8);
    else
        hold on;
        plot3(yy(:,1)./AU, yy(:,2)./AU, yy(:,3)./AU, 'b', 'linewidth', 2, 'handlevisibility', 'off');
        plot3(yy(end,1)./AU, yy(end,2)./AU, yy(end,3)./AU, 'ro', 'markersize', 8, 'handlevisibility', 'off');
    end
    
    YY = [YY; yy];
    if NLEG == 2
        TT = [TT; ((tt))];
    else
        TT = [TT; TT(end)+((tt))];
    end
    
end
%%%%% plot trajectory %%%%%

%%%%% distance and velocity w.r.t. time %%%%%
R = zeros(size(YY,1),1);
V = zeros(size(YY,1),1);
for indi = 1:size(YY,1)
    R(indi,1) = norm(YY(indi,1:3));
    V(indi,1) = norm(YY(indi,4:6)); 
end
%%%%% distance and velocity w.r.t. time %%%%%

%%%%% planets positions in the time considered %%%%%
tdep  = path(1,8);
TPLTS = TT./86400 + tdep;
PLTS  = unique(PLTS);
for indj = 1:length(PLTS)
    pl = PLTS(indj);
    PLANETS(indj).pl = pl;
    for indi = 1:length(TPLTS)
        PLANETS(indj).planet(indi,:) = EphSS_cartesian(pl, TPLTS(indi));
        PLANETS(indj).Tpl(indi,:) = TPLTS(indi);
    end
end
%%%%% planets positions in the time considered %%%%%

legend('Departing location', 'Flyby');
legend('Location', 'Best');

end