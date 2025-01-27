function [fig] = plotOutputByLauchDate(OUTPUT, holdon)

% DESCRITPION:
% This function plots best overall cost by launch date.
% It is suggested to use this function only when using ASTRA with
% INPUT.opt = 3 (i.e., when optimizing with SODP by launch date.
%
% INPUT:
% - OUTPUT : structure with optimal trajectories from ASTRA with
%            INPUT.opt=3
%
% OUTPUT:
% - fig : figure object.
% 
% -------------------------------------------------------------------------

if nargin == 1
    holdon = 0;
end

if holdon == 0
    fig = figure( 'Color', [1 1 1] );
    hold on; grid on;
    xlabel( 'Departing date' ); ylabel( 'Cost [km/s]' );
else
    fig = gcf;
    fig.Color = [1 1 1];
    hold on; grid on;
    xlabel( 'Departing date' ); ylabel( 'Cost [km/s]' );
end

% --> post process
tdep = zeros( length(OUTPUT),1 );
for indou = 1:length(OUTPUT)
    tdep(indou,:) = OUTPUT(indou).LEGSpf(1,2);
end
costs   = [ OUTPUT.minCOST ]';
MAT     = sortrows( [tdep, costs], 2 );
[~, ia] = unique(MAT(:,1), 'rows', 'first');
mat     = MAT(ia,:);

N = zeros( size(mat,1),1 );
for indi = 1:size(mat,1)
    date = mjd20002date(mat(indi,1));
    date = date(1:3);
    N(indi,1) = datenum(date);
end

plot( N, mat(:,2), 'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow' );
        datetick('x','mmm.dd,yy' );

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

end