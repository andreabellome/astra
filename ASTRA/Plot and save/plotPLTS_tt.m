function [fig] = plotPLTS_tt(pl, t0, tend, idcentral, customEphemerides, holdon, colors, names, linewidth, style)

% DESCRIPTION
% This function plots the orbits of specified planets over a given time range 
% and provides an option to either open a new figure or use an existing one. 
% It also plots the Sun's position for reference.
% 
% INPUT
% - pl     : Vector of planet IDs to plot.
% - t0     : Start time for plotting (in days).
% - tend   : End time for plotting (in days).
% - holdon : Optional flag to determine whether to hold on to the current figure (1) or open a new one (0).
% - colors : RGB triplet for the plot of the orbits. Default is black
% - names  : cell with names of the planets. Default is empty. This is used
% only for putting legend to the plot.
% 
% OUTPUT
% - fig   : Handle to the figure created or used for plotting.
% 
% PROCESS
% - If only three input arguments are provided, a new figure is opened.
% - If a fourth argument is provided, the function either uses the current 
%   figure or opens a new one based on the `holdon` flag.
% - For each planet, compute and plot its orbit over the specified time range.
% - The orbits are plotted in Astronomical Units (AU) with the Sun's position 
%   marked as a yellow point.
% 
% -------------------------------------------------------------------------

if nargin == 3 % --> open a new figure
    idcentral = 1;
    customEphemerides = @EphSS_cartesian;
    fig       = figure('Color', [1 1 1]);

    colors    = zeros( length(pl), 3 );
    names     = {};
    linewidth = 0.5;
    style     = '-';

elseif nargin == 4
    customEphemerides = @EphSS_cartesian;
    fig = figure('Color', [1 1 1]);

    colors    = zeros( length(pl), 3 );
    names     = {};
    linewidth = 0.5;
    style     = '-';

elseif nargin == 5 
    if isempty(customEphemerides)
        customEphemerides = @EphSS_cartesian;
    end
    fig       = figure('Color', [1 1 1]);
    colors    = zeros( length(pl), 3 );
    names     = {};
    linewidth = 0.5;
    style     = '-';

elseif nargin == 6 % --> hold on with the current figure
    if isempty(customEphemerides)
        customEphemerides = @EphSS_cartesian;
    end
    if holdon == 0
        fig = figure('Color', [1 1 1]);
    else
        fig = gcf;
    end
    
    colors    = zeros( length(pl), 3 );
    names     = {};
    linewidth = 0.5;
    style     = '-';

elseif nargin == 7
    if isempty(customEphemerides)
        customEphemerides = @EphSS_cartesian;
    end
    if holdon == 0
        fig = figure('Color', [1 1 1]);
    else
        fig = gcf;
    end
    
    if isempty(colors)
        colors    = zeros( length(pl), 3 );
    end

    names     = {};
    linewidth = 0.5;
    style     = '-';

elseif nargin == 8
    if isempty(customEphemerides)
        customEphemerides = @EphSS_cartesian;
    end
    if holdon == 0
        fig = figure('Color', [1 1 1]);
    else
        fig = gcf;
    end

    if isempty(colors)
        colors    = zeros( length(pl), 3 );
    end

    if isempty(names)
        names = {};
    end

    linewidth = 0.5;
    style     = '-';
elseif nargin == 9
    if isempty(customEphemerides)
        customEphemerides = @EphSS_cartesian;
    end
    if holdon == 0
        fig = figure('Color', [1 1 1]);
    else
        fig = gcf;
    end

    if isempty(colors)
        colors    = zeros( length(pl), 3 );
    end

    if isempty(names)
        names = {};
    end

    style     = '-';
elseif nargin == 10
    if isempty(customEphemerides)
        customEphemerides = @EphSS_cartesian;
    end
    if holdon == 0
        fig = figure('Color', [1 1 1]);
    else
        fig = gcf;
    end

    if isempty(colors)
        colors    = zeros( length(pl), 3 );
    end

    if isempty(names)
        names = {};
    end

end

if idcentral == 1
    tt = t0:2:tend;
else
    tt = linspace(t0, tend, 5e3);
end

fig.Color = [ 1 1 1 ];
axis equal; grid on;

if idcentral == 1
    AU = 149597870.7;
    xlabel('x [AU]'); ylabel('y [AU]'); zlabel('z [AU]');
else
    [~, AU] = planetConstants(idcentral);
    if idcentral == 5
        xlabel('x [R_J]'); ylabel('y [R_J]'); zlabel('z [R_J]'); 
    elseif idcentral == 6
        xlabel('x [R_S]'); ylabel('y [R_S]'); zlabel('z [R_S]');
    elseif idcentral == 7
        xlabel('x [R_U]'); ylabel('y [R_U]'); zlabel('z [R_U]');
    end
end

for indi = 1:length(pl)
    
    rrpl = zeros(length(tt), 3);
    vvpl = zeros(length(tt), 3);
    for indt = 1:length(tt)
        [rrpl(indt,:), vvpl(indt,:)] = customEphemerides(pl(indi), tt(indt), idcentral);
    end
    
    if isempty(names)
        hold on;
        plot3(rrpl(:,1)./AU, rrpl(:,2)./AU, rrpl(:,3)./AU, style, ...
            'Color', colors(indi,:), 'linewidth', linewidth,...
            'handlevisibility', 'off');
    else
        hold on;
        plot3(rrpl(:,1)./AU, rrpl(:,2)./AU, rrpl(:,3)./AU, style, ...
            'Color', colors(indi,:), 'linewidth', linewidth,...
            'DisplayName', names{indi});
    end

end

plot3(0, 0, 0, 'o', 'markersize', 10, ...
    'MarkerEdgeColor', 'Black',...
    'MarkerFaceColor', 'Yellow',...
    'handlevisibility', 'off');

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

end
