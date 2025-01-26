function findFunctionOccurrences(folderPath, functionName)
    % Recursive search for occurrences of a function inside MATLAB files
    % folderPath   - Path to the folder to search
    % functionName - Function name to search for
    
    if nargin < 2
        error('Please provide both folderPath and functionName.');
    end

    % Get all .m files in folder and subfolders
    files = dir(fullfile(folderPath, '**', '*.m')); 

    % Search for the function name in each file
    for i = 1:length(files)
        filePath = fullfile(files(i).folder, files(i).name);
        
        % Read the content of the file
        fileContent = fileread(filePath);
        
        % Check if the function name exists in the file
        if contains(fileContent, functionName)
            fprintf('Function "%s" found in file: %s\n', functionName, filePath);
        end
    end
end
