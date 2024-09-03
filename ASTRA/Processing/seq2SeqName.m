function [seqName] = seq2SeqName(seq, idcentral)

% DESCRIPTION
% This function converts a sequence of planet or celestial body IDs into a concatenated 
% string representing the sequence by name. If the ID corresponds to a known planet, 
% its name is retrieved and added to the sequence name; otherwise, the ID itself is 
% used as a string.
% 
% INPUT
% - seq : Array of integers representing the sequence of planet or celestial body IDs.
% - idcentral : ID of the central body. See constants.m
% 
% OUTPUT
% - seqName : A string representing the concatenated names of the planets or IDs in the sequence.
% 
% -------------------------------------------------------------------------

if nargin == 1
    idcentral = 1;
end

seqName = [];
for indi = 1:length(seq)
    try
        [planet] = planet_names_GA(seq(indi), idcentral);
    catch
        planet = num2str(seq(indi));
    end
    seqName = [seqName planet];
end

end
