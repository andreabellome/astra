function [ paretoFront ] = process_paretoFront_structure( INPUT, processed_OUTPUT )

% DESCRIPTION
% This function processes the output of a multi-objective trajectory
% optimization routine for multiple gravity assist trajectories by
% converting the raw results into a user-friendly structured format. It
% extracts and organizes path details, objective values, times of flight,
% and dynamical defects for each point on the Pareto front.
% 
% INPUT
% - INPUT            : structure containing mission setup parameters,
%                      including the objective functions and SPICE settings
% - processed_OUTPUT : structure containing raw optimization results,
%                      including legs, velocities, and revolution data
%
% OUTPUT
% - paretoFront : structured array where each element contains the
%                 following fields for a single trajectory on the Pareto front:
%                 * path        : full trajectory path as time-state matrix
%                 * revs        : sequence of revolutions for each leg
%                 * res         : additional resolution data
%                 * objVal      : values of the objective functions
%                 * tof_days    : total time of flight in days
%                 * tof_years   : total time of flight in years
%                 * tofs_days   : vector of times of flight for each leg (days)
%                 * vinfDep     : launch hyperbolic excess velocity (km/s)
%                 * vinfArr     : arrival hyperbolic excess velocity (km/s)
%                 * defects     : vector of dynamical defects per leg
%                 * defects_sum : sum of all dynamical defects
%
% -------------------------------------------------------------------------

[~, ~, ~, ~, ...
    ~, ~, ~, ~, ...
    costFunc1_MODP, costFunc2_MODP] = check_INPUT(INPUT);

INPUT.costFunc1_MODP = costFunc1_MODP;     % --> update the INPUT
INPUT.costFunc2_MODP = costFunc2_MODP;     % --> update the INPUT

if ~isfield(INPUT, 'customEphemerides')
    INPUT.customEphemerides = @EphSS_cartesian;
end

% --> use MODP function to process the output
[legn, vvf, vinff, PF] = INPUT.costFunc2_MODP( processed_OUTPUT.LEGS, processed_OUTPUT.VAS, processed_OUTPUT.VINFa  );

OUTPUT.ovPF           = PF;
OUTPUT.LEGovPF        = legn;
OUTPUT.VASovPF        = vvf;
OUTPUT.VINFaovPF      = vinff;
OUTPUT.REVSovPF       = processed_OUTPUT.REVS(PF(:,end),:);
OUTPUT.res            = processed_OUTPUT.res;

n           = size(PF,1);
paretoFront = struct( 'path', cell(1,n), 'revs', cell(1,n), 'res', cell(1,n),...
                    'objVal', cell(1,n), ...
                    't_dep_mjd2000', cell(1,n), 't_dep_date', cell(1,n),...
                    't_arr_mjd2000', cell(1,n), 't_arr_date', cell(1,n),...
                    'tof_days', cell(1,n), 'tof_years', cell(1,n), 'tofs_days', cell(1,n), ...
                    'vinfDep', cell(1,n), 'vinfArr', cell(1,n), ...
                    'defects', cell(1,n), 'defects_sum', cell(1,n));
for indpf = 1:size(PF,1)
   
    % --> extract path from Pareto front
    [path, revs, res] = pathfromPF(OUTPUT, INPUT.idcentral, 1, indpf, INPUT.customEphemerides);

    paretoFront(indpf).path          = path;
    paretoFront(indpf).revs          = revs;
    paretoFront(indpf).res           = res;
    paretoFront(indpf).objVal        = OUTPUT.ovPF(indpf,1:end-1);
    paretoFront(indpf).t_dep_mjd2000 = path(1,8);
    paretoFront(indpf).t_dep_date    = mjd20002date(path(1,8));
    paretoFront(indpf).t_arr_mjd2000 = path(end,8);
    paretoFront(indpf).t_arr_date    = mjd20002date(path(end,8));
    paretoFront(indpf).tof_days      = sum(path( 2:end,11 ));
    paretoFront(indpf).tof_years     = sum(path( 2:end,11 ))/365.25;
    paretoFront(indpf).vinfDep       = path( 1,9 );
    paretoFront(indpf).vinfArr       = path( end,9 );
    paretoFront(indpf).defects       = path( 2:end,10 );
    paretoFront(indpf).tofs_days     = path( 2:end,11 );
    paretoFront(indpf).defects_sum   = sum(path( :,10 ));

end

end
