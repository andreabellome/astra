function [sequence] = generateOutputSequenceTXT(path)

% DESCRIPTION
% This function generates a textual representation of a sequence of planets 
% from a given trajectory path by converting each planet ID to a corresponding 
% symbol or name.
% 
% INPUT
% - path   : Matrix where each row represents a state in the trajectory 
%            with the 7th column indicating the planet ID.
% 
% OUTPUT
% - sequence : A string representing the sequence of planets in the trajectory, 
%              where each planet ID is replaced by a specific symbol or name.
% 
% -------------------------------------------------------------------------


sequence = [];
s = path(:,7);
for indi = 1:length(s)
    pl = s(indi);
    if pl == 1
        plSeq = '-M-';
    elseif pl == 2
        plSeq = '-V-';
    elseif pl == 3
        plSeq = '-E-';
    elseif pl == 4
        plSeq = '-M-';
    elseif pl == 5
        plSeq = '-J-';
    elseif pl == 6
        plSeq = '-S-';
    elseif pl == 7
        plSeq = '-U-';
    elseif pl == 8
        plSeq = '-N-';
    else
        plSeq = ['-' num2str(pl) '-'];
    end
    sequence = [sequence plSeq];
end

end