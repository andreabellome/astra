function [figECI, STRUC, figSYN, figRSC, figVSC] = plotPath(path, idcentral, holdon, color, firstL)

% DESCRIPTION
% This function plots the trajectory of a spacecraft and the orbits of 
% planets along with various related plots. The spacecraft's trajectory 
% is based on the provided path data, which includes the state vectors at 
% different time points. The function also generates plots in both the 
% ECI (Earth-Centered Inertial) and Synodic reference frames, as well as 
% plots of distance and velocity over time.
% 
% INPUT
% - path      : Nx8 matrix where each row contains the state vector of the 
%               spacecraft at a given time. Columns represent position and 
%               velocity in ECI frame, as well as time and planet IDs.
% - idcentral : ID of the central body. See constants.m
% - holdon    : optional flag to determine if the current figure should be 
%               held for additional plotting. Default is 0 (create new figure).
% - color     : optional color for the trajectory plot. Default is 'b' (blue).
% - firstL    : optional flag to highlight the departure condition. Default 
%               is 1 (highlight).
% 
% OUTPUT
% - figECI : handle to the figure showing the spacecraft trajectory and 
%            planets' orbits in the ECI frame.
% - STRUC  : structure containing trajectory and planet data including:
%            - StatesSC : spacecraft states in ECI frame
%            - EpochsSC : time epochs corresponding to spacecraft states
%            - TOFsSC   : time of flight between waypoints
%            - DistSC   : distance from the Sun over time
%            - VelSC    : spacecraft velocity over time
%            - SatesScFB : state vectors at flyby points
%            - EpochsScFB : epochs of flyby points
%            - Planets  : structure array of planets' states in the ECI and 
%              Synodic frames
% - figSYN : handle to the figure showing the spacecraft trajectory and 
%            planets' orbits in the Synodic frame.
% - figRSC : handle to the figure showing the distance from the Sun over 
%            time.
% - figVSC : handle to the figure showing the spacecraft velocity over time.
% 
% -------------------------------------------------------------------------


if nargin == 1
    idcentral = 1;
    holdon = 0;   % --> open new figure
    color  = 'b'; % --> blue trajectory
    firstL = 1;   % --> highlight departing condition
elseif nargin == 2
    holdon = 0;   % --> open new figure
    color  = 'b'; % --> blue trajectory
    firstL = 1;   % --> highlight departing condition
elseif nargin == 3
    color = 'b';
    firstL = 1;
elseif nargin == 4
    firstL = 1;
end

mu = constants(idcentral,1);
if idcentral == 1
    AU = 149597870.7;
else
    [~, AU] = planetConstants(idcentral);
end

PLTS = path(:,7);
TFBS = path(:,8);
DTS  = [0; diff(TFBS)];

%%%%% plot planets orbits %%%%%
t0     = path(1,8);
tend   = path(end,8);
figECI = plotPLTS_tt(PLTS, t0, tend, idcentral, holdon);
%%%%% plot planets orbits %%%%%

