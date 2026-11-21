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

% --> caches of the Lambert arcs (shared by all launch dates)
if (isfield(INPUT, 'fastLastLeg') && INPUT.fastLastLeg) || (isfield(INPUT, 'fastAllLegs') && INPUT.fastAllLegs)
    wrap_DynProgr_st2_fast('reset');
    cleanupCache = onCleanup(@() wrap_DynProgr_st2_fast('reset')); %#ok<NASGU>
end

for indt = 1:length(TT0)

    fprintf( "Computing at: %.1f/100 \n", indt/length(TT0)*100 );
    
    input.depOpts = [TT0(indt) TT0(indt) 1];
    output        = ASTRA_SODP_v2(input, seq);
    if isfield(INPUT, 'paretoByDate') && INPUT.paretoByDate
        output = keepParetoOfDate(output); % --> keep only the (cost, ToF) Pareto front of this launch date
    end
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

% =========================================================================
function output = keepParetoOfDate(output)
% Keeps, for each element of the output of ASTRA_SODP_v2 (one launch
% date), only the solutions on its (TOF, cost) Pareto front, i.e. the rows
% already identified by output(k).PF(:,3). All the per-solution arrays are
% subset consistently and PF(:,3) is remapped. minPATH/minCOST/minTOFy are
% unchanged (the min-cost solution is on the front). The overall Pareto
% front over all launch dates is a subset of the union of these fronts.
for k = 1:numel(output)
    if isempty(output(k).LEGS) || isempty(output(k).PF)
        continue;
    end
    idx                  = output(k).PF(:,end);
    output(k).LEGS       = output(k).LEGS(idx,:);
    output(k).VAS        = output(k).VAS(idx,:);
    output(k).VINFa      = output(k).VINFa(idx,:);
    output(k).COSTS      = output(k).COSTS(idx,:);
    output(k).TOFYS      = output(k).TOFYS(idx,:);
    output(k).chosenRevs = output(k).chosenRevs(idx,:);
    output(k).PF(:,end)  = (1:numel(idx))';
end
end
