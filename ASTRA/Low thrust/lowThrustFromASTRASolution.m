function [LT_SOLUTION, struc] = lowThrustFromASTRASolution( astraSolution, lowThrustParameters, idcentral, customEphemerides )

% DESCRIPTION
% This function is used to process the ASTRA solution for low-thrust trajectory optimization.
% It processes the trajectory data, computes the thrust profile, and solves for the optimal
% solution based on the given parameters and constraints. If the thrust system is insufficient
% for any leg of the trajectory, it terminates early. It generates an output structure that includes 
% the trajectory details, including mass evolution, delta-v, and time of flight for each leg of the mission.
%
% INPUT
% - astraSolution : structure containing ASTRA solution data
%   - path      : trajectory path data
%   - revs      : revolutions' options for each leg
%   - res       : resonance options for each leg
%   - vdep_free : velocity for free departure [km/s]
%   - varr_free : velocity for free arrival [km/s]
% - lowThrustParameters : structure containing low-thrust trajectory parameters
%   - Tmax          : maximum thrust [N]
%   - Isp           : specific impulse [s]
%   - m0            : initial mass [kg]
%   - gamma         : discount factor for the smoothing parameter (default is 0.5)
%   - rhoLim        : limit on the smoothing parameter for optimal control solution (default is 0.001)
%   - plot          : boolean flag to enable plotting of the thrust profile (default is false)
%   - useParallel   : boolean flag to enable parallel computation (default is false)
%   - g0            : gravitational acceleration constant [m/s^2]
% - idcentral         : ID of the central body for the transfer
% - customEphemerides : function handle for custom ephemerides
%
% OUTPUT
% - LT_SOLUTION : structure containing the low-thrust trajectory solution
%   - LTsol : low-thrust solution for each leg, including mass, time of flight,
%             delta-v, and other trajectory details
%   - m0                : initial mass at the beginning of the leg
%   - mf                : final mass after the leg
%   - mp                : mass change during the leg
%   - DV                : delta-v for the leg
%   - tof               : time of flight for the leg
%   - cumulative_tof    : cumulative time of flight for all legs
%
% -------------------------------------------------------------------------

% --> start: extact and process input
path          = astraSolution.path;              % --> ASTRA solution
revs          = astraSolution.revs;              % --> revolutions' options from ASTRA solution
res           = astraSolution.res;               % --> resonances' options from ASTRA solution

if isfield(astraSolution, 'vdep_free')
    vinf_dep_free = astraSolution.vdep_free;         % --> v-infinity provided by launcher 'for free' [km/s]
else
    vinf_dep_free = 0;
end

if isfield(astraSolution, 'varr_free')
    vinf_arr_free = astraSolution.varr_free;         % --> arrival infinity velocity 'for free' [km/s]
else
    vinf_arr_free = 0;
end

if isfield(lowThrustParameters, 'gamma')
    gamma = lowThrustParameters.gamma;
else
    gamma = 0.5;
end

if isfield(lowThrustParameters, 'rhoLim')
    rhoLim = lowThrustParameters.rhoLim;
end
    
if isfield(lowThrustParameters, 'plot')
    plotParam = lowThrustParameters.plot;
else
    plotParam = false;
end

if nargin == 2
    idcentral = 1;
    customEphemerides = @EphSS_cartesian;
elseif nargin == 3
    customEphemerides = @EphSS_cartesian;
end

Tmax = lowThrustParameters.Tmax;
Isp  = lowThrustParameters.Isp;
m0   = lowThrustParameters.m0;

if isfield(lowThrustParameters, 'useParallel')
    useParallel = lowThrustParameters.useParallel;
else
    useParallel = false;
end

if isfield(lowThrustParameters, 'g0')
    g0 = lowThrustParameters.g0;
else
    g0 = 9.80665;
end
% --> end: extact and process input

% --> process ASTRA solution
struc    = postProcessPathASTRA_lowThrust(path, vinf_dep_free, vinf_arr_free, idcentral, customEphemerides);

