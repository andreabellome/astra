function [DV, dv, MAT, output] = mga_nDSM_customEph(seq, t0, tofs, dv1, dvs, eps, eta, rps, struc_revs_man, customEphemerides, plotsol)

NmanLeg   = struc_revs_man.NmanLeg;
revs      = struc_revs_man.revs;
idcentral = struc_revs_man.idcentral;

if nargin == 9
    customEphemerides = @EphSS_cartesian;
    plotsol = 0;
elseif nargin == 10
    plotsol = 0;
else
    if isempty(plotsol) || plotsol == 0 || plotsol == false
        plotsol = 0;
    else
        plotsol = 1;
        AU      = 149597870.7;

        tpls    = zeros(1,length(seq));
        tpls(1) = t0;
        for indt = 1:length(tofs)
            tpls(indt+1) = tpls(indt) + tofs(indt);
        end
        [fig] = plotPLTS_tt(seq, tpls(1), tpls(end)+365.25, 1, customEphemerides, 0);

    end
end
output = [];

% --> gravitational parameter of the Sun
% mu = 132724487690;
mu = constants(idcentral, 1);

% --> epochs of the flybys
tt    = zeros(1,length(seq));
tt(1) = t0;
for indt = 1:length(tofs)
    tt(indt+1) = tt(indt) + tofs(indt);
end

% --> find legs and epochs
legs   = [ seq(1:end-1)' seq(2:end)' ];
epochs = [ tt(1:end-1)'  tt(2:end)' ];

EPS = eps;
epochsMAN = [];
for indl = 1:size(legs,1)

    nmanl   = NmanLeg(indl); % --> how many manoeuvres you have on the leg?
    if nmanl == 0

    else

        ts      = epochs(indl,1);
        tf      = epochs(indl,2);
        epsilon = EPS(1:nmanl);
        
        tman    =  (tf - ts).*epsilon;
        
        for indtman = 1:length(tman)
            epochsMAN = [epochsMAN; ts + tman(indtman)];
        end

    end

    EPS(1:nmanl) = [];

end
epochsMAN = epochsMAN';

SEQ   = [seq 1e99.*ones(1, sum(NmanLeg))];
TIMES = [tt epochsMAN];
MAT   = sortrows([SEQ' TIMES'], 2);
MAT   = [ MAT(1:end-1,:) MAT(2:end,:) zeros(size(MAT,1)-1,5) ];

if NmanLeg == 0
    dvs = zeros( size(MAT,1) , 3 );
