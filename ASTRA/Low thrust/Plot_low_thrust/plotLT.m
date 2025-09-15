function [figTRAJ, figMASS, figTHRmag] = plotLT( transfer, param, holdon )

% DESCRIPTION
% This function plots the trajectory, mass evolution, and thrust magnitude
% for a low-thrust space trajectory. Depending on the number of requested 
% output arguments, the function generates up to three figures:
% - Trajectory in 3D space
% - Mass evolution over time
% - Thrust magnitude over time
%
% INPUT
% - transfer: Matrix containing trajectory and associated parameters:
%   - Column 1  : Time [days]
%   - Columns 2-4: Position (x, y, z) [km]
%   - Columns 5-7: Velocity (vx, vy, vz) [km/s]
%   - Column 8  : Spacecraft mass [kg]
%   - Column 9  : Thrust magnitude [N]
% - param: Structure containing simulation parameters:
%   - param.AU: Astronomical Unit [km], used to scale positions to AU
%
% OUTPUT
% - figTRAJ   : Figure handle for the trajectory plot
% - figMASS   : Figure handle for the mass evolution plot (optional)
% - figTHRmag : Figure handle for the thrust magnitude plot (optional)
%
% -------------------------------------------------------------------------

if nargin == 2
    holdon = 0;
end

if nargout == 1 || nargout == 0
    if holdon == 0
        figTRAJ = figure( 'Color', [1 1 1] );
    else
        figTRAJ       = gcf;
        figTRAJ.Color = [ 1 1 1 ];
    end
    hold on; grid on; axis equal;
    xlabel( 'x [AU]' ); ylabel( 'y [AU]' ); zlabel( 'z [AU]' );
elseif nargout == 2
    figTRAJ = figure( 'Color', [1 1 1] );
    hold on; grid on; axis equal;
    xlabel( 'x [AU]' ); ylabel( 'y [AU]' ); zlabel( 'z [AU]' );

    figMASS = figure( 'Color', [1 1 1] );
    hold on; grid on;
    xlabel('time [days]'); ylabel('mass [kg]');
elseif nargout == 3
    figTRAJ = figure( 'Color', [1 1 1] );
    hold on; grid on; axis equal;
    xlabel( 'x [AU]' ); ylabel( 'y [AU]' ); zlabel( 'z [AU]' );

    figMASS = figure( 'Color', [1 1 1] );
    hold on; grid on;
    xlabel('time [days]'); ylabel('mass [kg]');

    figTHRmag = figure( 'Color', [1 1 1] );
    hold on; grid on;
    xlabel('time [days]'); ylabel('Thrust [N]');
end

AU    = param.AU;
tt    = transfer(:,1);
yy    = transfer(:,2:7);
mm    = transfer(:,8);
thMag = transfer(:,9);

if nargout == 1
    
    % --> start: plot the trajectory
    figure(figTRAJ);
    
    plot3(0, 0, 0, 'o', 'markersize', 10, ...
        'MarkerEdgeColor', 'Black', ...
        'MarkerFaceColor', 'Yellow', ...
        'handlevisibility', 'off');
    
%     plot3(yy(:,1)./AU, yy(:,2)./AU, yy(:,3)./AU, 'Color', 'blue',...
%         'linewidth', 2,...
%         'HandleVisibility', 'Off');
    
    yy_custom = yy;
    yy_custom(transfer(:,9) <= 1e-3,:) = NaN;

    yy_custom_traj = yy;
    yy_custom_traj(transfer(:,9) > 1e-3,:) = NaN;

    plot3(yy_custom_traj(:,1)./AU, yy_custom_traj(:,2)./AU, yy_custom_traj(:,3)./AU, 'Color', 'blue',...
        'linewidth', 2,...
        'HandleVisibility', 'Off');

    plot3(yy_custom(:,1)./AU, yy_custom(:,2)./AU, yy_custom(:,3)./AU,...
        'LineWidth', 2, ...
        'Color', [0.9290 0.6940 0.1250],...
        'DisplayName', 'Thrust arcs');
    
    plot3(yy(1,1)./AU, yy(1,2)./AU, yy(1,3)./AU, ...
                    's', 'MarkerSize', 10, 'MarkerEdgeColor', 'Black', ...
                    'MarkerFaceColor', 'Cyan',...
                    'handlevisibility', 'off');
    
    plot3(yy(end,1)./AU, yy(end,2)./AU, yy(end,3)./AU, ...
                    'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black',...
                    'MarkerFaceColor', 'Red',...
                    'handlevisibility', 'off');
    
    figure(figTRAJ);    
    labelsDim = 12;
    axesDim   = 12;
    set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
    h = findall(gcf, 'type', 'text');
    set(h, 'fontsize', axesDim);
    ax          = gca; 
    ax.FontSize = axesDim; 
    legend('Location', 'Best');
    % --> end: plot the trajectory

elseif nargout == 2
    
    % --> start: plot the trajectory
    figure(figTRAJ);
    
    plot3(0, 0, 0, 'o', 'markersize', 10, ...
        'MarkerEdgeColor', 'Black', ...
        'MarkerFaceColor', 'Yellow', ...
        'handlevisibility', 'off');
    
