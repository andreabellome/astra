function m0 = ariane_64_launcher( vinf, dla_deg, mass_adapter, type )

% DESCRIPTION:
% Launch mass from infinity-velocity for Ariane 64 launcher.
% This function supports both mono-boost and bi-boost launcher
% configurations. 
% IMPORTANT: if the dla_deg is outside -5/+5 deg bounds, the function
% automatically selects the bi-boost configuration to maximise the mass.
%
% INPUT:
% - vinf         : infinity velocity at launch [km/s]
% - dla_deg      : launch declination [deg]. Default is -5 deg (max.
%                  performance of the launcher)
% - mass_adapter : adapter mass [kg]. By default = 110 kg
% - type         : string. Launcher type either 'mono_boost' or 'bi_boost'.
%                  By default is 'mono_boost'. However, if the launch
%                  declination is either more than 5 deg or less than -5
%                  deg, then the performances of the mono-boost are too low
%                  and thus the 'bi_boost' option is automatically
%                  selected.
%
% OUTPUT:
% - m0 : max. launch mass [kg]
%
% -------------------------------------------------------------------------

if nargin == 1
    dla_deg      = -5; % --> max. performance
    mass_adapter = 110;
    type         = 'mono_boost';
elseif nargin == 2
    if isempty(dla_deg)
        dla_deg = -5; % --> max. performance
    end
    mass_adapter = 110;
    type         = 'mono_boost';
elseif nargin == 3
    if isempty(dla_deg)
        dla_deg = -5;
    end
    if isempty(mass_adapter)
        mass_adapter = 110;
    end
    type         = 'mono_boost';
elseif nargin == 4
    if isempty(dla_deg)
        dla_deg = -5;
    end
    if isempty(mass_adapter)
        mass_adapter = 110;
    end
    if isempty(type)
        type         = 'mono_boost';
    end
end

vinf_vec = 1:1:6;

if dla_deg > 5 || dla_deg < -5
    type = 'bi_boost';
end

if strcmpi(type, 'mono_boost')

    dla_vec  = [-5, 0, 5];
    
    mass_mat = [
        8661, 8056, 7127, 5943, 4594, 3167; % DLA =  -5 deg
        8447, 7650, 6515, 5245, 3952, 2669; % DLA =  0 deg
        7872, 6867, 5426, 3734, 2394, 1108  % DLA =  +5 deg
        ];
    
elseif strcmpi(type, 'bi_boost')
    
    dla_vec  = [-40 -30 -20 -10 0 10 20 30 40];
    mass_mat = [
        7518        7029        6149        4995        3793        2578; % DLA =  -40 deg
        7504        7001        6109        4955        3753        2531; % DLA =  -30 deg
        7485        6963        6079        4911        3710        2487; % DLA =  -20 deg
        7464        6925        6042        4861        3665        2438; % DLA =  -10 deg
        7438        6888        6002        4812        3613        2395; % DLA =  0 deg
        7405        6853        5960        4763        3572        2354; % DLA =  10 deg
        7367        6800        5915        4711        3520        2305; % DLA =  20 deg
        7332        6749        5859        4662        3462        2248; % DLA =  30 deg
        7300        6701        5798        4622        3385        2174; % DLA =  40 deg
    ];

end

% 2D interpolation (shape-preserving not available → use spline or linear)
m0 = interp2(vinf_vec, dla_vec, mass_mat, vinf, dla_deg, 'spline');
m0 = m0 - mass_adapter;

end