function fig = plotPareto(paretofront, holdon, marker, color, name, markersize)

% DESCRIPTION
% This function plots the Pareto front of solutions on a 2D plot, with the x-axis representing
% time of flight (in years) and the y-axis representing delta-v (in km/s). The plot can be 
% customized with various input arguments to hold the plot, change markers, colors, and add labels.
% 
% INPUT
% - paretofront : Matrix where each row represents a point on the Pareto front, with the first 
%                 column being the time of flight and the second column being the delta-v.
% - holdon      : Boolean flag to determine whether to hold the current plot or create a new one.
%                 If holdon == 1, the current plot is held; otherwise, a new plot is created.
% - marker      : String specifying the marker type for the plot points (e.g., 'o', 'x').
% - color       : String or RGB triplet specifying the color of the plot markers.
% - name        : String specifying the name to be used in the legend for this Pareto front.
% - markersize  : Scalar value specifying the size of the plot markers.
% 
% OUTPUT
% - fig : Handle to the created or modified figure.
% 
% -------------------------------------------------------------------------


if nargin == 1 % --> new figure
    markersize = 8;

    fig = figure( 'Color', [1 1 1] );
    hold on; grid on;
    xlabel('Time of flight - years'); ylabel('\Deltav - km/s');
    plot(paretofront(:,1), paretofront(:,2), 'o', 'MarkerSize', markersize, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Red', 'HandleVisibility', 'Off');
elseif nargin == 2 % --> same figure
    markersize = 8;
    if holdon == 1
    else
        fig = figure( 'Color', [1 1 1] );
    end
    hold on; grid on;
    xlabel('Time of flight - years'); ylabel('\Deltav - km/s');
    plot(paretofront(:,1), paretofront(:,2), 'o', 'MarkerSize', markersize, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Green', 'HandleVisibility', 'Off');
elseif nargin == 3
    markersize = 8;
    if holdon == 1
    else
        fig = figure( 'Color', [1 1 1] );
    end
    hold on; grid on;
    xlabel('Time of flight - years'); ylabel('\Deltav - km/s');
    plot(paretofront(:,1), paretofront(:,2), marker, 'MarkerSize', markersize, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Green', 'HandleVisibility', 'Off');
elseif nargin == 4
    markersize = 8;
    if holdon == 1
    else
        fig = figure( 'Color', [1 1 1] );
    end
    hold on; grid on;
    xlabel('Time of flight - years'); ylabel('\Deltav - km/s');
    plot(paretofront(:,1), paretofront(:,2), marker, 'MarkerSize', markersize, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', color, 'HandleVisibility', 'Off');
    legend;
    legend('Location', 'Best');
    myleg = legend;
    myleg.NumColumns = 2;
elseif nargin == 5
    markersize = 8;
    if holdon == 1
    else
        fig = figure( 'Color', [1 1 1] );
    end
    hold on; grid on;
    xlabel('Time of flight - years'); ylabel('\Deltav - km/s');
    plot(paretofront(:,1), paretofront(:,2), marker, 'MarkerSize', markersize, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', color, 'DisplayName', name);
    legend;
    legend('Location', 'Best');
    myleg = legend;
    myleg.NumColumns = 2;
elseif nargin == 6
    if holdon == 1
    else
        fig = figure( 'Color', [1 1 1] );
    end
    hold on; grid on;
    xlabel('Time of flight - years'); ylabel('\Deltav - km/s');
    plot(paretofront(:,1), paretofront(:,2), marker, 'MarkerSize', markersize, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', color, 'DisplayName', name);
    legend;
    legend('Location', 'Best');

    myleg = legend;
    myleg.NumColumns = 2;

end

labelsDim = 16;
axesDim   = 16;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

end