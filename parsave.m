function parsave(folder_path, filename, name1, name2)

% Load variables from caller's workspace
var1 = evalin('caller', name1);
var2 = evalin('caller', name2);

S.(name1) = var1;
S.(name2) = var2;

% save(fullfile(folder_path, filename), name1, name2);
save(fullfile(folder_path, filename), '-struct', 'S');

end
