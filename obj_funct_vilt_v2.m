function vilt_struc = obj_funct_vilt_v2( xx, statega1, statega2, kei, Nrev, pl1, t1, t2, idcentral, customEphemerides )

if nargin == 8
    idcentral = 1;
    customEphemerides = @EphSS_cartesian;
elseif nargin == 9
    if isempty(idcentral)
        idcentral = 1;
    end
    customEphemerides = @EphSS_cartesian;
elseif nargin == 10
    if isempty(idcentral)
        idcentral = 1;
    end
    if isempty(customEphemerides)
        customEphemerides = @EphSS_cartesian;
    end
end
AU = 149597870.7;

muCentral = constants(idcentral, pl1);

alpha_dep = xx(1);
vinf_dep  = xx(2);

rrga1 = statega1(1:3);
vvga1 = statega1(4:6);
rrga2 = statega2(1:3);
vvga2 = statega2(4:6);

% --> vector of rotation
nn = cross(rrga1, rrga2);
nn = nn / norm(nn);  % normalize
if nn(3) < 0
    nn = cross(rrga2, rrga1);
    nn = nn / norm(nn);  % normalize    
end

% Normalize input direction
v1 = vvga1 / norm(vvga1);

% Define orthogonal direction in the plane
v2 = cross(nn, v1);
v2 = v2 / norm(v2);

% Rotate by alpha
v_rot = cos(alpha_dep) * v1 + sin(alpha_dep) * v2;

% Optional: scale to desired magnitude
vv_dep  = v_rot * vinf_dep + vvga1;
rr_dep  = rrga1;
kep_dep = car2kep( [rr_dep, vv_dep], muCentral );

if kei == 1 % --> prop. until apo.
    
    if kep_dep(2) < 1
        tof1 = kepEq_t(pi, kep_dep(1), kep_dep(2), muCentral, kep_dep(end), 0);
        if kep_dep(end) >= pi
            period = 2*pi*sqrt( kep_dep(1)^3/muCentral );
            tof1 = period - abs(tof1);
        end
        
        [rr_apsis, vv2pre] = FGCar_dt(rr_dep, vv_dep, tof1, muCentral);
        
        if ( t2 - t1 )*86400 > tof1
    
            tof2           = ( t2 - t1 )*86400 - tof1;
            [vv2post, vv2] = lambertMR_MEXIFY_mex(rr_apsis, rrga2, tof2, muCentral, 0, 0);
            
            dvv = vv2post - vv2pre;
            dv  = norm(dvv);
            vv1 = vv_dep;
        
    %         [tt,yy1] = propagateKepler_tof(rr_dep, vv_dep, tof1, muCentral);
    %         [tt,yy2] = propagateKepler_tof(rr_apsis, vv2post, tof2, muCentral);
    %         
    %         vv1 = vv_dep;
    %     
    %         if dv < 0.5
    %             st = 1;
    %         end
    
        else
    
            dvv      = NaN.*zeros(1,3);
            dv       = NaN;
            vv1      = NaN.*zeros(1,3);
            vv2      = NaN.*zeros(1,3);
            tof1     = NaN;
            tof2     = NaN;
            rr_apsis = NaN.*zeros(1,3);
            vv2post  = NaN.*zeros(1,3);
            vv2pre   = NaN.*zeros(1,3);
    
        end
    
    else % --> no solutions

        dvv      = NaN.*zeros(1,3);
        dv       = NaN;
        vv1      = NaN.*zeros(1,3);
        vv2      = NaN.*zeros(1,3);
        tof1     = NaN;
        tof2     = NaN;
        rr_apsis = NaN.*zeros(1,3);
        vv2post  = NaN.*zeros(1,3);
        vv2pre   = NaN.*zeros(1,3);

    end

elseif kei == -1 % --> prop. until peri.

    tof1 = kepEq_t(2*pi, kep_dep(1), kep_dep(2), muCentral, kep_dep(end), 0);

end

vilt_struc.pl1     = pl1;
vilt_struc.t1      = t1;
vilt_struc.t2      = t2;

vilt_struc.dvv      = dvv;
vilt_struc.dv       = dv;
vilt_struc.vv1      = vv1;
vilt_struc.vv2      = vv2;
vilt_struc.tof1     = tof1;
vilt_struc.tof2     = tof2;
vilt_struc.rr_apsis = rr_apsis;
vilt_struc.vv2post  = vv2post;
vilt_struc.vv2pre   = vv2pre;

vilt_struc.alpha_dep = alpha_dep;
vilt_struc.vinf_dep  = vinf_dep;
vilt_struc.vinf_arr  = norm( vv2 - vvga2 );

vilt_struc.vvinf_dep  = vv1 - vvga1;
vilt_struc.vvinf_arr  = vv2 - vvga2;

end
