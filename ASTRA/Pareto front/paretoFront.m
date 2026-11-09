function [ PP, idxs] = paretoFront( p )

% DESCRIPTION
% Filters a set of points P according to Pareto dominance, i.e., points
% that are dominated (both weakly and strongly) are filtered.
%
% INPUT
% - P    : N-by-D matrix, where N is the number of points and D is the
%          number of elements (objectives) of each point.
%
% OUTPUT
% - P    : Pareto-filtered P
% - idxs : indices of the non-dominated solutions
%
% Example:
% p = [1 1 1; 2 0 1; 2 -1 1; 1, 1, 0];
% [f, idxs] = paretoFront(p)
%     f = [1 1 1; 2 0 1]
%     idxs = [1; 2]
%
% IMPLEMENTATION NOTE (drop-in replacement, identical input/output)
% The original implementation scanned the set from the last point to the
% first and, for every surviving point, deleted all points it weakly
% dominates (O(N^2) with repeated row deletions). The surviving set it
% produces is characterised exactly by:
%   - rows with any NaN always survive (NaN comparisons are false, so they
%     never dominate and are never dominated);
%   - any other row survives iff no other row is <= in every objective
%     with at least one strict difference, and, among rows with identical
%     values, only the one with the HIGHEST index survives.
% This version computes that set directly:
%   - D == 2 : sort (f1 asc, f2 asc, index desc) + running minimum of f2,
%              O(N log N), fully vectorised;
%   - D ~= 2 : same lexicographic order, each row only tested against the
%              current non-dominated front, O(N*F).
% The final output assembly ([P idxs] + sortrows on column 2) is the same
% code as the original.
%
% -------------------------------------------------------------------------

PP               = p;
PP(PP(:,1)==0,:) = [];

[n, dim] = size(PP);
keep     = false(n, 1);

if n > 0
    nanRow       = any(isnan(PP), 2);
    keep(nanRow) = true;           % --> NaN rows can never be filtered
    ix           = find(~nanRow);  % --> rows taking part in dominance
    X            = PP(ix, :);
    m            = numel(ix);

    if m == 1
        keep(ix) = true;
    elseif m > 1
        % --> lexicographic order; equal points: highest index first
        [~, ord] = sortrows([X -ix], 1:dim+1);
        Xs       = X(ord, :);

        if dim == 2
            f2       = Xs(:,2);
            prevMin  = cummin(f2(1:end-1));
            survS    = [true; f2(2:end) < prevMin];
            keep(ix(ord(survS))) = true;
        else
            front  = zeros(m, dim);
            nf     = 0;
            survS  = false(m, 1);
            for k = 1:m
                x = Xs(k, :);
                if nf == 0 || ~any(all(front(1:nf, :) <= x, 2))
                    nf           = nf + 1;
                    front(nf, :) = x;
                    survS(k)     = true;
                end
            end
            keep(ix(ord(survS))) = true;
        end
    end
end

idxs = find(keep);
PP   = PP(keep, :);
PP   = [PP idxs];

PP = sortrows(PP, 2, 'descend');

end
