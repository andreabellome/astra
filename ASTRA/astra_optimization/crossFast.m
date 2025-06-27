function out = crossFast(r1,r2)

% crossFast.m - Fast cross product.
%
% PROTOTYPE:
%   out = crossFast(r1, r2)
%
% DESCRIPTION:
%   Very fast cross product. It requires about 1/10 of the time of cross.m.
%   The output is a row or column vector, as in the first input vector.
%
% INPUT:
%   r1[3]   First vector (row or column).
%   r2[3]   Second vector (row or column).
%
% OUTPUT:
%   out[3]  Cross product between r1 and r2. Row or column depending on r1.
%
% CALLED FUNCTIONS:
%   (none)
%
% AUTHOR:
%   Matteo Ceriotti, 12/02/2007, MATLAB, crossFast.m
%
% PREVIOUS VERSION:
%   Matteo Ceriotti, 12/02/2007, MATLAB, crossfast.m
%       - Header and function name in accordance with guidlines.
%
% CHANGELOG:
%   14/02/2007, REVISION: Camilla Colombo
%   30/12/2009, Camilla Colombo: Header and function name in accordance
%       with guidlines.
%
% -------------------------------------------------------------------------

if size(r1,1)==1
    out=[r1(2)*r2(3)-r1(3)*r2(2),r1(3)*r2(1)-r1(1)*r2(3),r1(1)*r2(2)-r1(2)*r2(1)];
else
    out=[r1(2)*r2(3)-r1(3)*r2(2),r1(3)*r2(1)-r1(1)*r2(3),r1(1)*r2(2)-r1(2)*r2(1)]';
end

return