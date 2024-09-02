function [LEGSn, VASn, VINFn] = wrapConstructionResonance_DP(LEGSnext, VASnext, VINFnext, legs, res, indl, tolINCL, parallel)

% DESCRIPTION
% This function attempts to construct resonant orbits for a spacecraft trajectory
% by checking if resonances can be achieved and then generating the corresponding
% resonant orbits. It operates in both parallel and sequential modes.
% 
% INPUT
% - LEGSnext : Matrix containing the legs of the spacecraft's trajectory, where each row 
%              corresponds to a different leg.
% - VASnext  : Matrix containing the spacecraft's velocities corresponding to each leg.
% - VINFnext : Matrix containing the hyperbolic excess velocities for each leg.
% - legs     : Matrix containing the initial legs of the trajectory.
% - res      : Array containing the desired resonance ratio [numerator, denominator].
% - indl     : Index identifying the specific leg to analyze in the 'legs' matrix.
% - tolINCL  : Tolerance for inclination matching during resonance construction.
% - parallel : Boolean flag to indicate whether to run the resonance checks in parallel.
% 
% OUTPUT
% - LEGSn  : Matrix of legs after constructing resonant orbits.
% - VASn   : Matrix of velocities after constructing resonant orbits.
% - VINFn  : Matrix of hyperbolic excess velocities after constructing resonant orbits.
% 
% -------------------------------------------------------------------------

pl2 = legs(indl,2);
[LEGSnext, VASnext, VINFnext] = checkResonance_DP(LEGSnext, VASnext, VINFnext, pl2, res, parallel);
if isempty(LEGSnext) % --> if the resonance is not achievable, then end
    LEGSn = [];
    VASn  = [];
    VINFn = [];
    return
end

STRUC = struct('LEGSn', [], 'VASn', [], 'VINFn', []);

if parallel == true
    
    parfor indl = 1:size(LEGSnext,1)
   
        legp  = LEGSnext(indl,:);
        vasp  = VASnext(indl,:);
        vinfp = VINFnext(indl,:);

        [legn, vasn, vinfn] = constructResonantOrbits_DP(legp, vasp, vinfp, pl2, res, tolINCL);

        STRUC(indl).LEGSn = legn;
        STRUC(indl).VASn  = vasn;
        STRUC(indl).VINFn = vinfn;
    
    end
    
else

    for indl = 1:size(LEGSnext,1)

        legp  = LEGSnext(indl,:);
        vasp  = VASnext(indl,:);
        vinfp = VINFnext(indl,:);

        [legn, vasn, vinfn] = constructResonantOrbits_DP(legp, vasp, vinfp, pl2, res, tolINCL);

        STRUC(indl).LEGSn = legn;
        STRUC(indl).VASn  = vasn;
        STRUC(indl).VINFn = vinfn;

    end

end

hasNone        = cellfun(@isempty,{STRUC.LEGSn});
STRUC(hasNone) = [];

LEGSn = cell2mat({STRUC.LEGSn}');
VASn  = cell2mat({STRUC.VASn}');
VINFn = cell2mat({STRUC.VINFn}');

end
