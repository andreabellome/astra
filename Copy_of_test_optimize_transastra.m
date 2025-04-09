
clearDeleteAdd;

%%

astra_opt_path = './astra_optimization';
addpath(genpath(astra_opt_path)); % --> always include this

% --> EVVEJS CASSINI (CASE 2 , maxDEF = 2)
path = [83357182.7938216	122144966.489154	0	-21.3125589118966	16.0591389769358	1.36147148941160	3	-774.500000000000	4.06463082193552	0	NaN	12.3540640367320	NaN	4.06463082193552	5.51743490947101	6.52156057494867
        75874005.0931181	-77984748.9930172	-5446145.43943063	30.5148457472840	20.5890514046776	-0.694570691574324	2	-591.500000000000	6.76095313102856	0	183	NaN	NaN	NaN	NaN	NaN
        -44979905.0787617	-98731571.6562844	1246514.86661220	39.2941478639635	-10.6952851008470	-2.41450576777515	2	-185.500000000000	8.64355095137448	1.89419792035145	406	NaN	NaN	NaN	NaN	NaN
        126331554.492258	-83416971.1296190	0	30.3615543521565	17.6280672494083	-0.365668684224592	3	-134.500000000000	16.0968190941379	0.658951169481211	51	NaN	NaN	NaN	NaN	NaN
        266187532.507116	706946599.622507	-8874306.82949551	-3.64600959999793	11.1058937908336	-0.0874493787117127	5	367.500000000000	10.5436321370543	0.125502222171885	502	NaN	NaN	NaN	NaN	NaN
       -354519980.553090	1304210598.47627	-8676311.97379129	-5.39848604507999	0.693955660111735	0.0427963357571683	6	1607.50000000000	5.51743490947101	0.0933469933208819	1240	NaN	NaN	NaN	NaN	NaN];
revs = [ 0 0 0 0 0 ]; res = []; INPUT.customEphemerides = @EphSS_cartesian; idcentral = 1; INPUT.idcentral = idcentral;

% -- EVVEJS GO 10y (CASE 2 , maxDEF = 2)
path = [95882013.1410819	112841173.625676	0	-19.0532136867464	18.6454670759556	1.33708506978717	3	-780.500000000000	4.37706569165528	0	NaN	10.6244229538681	NaN	4.37706569165528	4.22203334902512	9.67556468172485
        75874005.0931181	-77984748.9930172	-5446145.43943063	30.6892358409403	20.3555823527826	-0.513161701888350	2	-591.500000000000	7.04795913112873	0	189	NaN	NaN	NaN	NaN	NaN
        -53011865.5087109	-94587976.2888437	1766757.97109681	38.4344538386856	-13.4738944797404	-2.40286127696028	2	-188.500000000000	8.98252811958246	1.94674543631167	403	NaN	NaN	NaN	NaN	NaN
        126331554.492258	-83416971.1296190	0	29.7982607311388	17.6392009259240	-0.508725518057614	3	-134.500000000000	15.5927194504147	0.0691467780447326	54	NaN	NaN	NaN	NaN	NaN
        160900297.934110	742710038.065352	-6667751.08538494	-5.74719179261507	7.44460217383964	-0.0286652281350589	5	463.500000000000	8.25805572223440	0.00580444582955053	598	NaN	NaN	NaN	NaN	NaN
        -1161237706.06952	745006175.919138	33168418.2494910	-2.19733509516937	-5.86667230124414	0.0805845654609753	6	2753.50000000000	4.22203334902512	0.00362725300177402	2290	NaN	NaN	NaN	NaN	NaN];
revs = [ 0 0 0 0 0 ]; res = []; INPUT.customEphemerides = @EphSS_cartesian; idcentral = 1; INPUT.idcentral = idcentral;

% --> EVEMEJ
path = [-69696439.6766746	-134485723.985962	0	24.0041418768140	-12.1708073815906	1.99243968164407	3	8543.50000000000	3.24691687427682	0	NaN	8.84487761413906	NaN	3.24691687427682	5.57330974811903	6.49828884325804
        38731915.9129593	100675226.665445	-883597.072361171	-34.9753372625767	14.3376933919349	-2.78741301395158	2	8693	5.65288598898769	0	149.500000000000	NaN	NaN	NaN	NaN	NaN
        140565276.656156	-55143319.8811304	0	1.95046738002581	29.8735865757617	-0.233644547359137	3	9009	8.74421145707806	0.00458148470054809	316	NaN	NaN	NaN	NaN	NaN
        -151254658.253900	194034559.363643	7776113.68944067	-23.4385105578510	-4.39589848787397	-0.784594990457204	4	9172.50000000000	9.96859663353003	0.000193116780906166	163.500000000000	NaN	NaN	NaN	NaN	NaN
        67683770.4888032	131263396.467816	0	-25.2945340380378	24.6170210602324	1.17545514269314	3	9824.50000000000	11.2658075273830	0.0192146930154529	652	NaN	NaN	NaN	NaN	NaN
        -626828280.398470	-516380266.192195	16178556.1527699	5.06053128917007	-4.84292080272362	-0.339113772247543	5	10917	5.57330974811903	0.000661697246298942	1092.50000000000	NaN	NaN	NaN	NaN	NaN];
