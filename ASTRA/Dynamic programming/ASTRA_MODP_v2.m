function [OUTPUT] = ASTRA_MODP_v2(INPUT, seq)

% -------------------------------------------------------------------------
%
% MGA MULTI-OBJECTIVE (MO) OPTIMIZATION WITH DYNAMIC PROGRAMMING (DP)
%
% -------------------------------------------------------------------------

legs                                         = fromSeq2Legs(seq);  % --> find legs from the sequence
[vinflim, TOF_LIM, tstep, tofyMax, ~, ~, ~, ~,...
 costFunc1_MODP, costFunc2_MODP]             = check_INPUT(INPUT); % --> extract the limits on TOF and Vinf, and time step
INPUT.vInfLim                                = vinflim;            % --> update the INPUT
INPUT.tofyMax                                = tofyMax;            % --> update the INPUT
INPUT.costFunc1_MODP                         = costFunc1_MODP;     % --> update the INPUT
INPUT.costFunc2_MODP                         = costFunc2_MODP;     % --> update the INPUT

% --> run different optimizations for the chosen revolutions options
chosenRevs = INPUT.chosenRevs;

%% --> start the search

if INPUT.opt ~= 4
    clc;
end

% --> step 1
T0  = [INPUT.depOpts(1):INPUT.depOpts(3):INPUT.depOpts(2)]'; % --> launch date vector

col  = unique(chosenRevs(:,1));

for indc = 1:size(col,1)

    % --> solve the LP for the first leg for the specified MR options
    runOpts                                     = rev2RevOpt(col(indc,:), INPUT.res, 1);
    [LEGSnext, VASnext, VINFnext, tocV(1), nLP] = wrap_DynProgr_st1(T0, legs, runOpts, tstep, TOF_LIM, INPUT);
    [LEGSnext, VASnext, VINFnext]               = wrap_Pruning_DP_st1(LEGSnext, VASnext, VINFnext, INPUT);

    STRUC(indc).opt   = col(indc,:);
    STRUC(indc).LEGSn = LEGSnext;
    STRUC(indc).VASn  = VASnext;
    STRUC(indc).VINFn = VINFnext;

end
tocTOT = sum(tocV);

nSols = size(LEGSnext,1);

emptyIndex        = find(arrayfun(@(STRUC) isempty(STRUC.LEGSn),STRUC));
indemptyOPT       = [STRUC(emptyIndex).opt]';
STRUC(emptyIndex) = [];
indxs = [];
for indempty = 1:length(indemptyOPT)
    indxs = [indxs find( chosenRevs(:,1) == indemptyOPT(indempty))];
end
chosenRevs(indxs,:) = [];

MSSTRUC = struct('opt', []);
for indc = 1:size(chosenRevs,2)
    MSSTRUC(indc).opt = unique( chosenRevs(:,1:indc), 'rows', 'stable' );
end
MSSTRUC(1).STRUC = STRUC;

%% --> next legs

