function setInterpreterDefault

% DESCRIPTION
% This function sets the default text interpreter for all graphical elements
% in MATLAB figures to 'default', removing LaTeX or TeX formatting from
% titles, labels, legends, and other annotations. It loops through all
% interpreter-related factory settings and updates their corresponding default
% values. It also sets the default font size for axes.
%
% INPUT
% - none : no input arguments are required.
%
% OUTPUT
% - none : the default settings for text interpreters and font size are updated
%          globally for the current MATLAB session.
%
% -------------------------------------------------------------------------


list_factory      = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name, 'default');
end

% --> set the default font size
set(groot,'DefaultAxesFontSize', 12);

end