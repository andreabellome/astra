function [NewStats, DSM_prediction, f1, f2] = convertDefect_STM(PATH, idcentral, customEphemerides)

if nargin == 1
    idcentral = 1;
    customEphemerides = @EphSS_cartesian;
elseif nargin == 2
    if isempty(idcentral)
        idcentral = 1;
    end
    customEphemerides = @EphSS_cartesian;
elseif nargin == 3
    if isempty(idcentral)
        idcentral = 1;
    end
    if isempty(customEphemerides)
        customEphemerides = @EphSS_cartesian;
    end
end


nlegs = size(PATH,1) - 1; % number of legs
ROWS  = 1:1:nlegs;

SEQ  = PATH(:,7)';
legs = fromSeq2Legs(SEQ);

if nargout > 2
    f1 = figure('Color', [1 1 1]);
    hold on; grid on;
    xlabel('Fraction time into leg'); ylabel('Leveraging ratio');

    vecx = [0 0];
    vecy = [0 0];
end

for indrow = 1:length(ROWS)
    
    row = ROWS(indrow);
    
    tof   = PATH(row+1, 11);
    tstep = tof/10;
    
    DSM_prediction(row) = wrap_computeSTM_DSM(PATH, row, tstep, idcentral, customEphemerides);
    tt0                 = DSM_prediction(row).TIME_SEG;
    ratio               = DSM_prediction(row).RATIOS;
    
    if nargout > 2
        %%%% plot %%%%
        seqName = seq2SeqName(legs(indrow,:));
        Legend{indrow} = ['Leg: ' seqName];
        hold on;
        plot(tt0/tt0(end), ratio, '-o', 'MarkerSize', 5, 'LineWidth', 2);
        %%%% plot %%%%
    end
    
end
if nargout > 2
    lgd            = legend(Legend);
    lgd.Location   = "northoutside";
    lgd.NumColumns = length(SEQ)-1;
end

Corr_TOF_days_NEW       = sum([DSM_prediction.CORR_TF]);
Total_COST_OLD          = PATH(1,12);
Total_TOFY_OLD          = PATH(1,16);
Total_COST_NEW          = PATH(1,9) + sum([DSM_prediction.DSM]);
Total_TOFY_NEW          = (Total_TOFY_OLD*365.25 + Corr_TOF_days_NEW)/365.25;

NewStats.Corr_TOF_days_NEW = Corr_TOF_days_NEW;
NewStats.Total_COST_OLD    = Total_COST_OLD;
NewStats.Total_COST_NEW    = Total_COST_NEW;
NewStats.Total_TOFY_OLD    = Total_TOFY_OLD;
NewStats.Total_TOFY_NEW    = Total_TOFY_NEW;

if nargout > 3
    f2 = plotPath(PATH, idcentral, customEphemerides);
end

end