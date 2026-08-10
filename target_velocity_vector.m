function [vvaTAR, dv, dvv] = target_velocity_vector( vva, vvga, free_vel_mag )

if norm(vvga - vva(end,:)) > free_vel_mag % --> DSM on the first leg
    dvv  = abs( norm(vvga - vva(end,:)) - free_vel_mag ).*(vvga - vva(end,:))./norm(vvga - vva(end,:));
    vvPM = vva(end,:) + dvv;
else
    vvPM = vva(end,:);
    dvv  = vvPM - vva;
end
vvaTAR        = vva;
vvaTAR(end,:) = vvPM;

dv = norm(dvv);

end