else
    dvs   = reshape(dvs', [3 sum(NmanLeg)])';
end
flyby = [ eta' rps' ];
inddv = 1;
indfb = 1;
for indmat = 1:size(MAT,1)-1
    pl2 = MAT(indmat,3);
    if pl2 < 1e99 % --> attach the flyby param
        MAT(indmat,8:9) = flyby(indfb,:);
        indfb = indfb + 1;
    else
        if indmat == 1
            MAT(indmat,5:7) = dv1;
        else
            MAT(indmat,5:7) = dvs(inddv,:);
            inddv = inddv + 1;
        end
    end
end

% --> find initial dv
[xp1, vp1] = customEphemerides( MAT(1,1), MAT(1,2) );
MAT(1,5:7) = v02dv1(dv1, xp1, vp1);

if norm(dv1) == 0 % --> then there is no manoeuvre
    
    MAT_p              = MAT;
    indxs              = find(MAT_p(:,3) < 1e99);
    indxs              = indxs(1);

    MAT_p(1:indxs-1,:) = [];
    MAT_p(1,1:2)       = MAT(1,1:2);
    
    if revs(1) == 0
        nrev_first_leg = [ 0 0 ];
    else
        nrev_first_leg = arrayfun(@(x) str2double(x), num2str(revs(1)));
    end
    MAT = MAT_p;
end

dv = [];
for indm = 1:size(MAT,1)

    pl1 = MAT(indm,1);
    pl2 = MAT(indm,3);
    t1  = MAT(indm,2);
    t2  = MAT(indm,4);

    if pl1 < 1e99
        [rrga1, vvga1] = customEphemerides( pl1, t1 );
    end
    if pl2 < 1e99
        [rrga2, vvga2] = customEphemerides( pl2, t2 );
    end

    if indm == 1 % --> first leg

        if pl2 < 1e99 % --> there is a simple Lambert arc for the first leg + the flyby

            rrd        = rrga1;
            rra        = rrga2;

            [vvd, vva] = lambertMR_MEXIFY(rrd, rra, (t2 - t1)*86400, mu, nrev_first_leg(1), nrev_first_leg(2));
            dv         = [ dv; norm(vvd - vvga1) ];

            if indm == size(MAT,1)
                dv = [ dv; norm(vva - vvga2) ];
            else
                % --> perform the fly-by with the second planet
                [muPLIN, radPL] = planetConstants(pl2);
                kIN             = MAT(indm,8);
                rpIN            = MAT(indm,9)*radPL;
                [rra, vva]      = swingby_vA(rra, vva, pl2, t2, kIN, rpIN, muPLIN, idcentral, customEphemerides);
            end

        else % --> propagate until the DSM point

            % --> initial spacecraft position and velocity
            rrd = rrga1;
            vvd = vvga1 + MAT(indm,5:7);

            % --> final spacecraft position and velocity
            [rra, vva] = FGCar_dt(rrd, vvd, (t2 - t1)*86400, mu);            
            
            dv = [ dv; norm(MAT(indm,5:7)) ];

        end

    else % --> next leg

        if pl2 < 1e99 % --> there is a Lambert arc + the flyby

            rrd        = RRAprev;
            rra        = rrga2;
            [vvd, vva] = lambertMR_MEXIFY(rrd, rra, (t2 - t1)*86400, mu, 0, 0);

            if pl1 > 1e98
                dv = [ dv; norm(vvd - VVAprev) ];
            end

            if indm == size(MAT,1)
                
                dv = [dv; norm(vva - vvga2)];

            else % --> perform the flyby

                % --> perform the fly-by with the second planet
                [muPLIN, radPL] = planetConstants(pl2);
                kIN             = MAT(indm,8);
                rpIN            = MAT(indm,9)*radPL;
                [rra, vva]      = swingby_vA(rra, vva, pl2, t2, kIN, rpIN, muPLIN, idcentral, customEphemerides);

            end

        else % --> there is a propagation

            if pl1 < 1e98
                rrd        = RRAprev;
                vvd        = VVAprev;
                [rra, vva] = FGCar_dt(rrd, vvd, (t2 - t1)*86400, mu);
                dv         = [dv; 0];
            else
                rrd        = RRAprev;
                vvd        = VVAprev + MAT(indm,5:7);
                [rra, vva] = FGCar_dt(rrd, vvd, (t2 - t1)*86400, mu);
                dv         = [dv; norm(MAT(indm,5:7))];
            end
            
        end

    end

    if plotsol == 1
        
        tt     = linspace( 0, (t2 - t1) ).*86400;
        [~,yy] = propagateKepler(rrd, vvd, tt, mu);

        if indm == 1 && pl2 > 1e98 && norm(dv1) == 0
            plot3( yy(end,1)./AU, yy(end,2)./AU, yy(end,3)./AU, 's', 'MarkerSize', 10, ...
                'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Cyan', ...
                'DisplayName', 'Departure' );
        else
            hold on;
            plot3( yy(:,1)./AU, yy(:,2)./AU, yy(:,3)./AU, 'k', 'LineWidth', 2, 'HandleVisibility', 'Off');
        end

        if indm == 1
            
            if pl2 > 1e98
                if norm(dv1) == 0
                else
                    plot3( yy(1,1)./AU, yy(1,2)./AU, yy(1,3)./AU, 's', 'MarkerSize', 10, ...
                        'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Cyan', ...
                        'DisplayName', 'Departure' );
                end

            end

            if pl2 < 1e99
                plot3( yy(1,1)./AU, yy(1,2)./AU, yy(1,3)./AU, 's', 'MarkerSize', 10, ...
                        'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Cyan', ...
                        'DisplayName', 'Departure' );

                plot3( yy(end,1)./AU, yy(end,2)./AU, yy(end,3)./AU, 'o', 'markersize', 8, ...
                    'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Red', ...
                    'handlevisibility', 'off' );
            end

        else % --> successive legs

            if indm == 2 && pl1 > 1e98 && norm(dv1) == 0
            else
                if indm < size(MAT,1)
                    if pl1 > 1e98 && dv(end) > 0.05
                        plot3( yy(1,1)./AU, yy(1,2)./AU, yy(1,3)./AU, 'kx', 'markersize', 10, ...
                            'linewidth', 3, ...
                            'handlevisibility', 'off' );
                    end
                else
                   if pl1 > 1e98 && dv(end-1) > 0.05
                        plot3( yy(1,1)./AU, yy(1,2)./AU, yy(1,3)./AU, 'kx', 'markersize', 10, ...
                            'linewidth', 3, ...
                            'handlevisibility', 'off' );
                   end
                end
            end
            if pl2 < 1e99
                plot3( yy(end,1)./AU, yy(end,2)./AU, yy(end,3)./AU, 'o', 'markersize', 8, ...
                    'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Red', ...
                    'handlevisibility', 'off' );
            end
        end
        
        output(indm).pl1 = pl1;
        output(indm).pl2 = pl2;
        output(indm).tt  = tt;
        output(indm).yy  = yy;

    end

    RRAprev = rra;
    VVAprev = vva;

end
DV = sum(dv);

end
