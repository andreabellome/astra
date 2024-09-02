
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

mu = 132724487690;
AU = 149597870.7;