if ~isempty(MSSTRUC(1).STRUC)

    nDef = [];
    for indms = 2:length(MSSTRUC)
    
        opt = MSSTRUC(indms).opt;
        clear STRUC;
        for indmm = 1:size(opt,1)
    
            node  = opt( indmm, : );
            prevn = node(1:end-1);
            nextn = node(end);
    
            if indms == 2
                indxs = find( (abs(MSSTRUC(indms-1).opt - prevn)')' == 0 );
            else
                indxs = find(vecnorm(abs(MSSTRUC(indms-1).opt - prevn)')' == 0);
            end
    
            LEGSprev = MSSTRUC(indms-1).STRUC(indxs).LEGSn;
            VASprev  = MSSTRUC(indms-1).STRUC(indxs).VASn;
            VINFprev = MSSTRUC(indms-1).STRUC(indxs).VINFn;
    
            tic0 = tic;
            if isempty(LEGSprev) % --> no solutions available from previous node, stop the search here
                STRUC(indmm).opt   = prevn(end-1);
                STRUC(indmm).LEGSn = [];
                STRUC(indmm).VASn  = [];
                STRUC(indmm).VINFn = [];
            else
    
                Nrev = rev2RevOpt(nextn, INPUT.res, indms);
                if Nrev(3) ~= 0 % --> compute the resonant transfers
                    [LEGSn, VASn, VINFn] = wrapConstructionResonance_DP(LEGSprev, VASprev, VINFprev, legs, Nrev(3:4), indms, deg2rad(1), INPUT.parallel, INPUT.idcentral);
                    nlp  = 0;
                    ndef = 0;
                else % --> LP between two consecutive nodes
                    roptstemp            = zeros( length(MSSTRUC) , 4 );
                    roptstemp(indms,:)   = Nrev;
                    [LEGSn, VASn, VINFn, nlp, ndef] = wrap_MODP_st2(LEGSprev, VASprev, legs, roptstemp, indms, tstep, TOF_LIM, INPUT);
                end
                pn                 = opt(indmm,end);
                STRUC(indmm).opt   = pn;
                STRUC(indmm).LEGSn = LEGSn;
                STRUC(indmm).VASn  = VASn;
                STRUC(indmm).VINFn = VINFn;
    
                nSols = [nSols; size(LEGSn,1)];
                nLP   = [nLP; nlp];
                nDef  = [nDef; ndef];
    
            end
            tocTOT = tocTOT + toc(tic0);
            
            if INPUT.opt ~= 4
                toc(tic0)
            end
    
        end
        MSSTRUC(indms).STRUC = STRUC;
    
    end
    
%     nSols
%     nLP
%     nDef

else

    fprintf(':( ... no solutions with current settings ... :( \n' );

end

%% --> post process

MSFINAL = MSSTRUC(end);

OUTPUT = struct('LEGSpf', [], 'VASpf', [], 'VINFpf', [], 'PF', [], 'LEGS', [], ...
    'VAS', [], 'VINFa', [], 'COSTS', [], 'TOFYS', [], 'minPATH', [], 'minCOST', [], ...
    'minTOFy', [], 'minDEFECT', [], 'minVINFd', [], 'minVINFa', [], 'chosenRevs', [], 'tocTOT', [], ...
    'ovPF', [], 'LEGovPF', [], 'VASovPF', [], 'VINFovPF', [], 'REVSovPF', []);
if ~isempty(MSFINAL)

    STRUC                     = MSFINAL.STRUC;
    emptyIndex                = find(arrayfun(@(STRUC) isempty(STRUC.LEGSn),STRUC));
    MSFINAL.opt(emptyIndex,:) = [];
    STRUC(emptyIndex)         = [];

    chRevs = MSFINAL.opt;
    for inds = 1:length(STRUC)

        runOpts = generateDiffRuns(chRevs(inds,:), INPUT.res);
        LEGSn   = STRUC(inds).LEGSn;
        VASn    = STRUC(inds).VASn;
        VINFn   = STRUC(inds).VINFn;

        OUTPUT(inds) = saveOUTPUT_MODP(LEGSn, VASn, VINFn, INPUT, runOpts, chRevs(inds,:), tocTOT);

    end

end
hasNone           = cellfun(@isempty,{OUTPUT.LEGS});
OUTPUT(hasNone)   = [];

if ~isempty(OUTPUT)

    % --> compute the overall PF
    LEGSnext = cell2mat({OUTPUT.LEGS}');
    VASnext  = cell2mat({OUTPUT.VAS}');
    VINFnext = cell2mat({OUTPUT.VINFa}');
    REVS     = cell2mat({OUTPUT.chosenRevs}');

    [~, ~, ~, PF] = INPUT.costFunc2_MODP(LEGSnext, VASnext, VINFnext);

    OUTPUT(1).ovPF             = PF;
    OUTPUT(1).LEGovPF          = LEGSnext(PF(:,3),:);
    OUTPUT(1).VASovPF          = VASnext(PF(:,3),:);
    OUTPUT(1).VINFovPF         = VINFnext(PF(:,3),:);
    OUTPUT(1).REVSovPF         = REVS(PF(:,3),:);
    OUTPUT(1).res              = INPUT.res;
end

% --> plot the best path
try
    OUTPUT(1).TimeTOT = sum([OUTPUT.tocTOT]');
    if INPUT.plot(1) == 1
        [~, run] = min([OUTPUT.minCOST]');
        path     = OUTPUT(run).minPATH;
        plotPath(path, INPUT.idcentral);
    end
catch
end

% --> plot the Pareto front 
try
    if INPUT.plot(2) == 1
                
        % --> plot the overall Pareto front
        PF = OUTPUT.ovPF;
        figure('Color', [1 1 1]); hold on; grid on;
        xlabel( 'Time of flight - years' ); ylabel(' \Deltav - km/s ');
        plot( PF(:,1), PF(:,2), 'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Red' );

    end
catch
end

end