revs = [ 0 0 0 0 0 ]; res = []; INPUT.customEphemerides = @EphSS_cartesian; idcentral = 1; INPUT.idcentral = idcentral;

% --> MERCURY
path = [ 94291826.1071534	-119025638.282577	0	20.0778714782710	16.2934405258686	-1.44466310969689	3	2038	3.77363084179249	0	NaN	11.4055073660187	NaN	3.77363084179249	3.81155730148189	5.84804928131417
        -103519158.171651	-29876705.1044851	5570416.83652407	3.05487152031187	-37.0448359607597	1.15150680393998	2	2480	7.51163408558769	0	442	NaN	NaN	NaN	NaN	NaN
        -66109723.6132968	-85790081.8530333	2651020.83245534	25.2632904213834	-13.6694541664251	-1.64421856674665	2	2952	8.18555275343221	1.23972958146915	472	NaN	NaN	NaN	NaN	NaN
        53306847.3025174	-2298488.98996823	-5088229.41679820	-10.6516292886920	55.9788545874131	3.30867748779935	1	3286	6.31513785801622	0.394622409698778	334	NaN	NaN	NaN	NaN	NaN
        47729952.3576664	15458485.1653753	-3128834.41387822	-25.2253522525467	53.4075160939301	6.67030343775173	1	3554	4.99245521215563	1.09443599923291	268	NaN	NaN	NaN	NaN	NaN
        51085790.9704228	7297356.28511674	-4103280.61673098	-18.4763859167580	54.7595340337823	6.16670311946911	1	3816	4.91666506166948	0.193070415475354	262	NaN	NaN	NaN	NaN	NaN
        35563029.8365665	31567492.7783662	-699207.059392240	-43.2155963737057	42.0570050219717	7.39922291584013	1	4174	3.81155730148189	0.898460816868162	358	NaN	NaN	NaN	NaN	NaN ];
revs = [ 10 31 21	21 10 31 ]; res = []; INPUT.customEphemerides = @EphSS_cartesian; idcentral = 1; INPUT.idcentral = idcentral;

%%

% idcentral = 1;
% 
% % load('wksp_ceres_2041_emC.mat');
% load('wksp_ceres_2041_eveejC.mat');
% % load('wksp.mat'); revs = [ 0 0 ];
% 
% load('wksp_transastra.mat');
% to_go = true;
% if to_go == true
%     path = path_to_go;
%     revs = revs_to_go(row,:);
% else
%     path = path_to_re;
%     revs = revs_to_re(row,:);
% end
% 
% % --> load custom ephemerides
% MICE_path = './MICE_TOOLBOX' ;
% addpath(genpath(MICE_path)); % --> always include this
% 
% astra_opt_path = './astra_optimization';
% addpath(genpath(astra_opt_path)); % --> always include this
% 
% % --> load the kernels
% cspice_furnsh( { [MICE_path '/' num2str(max(seq)) '_new.bsp'],...                         % --> this is for the asteroid
%                  [MICE_path '/de435.bsp'],...                                         % --> this is for Earth
%                  [MICE_path '/mar097.bsp'],...                                        % --> this is for Mars
%                  [MICE_path '/naif0012.tls'] } );                                     % --> this is for time system

%%

% --> number of DSM w.r.t. the number of revolutions per leg
[NmanLeg] = revs2NmanLeg(revs);
% NmanLeg(NmanLeg ~= 1)     = NmanLeg(NmanLeg ~= 1) - 1;

% --> set the bounds
t0days      = 30;
tofperc     = 10/100;
rpperc      = 90/100;
ksperc      = 90/100;
optFirstMan = 0;
vinfMin     = 3;
vinfMax     = 4.8;
dvsMaxMag   = 0.5;

% --> find lower/upper bounds
[ t0Min, t0Max, TOFMin, TOFMax, rpMin, rpMax, etaMin, etaMax, seq, path ] = ...
            minMaxFromPath(path, t0days, tofperc, rpperc, ksperc);
