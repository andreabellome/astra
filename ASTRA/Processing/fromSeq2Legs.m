function [legs, nlegs, nfbs, nplts] = fromSeq2Legs(SEQ)

% DESCRIPTION:
% This function processes a sequence of planetary encounters, converting it into a list of trajectory legs.
% It also calculates the number of legs, the number of flybys, and the total number of planets in the sequence.
% 
% INPUT:
% SEQ   : Vector representing the sequence of planetary encounters, where each element corresponds to a specific planet.
% 
% OUTPUT:
% legs  : Matrix where each row represents a trajectory leg, with the first column indicating the departure planet 
%         and the second column indicating the arrival planet.
% nlegs : Scalar representing the total number of trajectory legs.
% nfbs  : Scalar representing the number of flybys, calculated as the total number of legs minus one.
% nplts : Scalar representing the total number of planets in the sequence, calculated as the total number of legs plus one.
%
% -------------------------------------------------------------------------

ss        = SEQ;
ss(1)     = [];
ss(end+1) = NaN;

legs        = [SEQ; ss];
legs(:,end) = [];
legs        = legs';
nlegs       = size(legs,1);
nfbs        = nlegs - 1;
nplts       = nlegs + 1;

end