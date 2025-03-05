function figTHRmag = plotLT_Th( transfer, param, holdon, name )

% DESCRIPTION
% This function generates a plot of the thrust magnitude over time for a 
% low-thrust trajectory. The plot can either create a new figure or overlay 
% the data onto an existing figure, depending on the input argument 'holdon'.
%
% INPUT
% - transfer : matrix containing trajectory data (see also plotLT.m)
% - param    : structure containing parameters for the plot. For example, 
%              'rho' is used in the plot legend to label the curve.
% - holdon   : optional binary input. If set to 0 (default), a new figure is 
%              created for the plot. If set to 1, the plot is overlaid onto 
%              the current figure.
% - name     : optional string input. This is the name of the curve for the
%              legend display.
%
% OUTPUT
% - figTHRmag : handle to the figure containing the thrust magnitude plot.
%
% -------------------------------------------------------------------------

if nargin == 2
    holdon = 0;
    name = ['\rho: ' num2str(param.rho) ];
elseif nargin == 3
    if isempty(holdon)
        holdon = 0;
    end
    name = ['\rho: ' num2str(param.rho) ];
elseif nargin == 4
    if isempty(holdon)
        holdon = 0;
    end
end

if holdon == 0
    fig = figure( 'Color', [1 1 1] );
    hold on; grid on;
    xlabel('time [days]'); ylabel('Thrust [N]');
else
    fig = gcf;
    fig.Color = [1 1 1];
    hold on; grid on;
    xlabel('time [days]'); ylabel('Thrust [N]');
end

tt    = transfer(:,1);
thMag = transfer(:,9);

% name = ['\rho: ' num2str(param.rho) ];

% --> start: plot the mass evolution
figure(fig);
plot( tt, thMag,'LineWidth', 2, 'DisplayName', name );
% --> end: plot the mass evolution

figTHRmag = fig;

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

end