[dvsMin, dvsMax] = minMaxDVS(dvsMaxMag, NmanLeg);
[epsMin, epsMax] = minMaxEps(NmanLeg);
[dv1Min, dv1Max] = minMaxFirstMan(vinfMin, vinfMax, optFirstMan, NmanLeg);
lb               = [ t0Min TOFMin dv1Min dvsMin epsMin etaMin rpMin ];
ub               = [ t0Max TOFMax dv1Max dvsMax epsMax etaMax rpMax ];

struc_revs_man.revs       = revs;
struc_revs_man.NmanLeg    = NmanLeg;
struc_revs_man.vinfMax    = vinfMax;
struc_revs_man.vinfMaxArr = path(end,9);
struc_revs_man.dvsMaxMag = 1;

costFun                = @(x) wrap_mga_nDSM(seq, x, struc_revs_man, INPUT.customEphemerides);

%%

close all; clc;

% --> optimize
maxit      = 1;
optionsPSO = optPSO(lb, ub);
sol        = zeros(maxit, length(lb));
fval       = zeros(maxit, 1);
for ind = 1:maxit
    [sol(ind,:), fval(ind,:)] = particleswarm(costFun, length(lb), lb, ub, optionsPSO);
end

[minc, row] = min(fval);
minsol      = sol(row,:);

close all; clc;
[DV, dv, t0, tofs, MAT, output] = wrap_mga_nDSM(seq, minsol, struc_revs_man, INPUT.customEphemerides, 1);

%%

for indou = 1:length(output)
    
    output(indou).tt = output(indou).times;
    output(indou).yy = output(indou).guess';

end

%%

customEphemerides = INPUT.customEphemerides;

vdep = 5; % --> free
varr = 10; % --> free (0 implies a rendezvous -- match position and velocity with final planet)

for inds = 1:size(MAT,1)
    
    struc(inds).idD = MAT(inds,1);
    struc(inds).idA = MAT(inds,3);

    struc(inds).tD  = MAT(inds,2);
    struc(inds).tA  = MAT(inds,4);
    
    rrd = output(inds).yy(1,1:3);
    vvd = output(inds).yy(1,4:6);
    
    rra = output(inds).yy(end,1:3);
    vva = output(inds).yy(end,4:6);

    if inds == 1
        
        % --> start: first leg of the transfer
        p0           = MAT(inds,1);
        t0           = MAT(inds,2);
        [rrga, vvga] = customEphemerides(p0, t0, idcentral);
        if norm(vvga - vvd(1,:)) > vdep % --> DSM on the first leg
            vvinfPM = vvd(1,:) - vvga;
            vvinfPM = vdep.*vvinfPM./norm( vvinfPM ) ;
            vvBM    = vvinfPM + vvga;
        else
            vvBM     = vvd(1,:);
            dv(inds) = 0;
        end
        vvdTar = vvBM;
        % --> end: first leg of the transfer

    else
        vvdTar = vvd;
    end
    
    % --> these are for LT
    struc(inds).xxDtar    = [ rrd(1,:) vvdTar(1,:) ];
    struc(inds).xxAtar    = [ rra(1,:) vva(1,:) ];

    % --> these are from Lambert
    struc(inds).xxDlam    = [ rrd(1,:) vvd(1,:) ];
    struc(inds).xxAlam    = [ rra(1,:) vva(1,:) ];
    
    if struc(inds).idD < 1e99
        [rrga1, vvga1] = customEphemerides(struc(inds).idD, struc(inds).tD, idcentral);
    else
        rrga1 = rrd;
        vvga1 = vvd;
    end
    statesObjDep = [ rrga1, vvga1 ];

    if struc(inds).idA < 1e99
        [rrga2, vvga2] = customEphemerides(struc(inds).idA, struc(inds).tA, idcentral);
    else
        rrga2 = rra;
        vvga2 = vva;
    end
    statesObjArr = [ rrga2 vvga2 ];

    % --> these are of the objects
    struc(inds).xxObjD = statesObjDep(1,:);
    struc(inds).xxObjA = statesObjArr(1,:);

    struc(inds).dvvD = [NaN NaN NaN];
    struc(inds).dvvA = [NaN NaN NaN];

    dvD = dv(inds);

    if inds == size(MAT,1)
        dvA = dv(inds+1);
    else
        dvA = 0;
    end

    struc(inds).dvD = norm( dvD );
    struc(inds).dvA = norm( dvA );

end

