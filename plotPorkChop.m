function [fig] = plotPorkChop(DV0, meshTDEP, meshTOF, DVst, limcont, titleString)

if nargin == 3
    DVst        = [0.3, 9];
    limcont     = [0.05 20];
    titleString = 'km/s';
elseif nargin == 4
    limcont = [0.05 20];
    titleString = 'km/s';
elseif nargin == 5
    titleString = 'km/s';
end

fig  = figure('Color', [1 1 1]);
if ~isnan(min(min(DV0)))

    minDV0       = min(min(DV0));
    V_inf_levels = minDV0:DVst(1):DVst(2);
    
    N = zeros(size(meshTDEP, 1), size(meshTDEP, 2));
    for indi = 1:size(meshTDEP, 1)
        for indj = 1:size(meshTDEP, 2)
            date = mjd20002date(meshTDEP(indi,indj));
            date = date(1:3);
            N(indi,indj) = datenum(date);
        end
    end
    
    for indi = 1:size(DV0,1)
        for indj = 1:size(DV0,2)
            if DV0(indi,indj) > DVst(2)
                DV0(indi,indj) = NaN;
            end
        end
    end
    
    col1 = [0.8,0.2,0.2];
    
    hold on;
    if DVst(2) >= 10
        veccol = [2:2:DVst(2)];% --> !!! ONLY CALL IT ONCE !!!
        clearDeleteAdd; 
        ephNEO('load','eph_GTOC12.txt');
    elseif DVst(2) < 10 && DVst(2) >= 5
        veccol = [2:1:DVst(2)];
    elseif DVst(2) < 5
        veccol = [0:0.5:DVst(2)];
    end
    numcol = length(veccol)-1;
%     colormap(cool(numcol)) 
    colormap(cool(length(V_inf_levels)-1));
    
    contourf(N, meshTOF, DV0, V_inf_levels, 'color', col1, 'linewidth', 0.5, 'handlevisibility', 'off');
    
    hcb              = colorbar;
    hcb.Title.String = titleString;
    hcb.Ticks        = V_inf_levels;
    
    % set(gca, 'YDir','reverse');
    ylabel('Time of flight [days]'); xlabel('Departing date');
    
    % datetick('y','mmm.dd,yy' );
    datetick('x','mmm.dd,yy' );
    
%     clim(limcont);
    
    hold off;

end

end
