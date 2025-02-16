function [figTRAJ, figMASS, figTHRmag] = wrapPlotLTFull(LT_TRANSFER, param)

% DESCRIPTION
% This function generates trajectory plots for a low-thrust transfer, including 
% mass and thrust magnitude plots. It calls the plotLT function to generate 
% the primary plots and overlays initial and final states on the trajectory plot.

% INPUT
% - LT_TRANSFER : structure containing low-thrust transfer data
%   - TRANSFER : structure with trajectory data
%   - ST_12    : matrix of initial and final states [state1, state2]
% - param : structure containing parameters
%   - AU : astronomical unit (km)

% OUTPUT
% - figTRAJ   : figure handle for the trajectory plot
% - figMASS   : figure handle for the mass evolution plot
% - figTHRmag : figure handle for the thrust magnitude plot
%
% -------------------------------------------------------------------------


[figTRAJ, figMASS, figTHRmag] = plotLT( LT_TRANSFER.TRANSFER, param );

st12 = LT_TRANSFER.ST_12;
AU    = param.AU;

figure(figTRAJ);
for inds = 1:size(st12,1)
    
    state1 = st12(inds,1:6);
    state2 = st12(inds,7:12);

    plot3(state1(1,1)./AU, state1(1,2)./AU, state1(1,3)./AU, ...
                    'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black',...
                    'MarkerFaceColor', 'Red',...
                    'handlevisibility', 'off');


    plot3(state2(1,1)./AU, state2(1,2)./AU, state2(1,3)./AU, ...
                    'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black',...
                    'MarkerFaceColor', 'Red',...
                    'handlevisibility', 'off');

end
legend('Location', 'Best');

end
