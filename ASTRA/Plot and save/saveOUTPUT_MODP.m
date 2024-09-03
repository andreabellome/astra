function [OUTPUT] = saveOUTPUT_MODP(LEGSnext, VASnext, VINFnext, INPUT, runOpts, chosenRev, tocTOT)

% DESCRIPTION
% This function saves the output results of a multi-objective optimization problem,
% including details of the optimal trajectory, associated costs, and other relevant metrics.
% 
% INPUT
% - LEGSnext  : Matrix containing the legs of the trajectory for each candidate solution.
% - VASnext   : Matrix containing the velocity vectors associated with the trajectory legs.
% - VINFnext  : Matrix containing the hyperbolic excess velocity vectors for each leg.
% - INPUT     : Struct containing various input parameters, including the cost function.
% - runOpts   : Matrix containing run-time options for the optimization process.
% - chosenRev : Vector indicating the chosen number of revolutions for each leg.
% - tocTOT    : Total elapsed time for the optimization process.
% 
% OUTPUT
% - OUTPUT    : Struct containing all relevant outputs of the optimization process.
%               This includes information about the Pareto front, the minimum cost path,
%               and additional metrics for performance analysis.
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

    % --> cost function to be minimized (multi-objective)
    [LEGSpf, VVfpf, VINFpf, PF, COSTS, TOFYS, minCOST, row] = INPUT.costFunc2_MODP(LEGSnext, VASnext, VINFnext);

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