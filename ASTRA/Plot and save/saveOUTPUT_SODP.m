function [OUTPUT] = saveOUTPUT_SODP(LEGSnext, VASnext, VINFnext, INPUT, runOpts, chosenRev, tocTOT)

% DESCRIPTION:
% This function saves various results from a space mission optimization process.
% It handles cases where no solutions are found and where solutions are available.
% It computes and saves the Pareto front, minimum cost path, and additional information.
% 
% INPUTS:
% LEGSnext   : Matrix of the next leg configurations.
% VASnext    : Matrix of the velocities associated with the next leg configurations.
% VINFnext   : Matrix of the inertias associated with the next leg configurations.
% INPUT      : Structure containing input parameters and functions, including cost functions.
% runOpts    : Options for running the mission optimization.
% chosenRev  : Vector of chosen revision options.
% tocTOT     : Total time of computation.
% 
% OUTPUT:
% OUTPUT     : Structure containing various results from the optimization process.
% 
% -------------------------------------------------------------------------

% --> save the results
if isempty(LEGSnext)
    % --> save the results
    OUTPUT.LEGSpf     = [];
    OUTPUT.VASpf      = [];
    OUTPUT.VINFpf     = [];
    OUTPUT.PF         = [];
    OUTPUT.LEGS       = [];
    OUTPUT.VAS        = [];
    OUTPUT.VINFa      = [];
    OUTPUT.COSTS      = [];
    OUTPUT.TOFYS      = [];
    OUTPUT.minPATH    = [];
    OUTPUT.minCOST    = [];
    OUTPUT.minTOFy    = [];
    OUTPUT.minDEFECT  = [];
    OUTPUT.minVINFd   = [];
    OUTPUT.minVINFa   = [];
    OUTPUT.chosenRevs = [];
    OUTPUT.tocTOT     = [];

    OUTPUT.ovPF       = [];
    OUTPUT.LEGovPF    = [];
    OUTPUT.VASovPF    = [];
    OUTPUT.VINFovPF   = [];
    OUTPUT.REVSovPF   = [];

else
    fprintf('Solutions found! \n');

    % --> cost function to be minimized on the final leg
    [minCOST, row, COSTS, TOFYS] = INPUT.costFunc2(LEGSnext, VASnext, VINFnext);

    % --> compute the Pareto front
    COSTm   = [ TOFYS COSTS ];
    PF      = paretoFront_MODP( COSTm );
    LEGSpf  = LEGSnext(PF(:,3),:);
    VVfpf   = VASnext(PF(:,3),:);
    VINFpf  = VINFnext(PF(:,3),:);

    % --> extract the minimum DV path
    minTOFy = TOFYS(row);
    minPATH = LEGSnext(row,:);
    minPATH = ASTRA_wrapPath_DP(minPATH(1:3:end-1), minPATH(2), diff(minPATH(2:3:end)), runOpts, INPUT.idcentral);

    % --> save the Pareto Front information
    OUTPUT.LEGSpf = LEGSpf;
    OUTPUT.VASpf  = VVfpf;
    OUTPUT.VINFpf = VINFpf;
    OUTPUT.PF     = PF;

    % --> save all the information
    OUTPUT.LEGS       = LEGSnext;
    OUTPUT.VAS        = VASnext;
    OUTPUT.VINFa      = VINFnext;
    OUTPUT.COSTS      = COSTS;
    OUTPUT.TOFYS      = TOFYS;

    % --> save the minimum DV path information
    OUTPUT.minPATH    = minPATH;
    OUTPUT.minCOST    = minCOST;
    OUTPUT.minTOFy    = minTOFy;
    OUTPUT.minDEFECT  = sum(minPATH(:,10));
    OUTPUT.minVINFd   = minPATH(1,9);
    OUTPUT.minVINFa   = minPATH(end,9);

    % --> save additional information
    OUTPUT.chosenRevs = chosenRev.*ones(size(LEGSnext,1), size(chosenRev,2));
    OUTPUT.tocTOT     = tocTOT;

    OUTPUT.ovPF       = [];
    OUTPUT.LEGovPF    = [];
    OUTPUT.VASovPF    = [];
    OUTPUT.VINFovPF   = [];
    OUTPUT.REVSovPF   = [];

end

end