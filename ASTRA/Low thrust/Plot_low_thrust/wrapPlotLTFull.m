function [figTRAJ, figMASS, figTHRmag] = wrapPlotLTFull(LT_SOLUTION, param)

% DESCRIPTION
% This function generates trajectory plots for a low-thrust transfer, including 
% mass and thrust magnitude plots. It calls the plotLT function to generate 
% the primary plots and overlays initial and final states on the trajectory plot.

% INPUT
% - LT_SOLUTION : structure containing low-thrust transfer data for all the
%                 legs of an MGA transfer
% - param : structure containing parameters
%
% OUTPUT
% - figTRAJ   : figure handle for the trajectory plot
% - figMASS   : figure handle for the mass evolution plot
% - figTHRmag : figure handle for the thrust magnitude plot
%
% -------------------------------------------------------------------------

% --> start: process the low-thrust solution
strucToSave = LT_SOLUTION;
tEnd = 0;
TRANSFER = [];
ST_12    = [];
for inds = 1:length(strucToSave)
    
    transfer = strucToSave(inds).LTsol.transfer;
    
    if inds > 1
        tEnd = tEnd + strucToSave(inds-1).LTsol.param.tEnd;
        transfer(:,1) = transfer(:,1) + tEnd;
    end

    TRANSFER = [TRANSFER; transfer];
    state1   = transfer(1,2:7);
    state2   = transfer(end,2:7);
    ST_12    = [ ST_12; state1 state2 ];

end
LT_TRANSFER.TRANSFER = TRANSFER;
LT_TRANSFER.ST_12    = ST_12;
% --> end: process the low-thrust solution

if nargout == 1

    % --> plot the trajectory, mass and thrust evolutions
    figTRAJ = plotLT( LT_TRANSFER.TRANSFER, param );

else

    % --> plot the trajectory, mass and thrust evolutions
    [figTRAJ, figMASS, figTHRmag] = plotLT( LT_TRANSFER.TRANSFER, param );

end

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
