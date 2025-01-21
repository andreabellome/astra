
warning('off','all');
rmpath(genpath(pwd));
pathASTRA = [pwd '/ASTRA'];
addpath(genpath(pathASTRA));

F = findall(0,'type','figure','tag','TMWWaitbar');
delete(F);
clear all;
close all;
clc;
format long g;
fclose('all');
clear ans;

currFolder = pwd;
newFolder  = [ pwd '/ASTRA/Lambert problem and defects' ];

% --> check if Lambert mex works on the current machine
try 
    [VI,VF] = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    disp( 'Lambert mex function available! All good.' );
catch
    cd(newFolder);
    disp( 'No Lambert mex function available... ASTRA creates it!!' );
    disp( 'Mexifying Lambert solver...' );
    codegen lambertMR_MEXIFY -args {zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1)}
    [VI,VF] = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    [VI,VF] = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    [VI,VF] = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    [VI,VF] = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    [VI,VF] = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    [VI,VF] = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    [VI,VF] = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    [VI,VF] = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    [VI,VF] = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    [VI,VF] = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    cd(currFolder);
    disp( 'Done!!' );
end

% --> check if defects mex works on the current machine
try
   [dv, alpha, alpha_A] = findDV_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1));
   disp( 'Defects mex function available! All good.' );
catch
    disp( 'No defects mex function available... ASTRA creates it!!' );
    disp( 'Mexifying defects function...' );
    cd(newFolder);
    codegen findDV -args {zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1)}
    [dv, alpha, alpha_A] = findDV_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1));
    [dv, alpha, alpha_A] = findDV_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1));
    [dv, alpha, alpha_A] = findDV_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1));
    [dv, alpha, alpha_A] = findDV_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1));
    [dv, alpha, alpha_A] = findDV_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1));
    [dv, alpha, alpha_A] = findDV_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1));
    [dv, alpha, alpha_A] = findDV_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1));
    [dv, alpha, alpha_A] = findDV_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1));
    cd(currFolder);
    disp( 'Done!!' );
end

% --> call mex functions for speed in main ASTRA
for ind = 1:100e3
    [VI,VF]              = lambertMR_MEXIFY_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1),zeros(1,1),zeros(1,1));
    [dv, alpha, alpha_A] = findDV_mex(zeros(1,3),zeros(1,3),zeros(1,1),zeros(1,1));
end

cd(currFolder);
clear VI; clear VF; clear dv; clear alpha; clear alpha_A; clear currFolder; clear newFolder; clear ind;

%%

% --> mexify also the low-thrust propagation functions
currFolder = pwd;
newFolder = [ pwd '/ASTRA/Low thrust/Propagation_optimal_control' ];

disp( 'Checking propagation functions for low-thrust module...' );
try
    propagateFopt_MEXIFY_mex(ones(1,1), ones(14,1), ones(1,5));
    disp( 'Fuel-optimal propagation mex function available! All good.' );
catch
    cd(newFolder);

    disp( 'No fuel-optimal propagation mex function available... ASTRA creates it!!' );
    disp( 'Mexifying fuel-optimal propagation function...' );

    codegen propagateFopt_MEXIFY -args {ones(1,1), ones(14,1), ones(1,5)};

    cd(currFolder);
    disp( 'Done!!' );
end

try
    
    propagateEopt_MEXIFY_mex(ones(1,1), ones(14,1), ones(1,5));
    disp( 'Energy-optimal propagation mex function available! All good.' );
catch
    cd(newFolder);
    
    disp( 'No energy-optimal propagation mex function available... ASTRA creates it!!' );
    disp( 'Mexifying energy-optimal propagation function...' );

    codegen propagateEopt_MEXIFY -args {ones(1,1), ones(14,1), ones(1,5)};

    cd(currFolder);
    disp( 'Done!!' );
end



%%

mu = 132724487690;
AU = 149597870.7;