%     plot3(yy(:,1)./AU, yy(:,2)./AU, yy(:,3)./AU, 'Color', 'blue',...
%         'linewidth', 2,...
%         'HandleVisibility', 'Off');
    
    yy_custom = yy;
    yy_custom(transfer(:,9) <= 1e-3,:) = NaN;

    yy_custom_traj = yy;
    yy_custom_traj(transfer(:,9) > 1e-3,:) = NaN;

    plot3(yy_custom_traj(:,1)./AU, yy_custom_traj(:,2)./AU, yy_custom_traj(:,3)./AU, 'Color', 'blue',...
        'linewidth', 2,...
        'HandleVisibility', 'Off');

    plot3(yy_custom(:,1)./AU, yy_custom(:,2)./AU, yy_custom(:,3)./AU,...
        'LineWidth', 2, ...
        'Color', [0.9290 0.6940 0.1250],...
        'DisplayName', 'Thrust arcs');
    
    plot3(yy(1,1)./AU, yy(1,2)./AU, yy(1,3)./AU, ...
                    's', 'MarkerSize', 10, 'MarkerEdgeColor', 'Black', ...
                    'MarkerFaceColor', 'Cyan',...
                    'handlevisibility', 'off');
    
    plot3(yy(end,1)./AU, yy(end,2)./AU, yy(end,3)./AU, ...
                    'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black',...
                    'MarkerFaceColor', 'Red',...
                    'handlevisibility', 'off');
    
    figure(figTRAJ);    
    labelsDim = 12;
    axesDim   = 12;
    set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
    h = findall(gcf, 'type', 'text');
    set(h, 'fontsize', axesDim);
    ax          = gca; 
    ax.FontSize = axesDim; 
    legend('Location', 'Best');
    % --> end: plot the trajectory

    % --> start: plot the mass evolution
    figure(figMASS);
    plot( tt, mm,'LineWidth', 2 );

    figure(figMASS);    
    labelsDim = 12;
    axesDim   = 12;
    set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
    h = findall(gcf, 'type', 'text');
    set(h, 'fontsize', axesDim);
    ax          = gca; 
    ax.FontSize = axesDim; 
    % --> end: plot the mass evolution


elseif nargout == 3

    % --> start: plot the trajectory
    figure(figTRAJ);
    
    plot3(0, 0, 0, 'o', 'markersize', 10, ...
        'MarkerEdgeColor', 'Black', ...
        'MarkerFaceColor', 'Yellow', ...
        'handlevisibility', 'off');
    
%     plot3(yy(:,1)./AU, yy(:,2)./AU, yy(:,3)./AU, 'Color', 'blue',...
%         'linewidth', 2,...
%         'HandleVisibility', 'Off');
    
    yy_custom = yy;
    yy_custom(transfer(:,9) <= 1e-3,:) = NaN;

    yy_custom_traj = yy;
    yy_custom_traj(transfer(:,9) > 1e-3,:) = NaN;

    plot3(yy_custom_traj(:,1)./AU, yy_custom_traj(:,2)./AU, yy_custom_traj(:,3)./AU, 'Color', 'blue',...
        'linewidth', 2,...
        'HandleVisibility', 'Off');

    plot3(yy_custom(:,1)./AU, yy_custom(:,2)./AU, yy_custom(:,3)./AU,...
        'LineWidth', 2, ...
        'Color', [0.9290 0.6940 0.1250],...
        'DisplayName', 'Thrust arcs');
    
    plot3(yy(1,1)./AU, yy(1,2)./AU, yy(1,3)./AU, ...
                    's', 'MarkerSize', 10, 'MarkerEdgeColor', 'Black', ...
                    'MarkerFaceColor', 'Cyan',...
                    'handlevisibility', 'off');
    
    plot3(yy(end,1)./AU, yy(end,2)./AU, yy(end,3)./AU, ...
                    'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black',...
                    'MarkerFaceColor', 'Red',...
                    'handlevisibility', 'off');
    
    figure(figTRAJ);    
    labelsDim = 12;
    axesDim   = 12;
    set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
    h = findall(gcf, 'type', 'text');
    set(h, 'fontsize', axesDim);
    ax          = gca; 
    ax.FontSize = axesDim; 
    legend('Location', 'Best');
    % --> end: plot the trajectory

    % --> start: plot the mass evolution
    figure(figMASS);
    plot( tt, mm,'LineWidth', 2 );

    figure(figMASS);    
    labelsDim = 12;
    axesDim   = 12;
    set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
    h = findall(gcf, 'type', 'text');
    set(h, 'fontsize', axesDim);
    ax          = gca; 
    ax.FontSize = axesDim; 
    % --> end: plot the mass evolution

    % --> start: plot the thrust evolution
    figure(figTHRmag);
    plot( tt, thMag,'LineWidth', 2 );

    figure(figTHRmag);    
    labelsDim = 12;
    axesDim   = 12;
    set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
    h = findall(gcf, 'type', 'text');
    set(h, 'fontsize', axesDim);
    ax          = gca; 
    ax.FontSize = axesDim; 
    % --> end: plot the thrust evolution

end

end
