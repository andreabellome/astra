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

clc;
if ~isfield(INPUT, 'customEphemerides')
    INPUT.customEphemerides = @EphSS_cartesian;
end

% --> SODP 
TT0        = [INPUT.depOpts(1):INPUT.depOpts(3):INPUT.depOpts(2)]'; % --> launch date vector
input      = INPUT;
input.plot = [ 0 0 ];
indl       = 1;
for indt = 1:length(TT0)

    fprintf( "Computing at: %.1f/100 \n", indt/length(TT0)*100 );
    
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
    tofs    = [ OUTPUT.minTOFy ]';
    MAT     = sortrows( [tdep, costs, tofs], 2 );
    [~, ia] = unique(MAT(:,1), 'rows', 'first');
    mat     = MAT(ia,:);
    
    % --> plot options
    if INPUT.plot(1) == 1 % --> plot cost w.r.t. launch date
        figure( 'Color', [1 1 1] );
        hold on; grid on;
        xlabel( 'Departing date' ); ylabel( 'Cost [km/s]' );
        
        N = zeros( size(mat,1),1 );
        for indi = 1:size(mat,1)
            date = mjd20002date(mat(indi,1));
            date = date(1:3);
            N(indi,1) = datenum(date);
        end
        
        scatter(N, mat(:,2), 50, mat(:,3), 'filled'); % '50' è la dimensione dei marker
        
        colormap('cool'); % Seleziona una colormap (es. 'jet', 'parula', 'hot', etc.)
        cb = colorbar; % Mostra la barra dei colori per riferimento
        ylabel(cb, 'ToF [years]'); % Aggiungi l'etichetta alla barra dei colori

        datetick('x','mmm.dd,yy' );

        labelsDim = 12;
        axesDim   = 12;
        set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
        h = findall(gcf, 'type', 'text');
        set(h, 'fontsize', axesDim);
        ax          = gca; 
        ax.FontSize = axesDim; 
    end
    
    if INPUT.plot(2) == 1 % --> plot best traj.
        [~, row] = min( costs );
        path     = OUTPUT(row).minPATH;
        plotPath(path, INPUT.idcentral, INPUT.customEphemerides);
    end

else
    OUTPUT = [];
    disp(':( ... no solutions with current settings ... :(');

end

end
