function [fig] = plotPLTS_tt(pl, t0, tend, holdon)

% DESCRIPTION
% This function plots the orbits of specified planets over a given time range 
% and provides an option to either open a new figure or use an existing one. 
% It also plots the Sun's position for reference.
% 
% INPUT
% - pl    : Vector of planet IDs to plot.
% - t0    : Start time for plotting (in days).
% - tend  : End time for plotting (in days).
% - holdon: Optional flag to determine whether to hold on to the current figure (1) or open a new one (0).
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
    fig = figure('Color', [1 1 1]);
else % --> hold on with the current figure
    if holdon == 0
        fig = figure('Color', [1 1 1]);
    else
        fig = gcf;
    end
end

tt = t0:2:tend;
AU = 149597870.7;

axis equal; grid on;
xlabel('x - AU'); ylabel('y - AU');

for indi = 1:length(pl)
    
    rrpl = zeros(length(tt), 3);
    vvpl = zeros(length(tt), 3);
    for indt = 1:length(tt)
        [rrpl(indt,:), vvpl(indt,:)] = EphSS_cartesian(pl(indi), tt(indt));
    end
    
    hold on;
    plot3(rrpl(:,1)./AU, rrpl(:,2)./AU, rrpl(:,3)./AU, 'k', 'linewidth', 0.5, 'handlevisibility', 'off');
    
end

plot3(0, 0, 0, 'o', 'markersize', 10, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow', 'handlevisibility', 'off');

end