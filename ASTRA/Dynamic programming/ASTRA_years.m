function [OUTPUT] = ASTRA_years(INPUT, seq)

% DESCRIPTION
% This function divides the launch window in different years (365.25 days)
% and uses ASTRA with MODP successively for the different years.
% 
% INPUT:
% seq      : vector with planets IDs in the MGA sequence
% INPUT    : structure with the following mandatory fields:
%                - chosenRevs : 
%                - res        : vector with N:M resonant ratio and number
%                of leg at which the resonant transfer is needed. If no
%                resonant transfer is needed, leave it empty. E.g. EVEMMMJ
%                with 2:1 and 3:1 on MM legs would have:
%                res = [ 2 1 4 3 1 5 ], where 4 and 5 are the legs in which
%                the 2:1 and 3:1 occurr. 
%                - depOpts    : 1x2 vector. depOpts(1) is for initial date
%                range (MJD2000), depOpts(2) is for final date range
%                (MJD2000), and depOpts(3) is for step size (days)
%                - opt        : (1) is for SODP, (2) is for MODP, (3) is
%                for DATES, (4) is for YEARS - MODP 
%                - vInfOpts   : min/max departing infinity velocities (km/s)
%                - dsmOpts    : max defect DSM (km/s), and total DSMs (km/s)
%                - plot       : 1x2 vector. plot(1) is for plotting the
%                best DV trajectory, plot(2) is for plotting the Pareto
%                front. Please put plot(i)=1 if you want to plot the results. 
%                - parallel   : if 1, then parallel computing is used
%                - tstep      : (days) discretization time step 
%
% OUTPUT :
% OUTPUT : structure with the final trajectories
%
% -------------------------------------------------------------------------

% --> extract input
[~, ~, ~, ~, ~, ~, ~, ~, costFunc1_MODP, costFunc2_MODP] = check_INPUT(INPUT); % --> extract the limits on TOF and Vinf, and time step
INPUT.costFunc1_MODP                         = costFunc1_MODP;     % --> update the INPUT
INPUT.costFunc2_MODP                         = costFunc2_MODP;     % --> update the INPUT

if ~isfield(INPUT, 'customEphemerides')
    INPUT.customEphemerides = @EphSS_cartesian;
end

% --> if launch year span is too high (>3y) then separate the years
t0 = INPUT.depOpts(1);
tf = INPUT.depOpts(2);
dt = INPUT.depOpts(3);
DT = ( tf - t0 )/365.25;

input      = INPUT;
input.plot = [ 0 0 ];
indl       = 1;
for indt = 1:DT
    
    T0 = t0;
    TF = T0 + 1*365.25;
    input.depOpts = [T0 TF dt];

    t0print = mjd20002date(T0);
    tfprint = mjd20002date(TF);
    fprintf( 'Computing launch year %d-%d to %d-%d ... \n', [ t0print(1) t0print(2) tfprint(1) tfprint(2) ] );

    % --> run ASTRA (...)
    output = ASTRA_MODP_v2(input, seq);
    if ~isempty(output(1).LEGSpf)
        OUTPUT(indl:length(output)+indl-1) = output;
        indl = length(OUTPUT) + 1;
    end

    T0d = mjd20002date(T0);
    t0  = date2mjd2000( [ T0d(1)+1 1 1 0 0 0 ] );

end

clc;

if exist('OUTPUT', 'var')

    % --> compute PF of the whole thing
    LEGovPF  = cell2mat({OUTPUT.LEGovPF}');
    VASovPF  = cell2mat({OUTPUT.VASovPF}');
    VINFovPF = cell2mat({OUTPUT.VINFovPF}');
    REVSovPF = cell2mat({OUTPUT.REVSovPF}');
    
    [~, ~, ~, PF]              = INPUT.costFunc2_MODP(LEGovPF, VASovPF, VINFovPF);
    OUTPUT(1).ovPF             = PF;
    OUTPUT(1).LEGovPF          = LEGovPF(PF(:,3),:);
    OUTPUT(1).VASovPF          = VASovPF(PF(:,3),:);
    OUTPUT(1).VINFovPF         = VINFovPF(PF(:,3),:);
    OUTPUT(1).REVSovPF         = REVSovPF(PF(:,3),:);
    OUTPUT(1).res              = INPUT.res;
    
    for indo = 2:length(OUTPUT)
        OUTPUT(indo).ovPF             = [];
        OUTPUT(indo).LEGovPF          = [];
        OUTPUT(indo).VASovPF          = [];
        OUTPUT(indo).VINFovPF         = [];
        OUTPUT(indo).REVSovPF         = [];
        OUTPUT(indo).res              = [];
    end
    
    % --> plot the best path
    try
        OUTPUT(1).TimeTOT = sum([OUTPUT.tocTOT]');
        if INPUT.plot(1) == 1
            [~, run] = min([OUTPUT.minCOST]');
            path     = OUTPUT(run).minPATH;
            plotPath(path, INPUT.idcentral, INPUT.customEphemerides);
        end
    catch
    end
    
    % --> plot the Pareto front 
    try
        if INPUT.plot(2) == 1
                    
            % --> plot the overall Pareto front
            PF = OUTPUT.ovPF;
            figure('Color', [1 1 1]); hold on; grid on;
            xlabel( 'Time of flight [years]' ); ylabel(' \Deltav [km/s] ');
            plot( PF(:,1), PF(:,2), 'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Red' );
            
            labelsDim = 12;
            axesDim   = 12;
            set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
            h = findall(gcf, 'type', 'text');
            set(h, 'fontsize', axesDim);
            ax          = gca; 
            ax.FontSize = axesDim; 
        end
    catch
    end

else
    OUTPUT = [];
    fprintf(':( ... no solutions with current settings ... :( \n' );
end

end