% --> start: last leg of the transfer
p1           = MAT(end,3);
t1           = MAT(end,4);
[~, vvga]    = customEphemerides(p1, t1, idcentral);

vva = output(end).yy(end,4:6);
if norm(vvga - vva(end,:)) > varr % --> DSM on the first leg
    dvv  = abs( norm(vvga - vva(end,:)) - varr ).*(vvga - vva(end,:))./norm(vvga - vva(end,:));
    vvPM = vva(end,:) + dvv;
else
    vvPM = vva(end,:);
    dvv  = vvPM - vva;
end
vvaTAR        = vva;
vvaTAR(end,:) = vvPM;

struc(end).xxAtar = [ rra(1,:) vvaTAR(1,:) ];
struc(inds).dvA   = norm( dvv );
% --> end: last leg of the transfer

IDA   = [ struc.idA ];
IDD   = [ struc.idD ];

indxsIDD = find( IDD < 1e99 )';
indxsIDA = find( IDA < 1e99 )';

indxs = [ indxsIDD, indxsIDA ];

for indddd = 1:size(indxs,1)
    
    strucNew(indddd).idD = struc(indxs(indddd,1)).idD;
    strucNew(indddd).idA = struc(indxs(indddd,2)).idA;

    strucNew(indddd).tD = struc(indxs(indddd,1)).tD;
    strucNew(indddd).tA = struc(indxs(indddd,2)).tA;

    strucNew(indddd).xxDtar = struc(indxs(indddd,1)).xxDtar;
    strucNew(indddd).xxAtar = struc(indxs(indddd,2)).xxAtar;

    
    strucNew(indddd).xxDlam = struc(indxs(indddd,1)).xxDlam;
    strucNew(indddd).xxAlam = struc(indxs(indddd,2)).xxAlam;

    strucNew(indddd).xxObjD = struc(indxs(indddd,1)).xxObjD;
    strucNew(indddd).xxObjA = struc(indxs(indddd,2)).xxObjA;
    
    strucNew(indddd).dvvD = struc(indxs(indddd,1)).dvvD;
    strucNew(indddd).dvvA = struc(indxs(indddd,2)).dvvA;

    strucNew(indddd).dvD = sum([struc(indxs(indddd,1):indxs(indddd,2)).dvD]);
    strucNew(indddd).dvA = sum([struc(indxs(indddd,1):indxs(indddd,2)).dvA]);

end

struc = strucNew;

%%

% --> define low-thrust parameters
lowThrustParameters.Tmax        = 0.6;      % --> max. thrust                       [N]
lowThrustParameters.Isp         = 3000;     % --> specific impulse                  [s]
lowThrustParameters.m0          = 2000;     % --> initial mass                      [kg]    
lowThrustParameters.g0          = 9.80665;  % --> Earth acceleration at sea level   [m/s]

lowThrustParameters.gamma       = 0.5;      % --> discount factor for the smoothing parameter (default is 0.5)
lowThrustParameters.plot        = true;     % --> this plots the thrust evolution over time for different rho (default is false)
lowThrustParameters.useParallel = true;     % --> if true, uses parallel for fsolve (default is false)


Tmax = lowThrustParameters.Tmax;
Isp  = lowThrustParameters.Isp;
m0   = lowThrustParameters.m0;

if isfield(lowThrustParameters, 'useParallel')
    useParallel = lowThrustParameters.useParallel;
else
    useParallel = false;
end

if isfield(lowThrustParameters, 'g0')
    g0 = lowThrustParameters.g0;
else
    g0 = 9.80665;
end

if isfield(lowThrustParameters, 'gamma')
    gamma = lowThrustParameters.gamma;
else
    gamma = 0.5;
end

if isfield(lowThrustParameters, 'rhoLim')
    rhoLim = lowThrustParameters.rhoLim;
end

if isfield(lowThrustParameters, 'plot')
    plotParam = lowThrustParameters.plot;
else
    plotParam = false;
end

% --> solve the problem
strucToSave = struct( 'LTsol', cell(1, length(struc)), ...
    'm0', cell(1,length(struc)), 'mf', cell(1, length(struc)), 'mp', cell(1, length(struc)), ...
    'DV', cell(1, length(struc)), 'tof', cell(1, length(struc)), 'cumulative_tof',  cell(1, length(struc)));
