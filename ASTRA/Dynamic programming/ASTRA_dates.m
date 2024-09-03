function [OUTPUT] = ASTRA_dates(INPUT, seq)

% DESCRIPTION
% This function uses SODP (Single Objective Direct Problem) to find the
% optimal trajectory for a spacecraft given a range of launch dates.
% It iteratively computes the trajectory and cost for each launch date,
% then post-processes the results to determine the minimum cost trajectory.
% 
% INPUT
% - INPUT : structure containing mission parameters, including launch date
%           options, plotting options, and other necessary configurations.
% - seq   : sequence of IDs for flyby bodies (see constants.m)
% 
% OUTPUT
% - OUTPUT : structure array containing the computed trajectories and their
%            associated costs for each considered launch date.
% 
% -------------------------------------------------------------------------

% --> SODP 
TT0        = [INPUT.depOpts(1):INPUT.depOpts(3):INPUT.depOpts(2)]'; % --> launch date vector
input      = INPUT;
input.plot = [ 0 0 ];
indl       = 1;
for indt = 1:length(TT0)
    
    input.depOpts = [TT0(indt) TT0(indt) 1];
    output        = ASTRA_SODP_v2(input, seq);
    if ~isempty(output(1).LEGSpf)
        OUTPUT(indl:length(output)+indl-1) = output;
        indl = length(OUTPUT) + 1;
    end
    
end
clc;

if exist('OUTPUT','var') == 1

    % --> post process
    tdep = zeros( length(OUTPUT),1 );
    for indou = 1:length(OUTPUT)
        tdep(indou,:) = OUTPUT(indou).LEGSpf(1,2);
    end
    costs   = [ OUTPUT.minCOST ]';
    MAT     = sortrows( [tdep, costs], 2 );
    [~, ia] = unique(MAT(:,1), 'rows', 'first');
    mat     = MAT(ia,:);
    
    % --> plot options
    if INPUT.plot(1) == 1 % --> plot cost w.r.t. launch date
        figure( 'Color', [1 1 1] );
        hold on; grid on;
        xlabel( 'Departing date [MJD2000]' ); ylabel( 'Cost [km/s]' );
        plot( mat(:,1), mat(:,2), 'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow' );
    end
    
    if INPUT.plot(2) == 1 % --> plot best traj.
        [~, row] = min( costs );
        path     = OUTPUT(row).minPATH;
        plotPath(path, INPUT.idcentral);
    end

else
    OUTPUT = [];
    disp(':( ... no solutions with current settings ... :(');

end

end