%%%%% plot trajectory %%%%%
YY = []; TT = [];
for NLEG = 2:size(path,1)
    
    RR  = path(NLEG, 1:3);
    VV  = path(NLEG, 4:6);
    
    [rr1, vv1] = FGKepler_dt(car2kep([RR VV], mu), -DTS(NLEG)*86400, mu); % backward propagation
    tt         = linspace( 0, DTS(NLEG)*86400, 5e3 )';
    [~,yy]     = propagateKepler(rr1, vv1, tt, mu); % forward propagation

    if firstL == 1
        if NLEG == 2
            hold on;
            plot3(yy(1,1)./AU, yy(1,2)./AU, yy(1,3)./AU,...
                's', 'MarkerSize', 10, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Cyan', 'DisplayName', 'Departure');
        end
    end
    
    if NLEG  == 2
        hold on;
        plot3(yy(:,1)./AU, yy(:,2)./AU, yy(:,3)./AU, 'Color', color, 'linewidth', 2, 'HandleVisibility', 'Off');
        if holdon == 0
            plot3(yy(end,1)./AU, yy(end,2)./AU, yy(end,3)./AU, ...
                'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Red', 'DisplayName', 'Fly-by');
        else
            plot3(yy(end,1)./AU, yy(end,2)./AU, yy(end,3)./AU, ...
                'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Red', 'HandleVisibility', 'Off');
        end
    else
        hold on;
        plot3(yy(:,1)./AU, yy(:,2)./AU, yy(:,3)./AU,...
            'Color', color, 'linewidth', 2, 'HandleVisibility', 'Off');
        plot3(yy(end,1)./AU, yy(end,2)./AU, yy(end,3)./AU,...
            'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Red', 'HandleVisibility', 'Off');
    end
    
    YY = [YY; yy];
    if NLEG == 2
        TT = [TT; ((tt))];
    else
        TT = [TT; TT(end)+(tt)];
    end
    
end
TT = path(1,8) + TT./86400;
%%%%% plot trajectory %%%%%

%%%%% distance and velocity w.r.t. time %%%%%
R = vecnorm(YY(:,1:3)')';
V = vecnorm(YY(:,4:6)')';
%%%%% distance and velocity w.r.t. time %%%%%

%%%%% planets positions in the time considered %%%%%
TPLTS = TT;
PLTS  = unique(PLTS);
for indj = 1:length(PLTS)
    pl               = PLTS(indj);
    PLANETS(indj).pl = pl;
    for indi = 1:length(TPLTS)
        [rr, vv]                           = EphSS_cartesian(pl, TPLTS(indi), idcentral);
        PLANETS(indj).statesPL_ECI(indi,:) = [rr, vv];
        PLANETS(indj).Tpl(indi,:)          = TPLTS(indi);
    end
    [statesPL_SYN]             = wrapECI2Synodic_SE(PLANETS(indj).statesPL_ECI, PLANETS(indj).Tpl, idcentral);
    PLANETS(indj).statesPL_SYN = statesPL_SYN;
end
%%%%% planets positions in the time considered %%%%%

%%%%% save the results %%%%%
STRUC.StatesSC = YY;
STRUC.EpochsSC = TT;
STRUC.TOFsSC   = [0; TT(2:end) - TT(1)];
STRUC.DistSC   = R;
STRUC.VelSC    = V;

STRUC.SatesScFB  = path(:,1:6);
STRUC.EpochsScFB = path(:,8);

STRUC.Planets    = PLANETS;

% --> from ECLIPTIC J2000 to SUN-EARTH SYNODIC reference frame
[statesSC_SYN] = wrapECI2Synodic_SE(STRUC.StatesSC, STRUC.EpochsSC, idcentral);
[statesPL_SYN] = wrapECI2Synodic_SE(STRUC.SatesScFB, STRUC.EpochsScFB, idcentral);

STRUC.StatesSC_syn   = statesSC_SYN;
STRUC.StatesScFB_syn = statesPL_SYN;

%%%%% save the results %%%%%

if nargout >= 3

    figSYN = figure( 'Color', [1 1 1] );
    hold on; grid on; axis equal;
    xlabel('x [adim]'); ylabel('y [adim]'); zlabel('z [adim]');
    
    plot3(STRUC.StatesSC_syn(:,1), STRUC.StatesSC_syn(:,2), STRUC.StatesSC_syn(:,3), 'b', 'LineWidth', 2, 'HandleVisibility', 'off');
    
    plot3( STRUC.StatesScFB_syn(2:end,1), STRUC.StatesScFB_syn(2:end,2), STRUC.StatesScFB_syn(2:end,3), ...
        'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Red', 'DisplayName', 'Fly-by');
    plot3( STRUC.StatesScFB_syn(1,1), STRUC.StatesScFB_syn(1,2), STRUC.StatesScFB_syn(1,3), ...
        's', 'MarkerSize', 10, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Cyan', 'DisplayName', 'Departure');
    
    for indpl = 1:length(STRUC.Planets)
        plot3(STRUC.Planets(indpl).statesPL_SYN(:,1), STRUC.Planets(indpl).statesPL_SYN(:,2), STRUC.Planets(indpl).statesPL_SYN(:,3), ...
            'k', 'linewidth', 0.5, 'HandleVisibility', 'Off');
    end

    labelsDim = 16;
    axesDim   = 16;
    set(findall(figSYN,'-property','FontSize'), 'FontSize',labelsDim)
    h = findall(figSYN, 'type', 'text');
    set(h, 'fontsize', axesDim);
    ax          = gca; 
    ax.FontSize = axesDim; 

    if nargout >= 4


        figRSC = figure( 'Color', [1 1 1] );
        hold on; grid on;
        xlabel('Days from launch'); ylabel('Sun-spacecraft distance [AU]');

        plot(STRUC.TOFsSC, STRUC.DistSC./AU, 'b', 'linewidth', 2, 'HandleVisibility', 'off');
        
        distfb = vecnorm( STRUC.SatesScFB(:,1:3)' )';
        toffb  = [ 0; STRUC.EpochsScFB(2:end) - STRUC.EpochsScFB(1) ];

        plot(toffb(1), distfb(1)./AU, ...
            's', 'MarkerSize', 10, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Cyan', 'DisplayName', 'Departure');

        plot(toffb(2:end), distfb(2:end)./AU, ...
            'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Red', 'DisplayName', 'Fly-by');

        if nargout == 5
            figVSC = figure( 'Color', [1 1 1] );
            hold on; grid on;
            xlabel('Days from launch'); ylabel('Spacecraft velocity - km/s');

            plot(STRUC.TOFsSC, STRUC.VelSC, 'b.', 'MarkerSize', 5, 'HandleVisibility', 'off');

            velfb = vecnorm( STRUC.SatesScFB(:,4:6)' )';
            toffb = [ 0; STRUC.EpochsScFB(2:end) - STRUC.EpochsScFB(1) ];

            plot(toffb(1), velfb(1), ...
                's', 'MarkerSize', 10, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Cyan', 'DisplayName', 'Departure');

            plot(toffb(2:end), velfb(2:end), ...
                'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Red', 'DisplayName', 'Fly-by');

        end

        labelsDim = 16;
        axesDim   = 16;
        set(findall(figRSC,'-property','FontSize'), 'FontSize',labelsDim)
        h = findall(figRSC, 'type', 'text');
        set(h, 'fontsize', axesDim);
        ax          = gca; 
        ax.FontSize = axesDim; 

    end

end

end
