function [path, revs, res] = pathfromPF(OUTPUT, outNumber, rowPF)

% DESCRIPTION
% This function extracts a specific path and the associated parameters 
% from the Pareto Front (PF) results. If no specific row is provided, it 
% retrieves the best path based on the minimum cost.
% 
% INPUT
% - OUTPUT : Struct array containing results from multiple runs, including 
%            details like paths, revolutions, and costs.
% - outNumber : row ID of the OUTPUT structure.
% - rowPF  : Optional index specifying the row of the Pareto Front to extract. 
%            If not provided, the function selects the best path based on cost.
% 
% OUTPUT
% - path   : Matrix representing the trajectory path extracted from the specified 
%            Pareto Front row or the best path if no row is specified.
% - revs   : Array of revolutions corresponding to the specified Pareto Front row 
%            or the best path if no row is specified.
% - res    : Resolution used for the trajectory computation, either from the 
%            specified Pareto Front row or the best path if no row is specified.
% 
% -------------------------------------------------------------------------


if nargin == 2
    outNumber = 1;
    rowPF     = [];
elseif nargin == 3
    rowPF = [];
end

res = OUTPUT(1).res;
for indo = 1:length(OUTPUT)
    OUTPUT(indo).res = res;
end

if ~isempty(rowPF)
    
    revs    = OUTPUT(outNumber).REVSovPF(rowPF,:);
    res     = OUTPUT(outNumber).res;
    
    runOpts = generateDiffRuns(OUTPUT(outNumber).REVSovPF(rowPF,:), res);
    path    = OUTPUT(outNumber).LEGovPF(rowPF,:);
    path    = ASTRA_wrapPath_DP(path(1:3:end-1), path(2), diff(path(2:3:end)), runOpts);
else
    resonances = cell2mat({OUTPUT.res}');
    costs      = [ OUTPUT.minCOST ]';
    [~, row]   = min( costs );
    path       = OUTPUT(row).minPATH;
    revs       = OUTPUT(row).chosenRevs(1,:);
    if isempty(resonances)
        res = [];
    else
        res = resonances(1,:);
    end
end

end