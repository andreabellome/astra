function [nDEF] = numberOfDefects(LEGSnext, TOFS)

% DESCRIPTION
% This function calculates the total number of unique defect cases based on
% the given legs data and time of flight (TOF) values. Each unique node 
% configuration in `LEGSnext` is paired with each TOF to compute the total 
% number of defect cases.
% 
% INPUT
% - LEGSnext : Matrix containing leg information. The last few columns are
%              used to identify unique nodes.
% - TOFS     : Array of time of flight values.
% 
% OUTPUT
% - nDEF     : Total number of unique defect cases, calculated as the product
%              of the number of unique nodes and the number of TOF values.
% 
% -------------------------------------------------------------------------

% --> unique nodes at LEGSnext * length(TOFS)
lastnodes      = LEGSnext(:, end-4:end);
lastnodes(:,3) = [];
lastnodes      = unique(lastnodes, 'rows', 'stable');
nLN            = size(lastnodes,1);
nTOF           = length(TOFS);
nDEF           = nLN * nTOF;

end