function [vvBM, dv] = first_leg_of_the_transfer( idcentral, customEphemerides, p0, t0, vvd, vinf_max, decl_min, decl_max )

if nargin == 6
    decl_min = -Inf;
    decl_max = +Inf;
elseif nargin == 7
    if isempty(decl_min)
        decl_min = -Inf;
    end
    decl_max = +Inf;
elseif nargin == 8
    if isempty(decl_min)
        decl_min = -Inf;
    end
    if isempty(decl_max)
        decl_max = +Inf;
    end
end

if decl_max < 1e98 && decl_min < -1e98
    error('You specified the max. declination but not the min.');
end

if decl_max > 1e98 && decl_min > -1e98
    error('You specified the min. declination but not the max.');
end

[~, vvga]       = customEphemerides(p0, t0, idcentral);
vvinf_ecliptic  = vvd(1,:) - vvga;
vinf_ecliptic   = norm(vvinf_ecliptic);

[DEC, AZ]   = find_decl_ras_launch_from_vinf( vvinf_ecliptic );
% rad2deg(DEC)

if decl_min > -1e98 && decl_max < 1e98
    decl_bounds_specified = true;
else
    decl_bounds_specified = false;
end

eps = deg2rad(23.4392911);
R_eq2ecl = [1 0 0;
            0  cos(eps)  sin(eps);
            0 -sin(eps)  cos(eps)];

if vinf_ecliptic > vinf_max
    
    vvinf       = vinf_max * vvinf_ecliptic / norm(vvinf_ecliptic);

    if decl_bounds_specified
        [DEC, AZ]   = find_decl_ras_launch_from_vinf( vvinf );
        
        if DEC < decl_min
            DECnew = decl_min;
        elseif DEC > decl_max
            DECnew = decl_max;
        elseif DEC >= decl_min && DEC <= decl_max
            DECnew = DEC;
        end

        % if (DEC < decl_min) || (DEC > decl_max)
        %     DECnew = decl_min;
        % else
        %     DECnew = decl_max;
        % end
    
        % rebuild v_infinity with the same magnitude and fixed declination
        vvinf = [ ...
            vinf_max * cos(DECnew) * cos(AZ), ...
            vinf_max * cos(DECnew) * sin(AZ), ...
            vinf_max * sin(DECnew)           ];
        
        vvinf = R_eq2ecl * vvinf';
        vvBM  = vvinf' + vvga;
        dv(1) = norm(vvd(1,:) - vvBM);

    else

        vvBM  = vvinf + vvga;
        dv(1) = norm(vvd(1,:) - vvBM);
    end

else % --> inf. is okay

    if decl_bounds_specified

        [DEC, AZ]   = find_decl_ras_launch_from_vinf( vvinf_ecliptic );

        if DEC < decl_min
            DECnew = decl_min;
        elseif DEC > decl_max
            DECnew = decl_max;
        elseif DEC >= decl_min && DEC <= decl_max
            DECnew = DEC;
        end

        % rebuild v_infinity with the same magnitude and fixed declination
        vvinf = [ ...
            vinf_ecliptic * cos(DECnew) * cos(AZ), ...
            vinf_ecliptic * cos(DECnew) * sin(AZ), ...
            vinf_ecliptic * sin(DECnew)           ];
        
        vvinf = R_eq2ecl * vvinf';
        vvBM  = vvinf' + vvga;
        dv(1) = norm(vvd(1,:) - vvBM);

    else

        % required v_inf already within launcher capability
        vvBM  = vvd(1,:);
        dv(1) = 0;

    end

end


end