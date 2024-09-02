function [rr, vv, kep] = EphCE_car(n, t)
%-------------------------------------------------------------------------
% This function computes the ephemerides for comets with analytical
% Keplerian dynamics propagation from a reference state obtained from
% NASA HORIZONS. Orbit is assumed to be keplerian. 
%
%
% INPUTS:
%
%       n: ID of the comet. [ND]
%       t: epoch at which the ephemerides should be computed. [MJD2000]
%
%
% OUTPUTS:
%
%       rr: vector [1x3] containing position of the comet. [km]
%       vv: vector [1x3] containing velocity of the comet. [km/s]
%       kep: keplerian elements for the comet. [sma, ecc, incl, Om, om, th]
%       (it can be added as output).
%
%
% NOTE: All the inputs required by the user are designed as 'user input'.
%
%
% Functions used:  
%
%               propagateKepler.m
%               car2kep.m
%
%
% Author:     
%               Andrea Bellome (main structure).
%               Jose Ignacio Rico Alvarez (modifications to apply the code
%               for all the considered comets).
%
%
% History of modifications:
%               Creation date: 18 - June - 2021
%
% -------------------------------------------------------------------------

%% Load all ephemerides:

persistent coms

if isempty(coms)
    load('allCOMEphemerisCEN.mat');
    coms   = allCOMEphemerisCEN;
end

%% Astronomical Constants:
muSun      = 132724487690;                                                  % Sun's gravitational parameter. [km^3/s^2]

%% Timeframe in MJD2000:
Timeframe  = [7304.5,7670.5,8035.5,8400.5,8765.5,9131.5,9496.5,9861.5,10226.5,10592.5,10957.5,11322.5,11687.5,12053.5,12418.5,12783.5,13148.5,13514.5,13879.5,14244.5,14609.5,14975.5,15340.5,15705.5,16070.5,16436.5,16801.5,17166.5,17531.5,17897.5,18262.5,18627.5,18992.5,19358.5,19723.5,20088.5,20453.5,20819.5,21184.5,21549.5,21914.5,22280.5,22645.5,23010.5,23375.5,23741.5,24106.5,24471.5,24836.5,25202.5,25567.5,25932.5,26297.5,26663.5,27028.5,27393.5,27758.5,28124.5,28489.5,28854.5,29219.5,29585.5,29950.5,30315.5,30680.5,31046.5,31411.5,31776.5,32141.5,32507.5,32872.5,33237.5,33602.5,33968.5,34333.5,34698.5,35063.5,35429.5,35794.5,36159.5,36524.5];  % (User input). Define the considered epoch used in HORIZONS. [MJD2000]

%% Load ephemerides:
maxID      = 720;                                                           % (User input). Maximum comet id.

% Check if available comet:
if n > maxID
    
    warning('error: comet not found');
    rr  = NaN;    
    vv  = NaN;
    kep = NaN;
    return
    
end

%% Ephemerides w.r.t. a given epoch:
DTs       = abs(Timeframe - t);                                             % Find the closest date.
[~,row]   = min(DTs);
tref      = Timeframe(row);

r         = (n - 1)*length(Timeframe) + 1;                                  
s         = r + row - 1;

rr0       = coms(s,2:4);
vv0       = coms(s,5:7);

%% Cartesian elements on the desired date:
[~,car]   = propagateKepler(rr0, vv0, (t - tref)*86400, muSun);
rr        = car(1:3);
vv        = car(4:6);

%% Keplerian elements on the desired date: (they could be calculated. Add the corresponding function output)
if nargout == 3
    kep = car2kep(car, muSun);
end

end
