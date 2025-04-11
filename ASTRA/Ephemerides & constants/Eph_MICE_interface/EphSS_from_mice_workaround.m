function [rr, vv] = EphSS_from_mice_workaround(IDspk, t, idcentral)

% t is in mjd2000

if nargin == 2
    idcentral = 1;
end

if idcentral == 1

    if IDspk <= 8 % --> Solar System Planets
        [rr, vv] = EphSS_cartesian(IDspk, t, idcentral);
    else

        % --> Ephemeris Time (ET)
        date = processDate(t);
        et   = cspice_str2et([num2str(date) ' TDB']); 
        
        if IDspk < 5
           IDspk = [ num2str(IDspk) num2str(99) ]; 
           IDspk = str2double(IDspk);
        end
        
        % --> state of the NEO
        s  = cspice_spkezr(num2str(IDspk), et, 'eclipj2000', 'none', '10');
        rr = s(1:3)';
        vv = s(4:6)';

    end

end

end