for inds = 1:length(struc)

    state1 = struc(inds).xxDtar;
    state2 = struc(inds).xxAtar;
    tof    = ( struc(inds).tA - struc(inds).tD ) * 86400;
    dvD    = struc(inds).dvD;
    dvA    = struc(inds).dvA;
    accel  = ( dvD + dvA )*1000/tof;
    revopt = rev2RevOpt(revs(inds), res, inds);
    
    if dvD + dvA == 0 % --> possibly this is the first leg

        param        = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, revopt(1), INPUT.idcentral, useParallel);
    
        % --> simple propagation without thrusting
        [tt, yy] = propagateKepler(state1(1:3), state1(4:6), linspace(0, tof, 1e3), param.mu);

        transfer = [ tt./86400, yy, m0.*ones(size(yy,1),1), zeros(size(yy,1),4) ];

        LTsol.transfer = transfer;
        LTsol.lambdas  = zeros( 1,7 );
        LTsol.Tmax     = param.Tmax;
        LTsol.Isp      = param.Isp;
        LTsol.g0       = param.g0;
        LTsol.m0       = m0;
        LTsol.mf       = m0;
        LTsol.tof      = tof / 86400;
        LTsol.DV       = 0;
        LTsol.param    = param;
        LTsol.success  = true;

        % --> new initial mass
        m0                      = LTsol.mf; % --> new initial mass
        strucToSave(inds).LTsol = LTsol;

    else

        if revopt(3) == 0 
    
            if accel * 2 <= Tmax/m0
        
                % --> initialise the parameters
                param        = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, revopt(1), idcentral, useParallel);
    
                % --> extract additional plots
                param.plot   = plotParam;    % --> this plots the thrust evolution over time for different rho (default is false)            
                param.gamma  = gamma;
                if isfield(lowThrustParameters, 'rhoLim')
                    param.rhoLim = rhoLim;
                end
    
                if dvD + dvA <= 0.1
                    param.rhoLim = 0.01;
                end
    
                if dvD + dvA >= 1
                    param.rhoGuess1 = 0.5;
                    param.rhoGuess2 = 0.75;
                    
                    if param.Nrev > 0
                        param.gamma     = 0.9;
                    end
                end

                if param.Nrev > 0
                    param.rhoGuess1 = 0.75;
                    param.gamma     = 0.9;
                end
                
                % --> solve the problem
                LTsol = wrapSolveFopt( param );
                
                % --> new initial mass
                m0                      = LTsol.mf; % --> new initial mass
                strucToSave(inds).LTsol = LTsol;
    
            else
                
                fprintf( 'Thrust system is not enough on leg: %d: \n', inds );
                LT_SOLUTION = strucToSave;
                break;
            
            end
    
        else % --> there is a resonance in this leg
            
            param        = processDataAndWriteParam(m0, tof, state1, state2, Tmax, Isp, g0, revopt(1), INPUT.idcentral, useParallel);
    
            % --> simple propagation without thrusting
            [tt, yy] = propagateKepler(state1(1:3), state1(4:6), linspace(0, tof, 1e3), param.mu);
    
            transfer = [ tt./86400, yy, m0.*ones(size(yy,1),1), zeros(size(yy,1),4) ];
    
            LTsol.transfer = transfer;
            LTsol.lambdas  = zeros( 1,7 );
            LTsol.Tmax     = param.Tmax;
            LTsol.Isp      = param.Isp;
            LTsol.g0       = param.g0;
            LTsol.m0       = m0;
            LTsol.mf       = m0;
            LTsol.tof      = tof / 86400;
            LTsol.DV       = 0;
            LTsol.param    = param;
            LTsol.success  = true;
    
            % --> new initial mass
            m0                      = LTsol.mf; % --> new initial mass
            strucToSave(inds).LTsol = LTsol;
    
        end

    end

end

% --> process the output
LT_SOLUTION = strucToSave;

for inds = 1:length(LT_SOLUTION)

    if ~isempty(LT_SOLUTION(inds).LTsol)
        
        LT_SOLUTION(inds).m0             = LT_SOLUTION(inds).LTsol.m0;
        LT_SOLUTION(inds).mf             = LT_SOLUTION(inds).LTsol.mf;
        LT_SOLUTION(inds).mp             = LT_SOLUTION(inds).LTsol.m0 - LT_SOLUTION(inds).LTsol.mf;
        LT_SOLUTION(inds).DV             = LT_SOLUTION(inds).LTsol.DV;
        LT_SOLUTION(inds).tof            = LT_SOLUTION(inds).LTsol.tof;
        if inds == 1
            LT_SOLUTION(inds).cumulative_tof = LT_SOLUTION(inds).LTsol.tof;
        else
            LT_SOLUTION(inds).cumulative_tof = LT_SOLUTION(inds-1).LTsol.tof + LT_SOLUTION(inds).LTsol.tof;
        end

    end

end


