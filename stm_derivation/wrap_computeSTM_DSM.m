function [DSM_prediction] = wrap_computeSTM_DSM(PATH, row, tstep, idcentral, customEphemerides)

if nargin == 3
    idcentral = 1;
    customEphemerides = @EphSS_cartesian;
elseif nargin == 4
    if isempty(idcentral)
        idcentral = 1;
    end
    customEphemerides = @EphSS_cartesian;
elseif nargin == 5
    if isempty(idcentral)
        idcentral = 1;
    end
    if isempty(customEphemerides)
        customEphemerides = @EphSS_cartesian;
    end
end

tof = PATH(row+1, 11);
tt0 = 0:tstep:tof;

dv     = zeros(length(tt0),1);
tf     = zeros(length(tt0),1);
ratio  = zeros(length(tt0),1);
defect = zeros(length(tt0),1);
dvv    = zeros(length(tt0),3);
rr1    = zeros(length(tt0),3);
vv1    = zeros(length(tt0),3);
DU     = zeros(length(tt0),4);
CC     = zeros(4,4,length(tt0));
TOF    = zeros(length(tt0),1);

for indi = 1:length(tt0)
    t0 = tt0(indi);
    [dv(indi,1), tf(indi,1), ratio(indi,1),  defect(indi,1),...
        dvv(indi,:), rr1(indi,:), vv1(indi,:), DU(indi,:), CC(:,:,indi), TOF(indi,1)] =...
        computeSTM_DSM_v2(PATH, row, t0, idcentral, customEphemerides);
end

% when the ratio is max, there is the maximum correction of the defect
[rmax, row] = max(ratio);
TM          = tt0(row);
DSM         = dv(row,1);
TF          = tf(row,1);
RR1         = rr1(row,:);
VV1         = vv1(row,:);

DSM_prediction.segment  = row;
DSM_prediction.TIME_SEG = tt0;
DSM_prediction.DVS      = dv;
DSM_prediction.TFS      = tf;
DSM_prediction.RATIOS   = ratio;
DSM_prediction.DEFECT   = defect(1,1);
DSM_prediction.RR1s     = rr1;
DSM_prediction.VV1s     = vv1;
DSM_prediction.CCs      = CC;
DSM_prediction.TOFS     = TOF(1);

DSM_prediction.MAX_RATIO  = rmax;
DSM_prediction.MAN_TOF    = TM;
DSM_prediction.Alpha      = TM/TOF(1);
DSM_prediction.DSM        = DSM;
DSM_prediction.CORR_TF    = TF;
DSM_prediction.RR1        = RR1;
DSM_prediction.VV1        = VV1;

end