% --> solve the problem
strucToSave = struct( 'LTsol', cell(1, length(struc)), ...
    'm0', cell(1,length(struc)), 'mf', cell(1, length(struc)), 'mp', cell(1, length(struc)), ...
    'DV', cell(1, length(struc)), 'tof', cell(1, length(struc)), 'cumulative_tof',  cell(1, length(struc)));
for inds = 1:length(struc)

    state1 = struc(inds).xxDtar;
    state2 = struc(inds).xxAtar;
    tof    = ( struc(inds).tA - struc(inds).tD ) * 86400;
    dvD    = struc(inds).dvD;
    dvA    = struc(inds).dvA;
    accel  = ( dvD + dvA )*1000/tof;
    revopt = rev2RevOpt(revs(inds), res, inds);

    if revopt(3) == 0 

        if accel * 2 <= Tmax/m0
    
            % --> initialise the parameters
            param        = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, revopt(1), idcentral, useParallel);

            % --> extract additional plots
            param.plot   = plotParam;    % --> this plots the thrust evolution over time for different rho (default is false)            
            param.gamma  = gamma;
            if isfield(lowThrustParameters, 'rhoLim')
                param.rhoLim = rhoLim;
            end

            if dvD + dvA <= 0.1
                param.rhoLim = 0.01;
            end

            if dvD + dvA >= 1
                param.rhoGuess1 = 0.5;
                param.rhoGuess2 = 0.75;
                
                if param.Nrev > 0
                    param.gamma     = 0.9;
                end
            end
            
            % --> solve the problem
            LTsol = wrapSolveFopt( param );
            
            % --> new initial mass
            m0                      = LTsol.mf; % --> new initial mass
            strucToSave(inds).LTsol = LTsol;

        else
            
            fprintf( 'Thrust system is not enough on leg: %d: \n', inds );
            LT_SOLUTION = strucToSave;
            break;
        
        end

    else % --> there is a resonance in this leg
        
        param        = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, revopt(1), idcentral, useParallel);

        % --> simple propagation without thrusting
        [tt, yy] = propagateKepler(state1(1:3), state1(4:6), linspace(0, tof, 1e3), param.mu);

        transfer = [ tt./86400, yy, m0.*ones(size(yy,1),1), zeros(size(yy,1),4) ];

        LTsol.transfer = transfer;
        LTsol.lambdas  = zeros( 1,7 );
        LTsol.Tmax     = param.Tmax;
        LTsol.Isp      = param.Isp;
        LTsol.g0       = param.g0;
        LTsol.m0       = m0;
        LTsol.mf       = m0;
        LTsol.tof      = tof / 86400;
        LTsol.DV       = 0;
        LTsol.param    = param;
        LTsol.success  = true;

        % --> new initial mass
        m0                      = LTsol.mf; % --> new initial mass
        strucToSave(inds).LTsol = LTsol;

    end

end

% --> process the output
LT_SOLUTION = strucToSave;

for inds = 1:length(LT_SOLUTION)

    if ~isempty(LT_SOLUTION(inds).LTsol)
        
        LT_SOLUTION(inds).m0             = LT_SOLUTION(inds).LTsol.m0;
        LT_SOLUTION(inds).mf             = LT_SOLUTION(inds).LTsol.mf;
        LT_SOLUTION(inds).mp             = LT_SOLUTION(inds).LTsol.m0 - LT_SOLUTION(inds).LTsol.mf;
        LT_SOLUTION(inds).DV             = LT_SOLUTION(inds).LTsol.DV;
        LT_SOLUTION(inds).tof            = LT_SOLUTION(inds).LTsol.tof;
        if inds == 1
            LT_SOLUTION(inds).cumulative_tof = LT_SOLUTION(inds).LTsol.tof;
        else
            LT_SOLUTION(inds).cumulative_tof = LT_SOLUTION(inds-1).LTsol.tof + LT_SOLUTION(inds).LTsol.tof;
        end

    end

end

end
