
% --> OPTIONAL INPUT for ASTRA <--

% INPUT.TOF_LIM = [[30 400]; [100 470]; [30 400]; [400 2000]; [1000 6000]]; % --> Saturn transfer ESA-ACT problem
% INPUT.TOF_LIM = [[90 180]; [448 673]; [90 220]; [260 352]];               % --> BepiColombo problem (as from Ceriotti PhD Thesis), use maxrev = 3

% INPUT.tofyMax   = 8;  % --> (years) maximum TOF

% INPUT.vInfLim = [ [0 1e99]; [0 1e99]; [0 1e99]; [0 1e99]; [9.5 1e99]];   % --> PL1, PL2, PL3, ...   
% INPUT.vInfLim = [3.3	5.7
%                  6.8	11.2
%                  6.8	11.2
%                  12.8	15.7
%                  5.3	11.2
%                  2.3	6.7]; % --> CASSINI from TG
% INPUT.vInfLim = [2.3	5.7
%                  2.8	11.2
%                  4.8	14.7
%                  8.3	15.7
%                  8.3	15.7
%                  5.3	7.7]; % --> JUICE from TG
% % --> EVEEJ from TG
% perc    = 0.5;
% vInfLim = [0   5
%            0   10
%            0   14
%            0   14
%            0   Inf]; % --> EVEEJ from TG (NO-DSM)
% INPUT.vInfLim = vInfLim + [-perc +perc].*ones(size(vInfLim,1),2);

% % --> EVEEJ-CENT from TG
% perc    = 0.5;
% vInfLim = [0   5
%            0   10
%            0   14
%            0   14
%            0   Inf
%            0   4]; % --> EVEEJ from TG (NO-DSM)
% INPUT.vInfLim = vInfLim + [-perc +perc].*ones(size(vInfLim,1),2);

% % --> JUICE from TG
% perc    = 0.5;
% vInfLim = [0   5
%            0   10
%            0   14
%            0   17
%            0   17
%            0   Inf]; (NO-DSM)
% INPUT.vInfLim = vInfLim + [-perc +perc].*ones(size(vInfLim,1),2);

% % --> CASSINI from TG
% perc    = 0.5;
% vInfLim = [ 0  5;
%             0  10;
%             0  10;
%             0  16;
%             0  14;
%             0  9 ]; % --> CASSINI from TG (NO-VILT and NO-DSM)
% INPUT.vInfLim = vInfLim + [-perc +perc].*ones(size(vInfLim,1),2);

% -------------------------------------------------------------------------
% --> SODP/MODP - user defined functions <--
%
% --> SODP - user defined functions <--
INPUT.costFunc1      = []; % --> user specifies the cost function (see costFunction1_DP.m for reference)
INPUT.costFunc2      = []; % --> user specifies the cost function (see costFunction2_DP.m for reference)
% --> MODP - user defined functions <--
INPUT.costFunc1_MODP = []; % --> user specifies the cost function (see costFunction1_MODP.m for reference)
INPUT.costFunc2_MODP = []; % --> user specifies the cost function (see costFunction2_MODP.m for reference)
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% --> SODP/MODP - user defined functions <--
%
% --> SODP - user defined functions <--
INPUT.costFunc1      = @(legn, vvf, vinff) costFunction1_DP; % --> user specifies the cost function (see costFunction1_DP.m for reference)
INPUT.costFunc2      = @(legn, vvf, vinff) costFunction2_DP; % --> user specifies the cost function (see costFunction2_DP.m for reference)
% --> MODP - user defined functions <--
INPUT.costFunc1_MODP = @(legn, vvf, vinff) costFunction1_MODP; % --> user specifies the cost function (see costFunction1_MODP.m for reference)
INPUT.costFunc2_MODP = @(legn, vvf, vinff) costFunction2_MODP; % --> user specifies the cost function (see costFunction2_MODP.m for reference)
% -------------------------------------------------------------------------


% --> some problem-specific objective function
% INPUT.costFunc1    = @(legn, vvf, vinff) costFunction1_DP_vdep(legn, vvf, vinff, vdep, sigma);
% INPUT.costFunc2    = @(legn, vvf, vinff) costFunction2_DP_onlyDef(legn, vvf, vinff, vdep, varr, sigma, impvarr);

% --> example functions for modified dynamic programming (DP+N)
% N               = 1;
% INPUT.costFunc1 = @(legn, vvf, vinff) costFunction1_DP_N(legn, vvf, vinff, N);
% INPUT.costFunc2 = @(legn, vvf, vinff) costFunction2_DP(legn, vvf, vinff);
