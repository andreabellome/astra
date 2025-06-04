function [minDV, tfMinDV, ratioMinDV, dv, tf, ratio, row] = fromC2DSM(CC, defect)

vec = [0 0 0 -defect]';

dv    = zeros(size(CC,3),1);
tf    = zeros(size(CC,3),1);
ratio = zeros(size(CC,3),1);
for indc = 1:size(CC,3)
    C = CC(:,:,indc);
    
    RANK    = rank(C); % --> controlla se CC è ben-condizionata o mal-condizionata
    RANKmax = size(C,1);
    
    if RANK < RANKmax
        % then CC is ill-conditioned
        [U,S,V] = svd(C);
        s       = diag(S);
        k       = sum(s> 1e-17);
        CCinv   = (U(:, 1: k)* diag(1./ s(1: k))* V(:, 1: k)')';
        DU      = CCinv*vec;
    else
        DU  = C\vec;
    end
    DU  = DU';
    
    dvv           = DU(1:3);     % DSM vector [DSMv, DSMp, DSMn]  (km/s)
    dv(indc,:)    = norm(dvv);   % DSM magnitude                  (km/s)
    tf(indc,:)    = DU(4)/86400; % correction on the arrival time (days)
    ratio(indc,:) = defect/dv(indc,:);
end

[minDV, row] = min(dv);
tfMinDV      = tf(row);
ratioMinDV   = ratio(row);
if ratioMinDV < 1
    minDV = defect;
end

end
