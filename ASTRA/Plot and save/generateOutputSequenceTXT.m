function [sequence] = generateOutputSequenceTXT(path, idcentral)

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

if nargin == 1
    idcentral = 1;
end

sequence = [];
s = path(:,7);

if idcentral == 1

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

elseif idcentral == 5

    for indi = 1:length(s)
        pl = s(indi);
        if pl == 1
            plSeq = '-I-';
        elseif pl == 2
            plSeq = '-E-';
        elseif pl == 3
            plSeq = '-G-';
        elseif pl == 4
            plSeq = '-C-';
        else
            plSeq = ['-' num2str(pl) '-'];
        end
        sequence = [sequence plSeq];
    end

elseif idcentral == 6

    for indi = 1:length(s)
        pl = s(indi);
        if pl == 0
            plSeq = '-Mi-';
        elseif pl == 1
            plSeq = '-E-';
        elseif pl == 2
            plSeq = '-Te-';
        elseif pl == 3
            plSeq = '-D-';
        elseif pl == 4
            plSeq = '-R-';
        elseif pl == 5
            plSeq = '-T-';
        else
            plSeq = ['-' num2str(pl) '-'];
        end
        sequence = [sequence plSeq];
    end

elseif idcentral == 7

    for indi = 1:length(s)
        pl = s(indi);
        if pl == 1
            plSeq = '-M-';
        elseif pl == 2
            plSeq = '-A-';
        elseif pl == 3
            plSeq = '-U-';
        elseif pl == 4
            plSeq = '-T-';
        elseif pl == 5
            plSeq = '-O';
        else
            plSeq = ['-' num2str(pl) '-'];
        end
        sequence = [sequence plSeq];
    end

end

end
