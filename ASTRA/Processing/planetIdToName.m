function [name] = planetIdToName(idPL, idcentral)

% DESCRIPTION
% This function converts a planet ID to its corresponding planet name. The planet IDs 
% are mapped to their respective names using a predefined list of planet names. If the 
% provided ID is out of the expected range, the function returns the ID as a string.
% 
% INPUT
% - idPL : Integer representing the ID of the planet (1 for Mercury, 2 for Venus, etc.).
% - idcentral : ID of the central body. See constants.m
% 
% OUTPUT
% - name : String containing the name of the planet corresponding to the given ID. 
%          If the ID is out of range, the function returns the ID itself as a string.
% 
% -------------------------------------------------------------------------

if nargin == 1
    idcentral = 1;
end

if idcentral == 1

    try
        names = {'Mercury', 'Venus  ', 'Earth  ', 'Mars   ', 'Jupiter', 'Saturn ', 'Uranus ', 'Neptune'};
        name  = char(names(idPL));
    catch
        name = num2str(idPL);
    end

elseif idcentral == 5
    
    names = {'Io', 'Europa  ', 'Earth  ', 'Ganimede   ', 'Callisto'};
    name  = char(names(idPL));

elseif idcentral == 6
    
    try
        names = {'Enceladus', 'Tethys  ', 'Dione  ', 'Rhea   ', 'Titan'};
        name  = char(names(idPL));
    catch
        name = num2str(idPL);
    end

elseif idcentral == 7

    try
        names = {'Miranda', 'Ariel  ', 'Umbriel  ', 'Titania   ', 'Oberon'};
        name  = char(names(idPL));
    catch
        name = num2str(idPL);
    end
    

end

end
