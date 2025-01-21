%Coordinate conversions
classdef CoordConv
    methods (Static)
        function MEEParameters = kepler2MEOE(Object)
            % input: A struct or array with keplerian orbital elements
            % output: A vector of MEE elements.
            
            if isstruct(Object)
                
                a = Object.a;
                e = Object.e;
                omega = Object.omega;
                Omega = Object.RAAN;
                i = Object.inc;
                
                if isfield(Object, 'MA')
                    MA = Object.MA;
                    
                    
                    E = MA;
                    E_old = 1;
                    precision  = 1e-7;
                    
                    
                    while abs(E - E_old) > precision
                        
                        % find the next eccentric anomaly value using N-R method
                        E = E - ((E - e*sin(E) - MA)./(1 - e*cos(E)));
                        E_old = E ;
                    end
                    
                    theta = 2 * atan(sqrt((1 + e)/ (1 - e)) .* tan(E/2) );
                else
                    theta = Object.theta;
                end
                
                
              
            else
                a = Object(1);
                e = Object(2);
                i = Object(3);
                Omega = Object(4);
                omega = Object(5);
                theta = Object(6);
                
            end
            
            p = a*(1 - e*e);
            f = e*cos(omega + Omega);
            g = e*sin(omega + Omega);
            h = tan(i/2)*cos(Omega);
            k = tan(i/2)*sin(Omega);
            L = wrapTo2Pi(Omega + omega + theta); % --> IS THIS CORRECT? wrapTo2Pi
            MEEParameters = [p, f,g ,h,k,L];
            
            
            
        end
        function [rr, vv] = po2pv(PO, mu)
            
            % input: PO vector of classical orbital parameters
            %        mu gravity parameter in units consistent with a
            % output: rr position vecotor in units consistent with mu and a
            %         vv velocity vector in units consistent with mu and a
            
            a = PO(1);
            e = PO(2);
            i = PO(3);
            Om = PO(4);
            om = PO(5);
            theta = PO(6);
            
            A = [cos(om+theta) -sin(om+theta) 0;
                sin(om+theta) cos(om+theta)  0;
                0             0   1];
            
            if i<0
                i = pi+i;
            end
            
            B = [1      0       0;
                0 cos(i)  -sin(i);
                0 sin(i)   cos(i)];
            
            C =  [cos(Om) -sin(Om) 0;
                sin(Om) cos(Om)  0;
                0       0   1];
            
            p = a*(1-e^2);
            
            r = [1/(1+e*cos(theta))*p 0 0]';
            v = sqrt(mu/p)*[e*sin(theta) 1+e*cos(theta) 0]';
            
            rr = C*B*A*r;
            vv = C*B*A*v;
        end
        function OPmat = KeplerStruct(EP)
            OP = CoordConv.ep2op(EP);
            OPmat.aAU = OP(1);
            OPmat.e = OP(2);
            OPmat.IncDeg = rad2deg((OP(3)));
            OPmat.OmegaDeg = rad2deg((OP(4)));
            OPmat.omegaDeg = rad2deg((OP(5)));
            OPmat.TrueAnDeg = rad2deg((OP(6)));
            OPmat.ArgofLat = (OPmat.TrueAnDeg + OPmat.omegaDeg);
            
        end
        
        function OPmat = KeplerStruct2(EP)
            OP = CoordConv.mee2coe(EP);
            OPmat.aAU = OP(1);
            OPmat.e = OP(2);
            OPmat.IncDeg = rad2deg((OP(3)));
            OPmat.OmegaDeg = rad2deg((OP(4)));
            OPmat.omegaDeg = rad2deg((OP(5)));
            OPmat.TrueAnDeg = rad2deg((OP(6)));
            OPmat.ArgofLat = (OPmat.TrueAnDeg + OPmat.omegaDeg);
            
        end
        
        function coe = mee2coe(mee)
            
            % convert modified equinoctial elements to classical orbit elements
            
            % input
            
            %  mee(1) = semiparameter (kilometers)
            %  mee(2) = f equinoctial element
            %  mee(3) = g equinoctial element
            %  mee(4) = h equinoctial element
            %  mee(5) = k equinoctial element
            %  mee(6) = true longitude (radians)
            
            % output
            
            %  coe(1) = semimajor axis (kilometers)
            %  coe(2) = eccentricity
            %  coe(3) = inclination (radians)
            %  coe(4) = argument of periapsis (radians)
            %  coe(5) = right ascension of ascending node (radians)
            %  coe(6) = true anomaly (radians)
            
            % Orbital Mechanics with MATLAB
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % unload modified equinoctial orbital elements
            
            pmee = mee(1);
            fmee = mee(2);
            gmee = mee(3);
            hmee = mee(4);
            kmee = mee(5);
            lmee = mee(6);
            
            % compute classical orbital elements
            
            tani2s = sqrt(hmee * hmee + kmee * kmee);
            
            % orbital eccentricity
            
            ecc = sqrt(fmee * fmee + gmee * gmee);
            
            % semimajor axis
            
            sma = pmee / (1.0 - ecc * ecc);
            
            % orbital inclination
            
            inc = 2.0 * atan(tani2s);
            
            % right ascension of ascending node
            
            raan = atan2(kmee, hmee);
            
            % argument of periapsis
            
            atopo = atan2(gmee, fmee);
            
            argper = mod(atopo - raan, 2.0 * pi);
            
            % true anomaly
            
            tanom = mod(lmee - atopo, 2.0 * pi);
            
            % load classical orbital element array
            
            coe(1) = sma;
            coe(2) = ecc;
            coe(3) = inc;
            coe(4) = raan;
            coe(5) = argper;
            coe(6) = tanom;
        end
        
        function  OP = ep2op(EP)
            % converts equinoctial parameters in orbital parameters
            % EP = (p,f,g,h,k,L)
            % OP = (a,e,i,Om,om,theta)
            
            % Initialize:
            p = EP(1);
            f = EP(2);
            g = EP(3);
            h = EP(4);
            k = EP(5);
            L = (EP(6));
            
            % % Compute:
            % OP(1) = p/(1-f^2-g^2);
            % OP(2) = sqrt(f^2+g^2);
            % OP(3) = 2*atan(sqrt(h^2+k^2));  % Problems finding right quadrant?
            % OP(4) = atan2(g,f)-atan2(k,h);  % Problems finding right quadrant?
            % OP(5) = atan2(k,h);             % Problems finding right quadrant?
            % OP(6) = L- atan2(g,f);          % Problems finding right quadrant?, check by atan(g/f)=O+w.
            
            OP(1) = p/(1-f^2-g^2);
            OP(2) = sqrt(f^2+g^2);
            OP(3) = atan2(2*sqrt(h^2+k^2), 1-h^2-k^2);
            
            if EP(4)==0&&EP(5)==0
                OP(4) = 0;
            else
                OP(4) = atan2(k,h);
            end
            if EP(2)==0&&EP(3)==0
                OP(5) = 0;
            else
                OP(5) = atan2(g*h -f*k,f*h+g*k);
            end
            OP(6) = L - OP(4) - OP(5);
        end
        function posandvel = ep2pv(EP, mu)
            OP = CoordConv.ep2op(EP);
            
            
            [rr, vv] = CoordConv.po2pv(OP, mu);
            posandvel = [rr;vv];
        end
        
        function x = vec2kepStruct(rs,vs,mus)
            
            OP = CoordConv.pv2po(rs,vs,mus);
            
            x.a = OP(1);
            x.e = OP(2);
            x.IncDeg = rad2deg((OP(3)));
            x.OmegaDeg = rad2deg((OP(4)));
            x.omegaDeg = rad2deg((OP(5)));
            x.TrueAnDeg = rad2deg((OP(6)));
            x.ArgofLat = (x.TrueAnDeg + x.omegaDeg);
            
        end
        
        function mee = vec2mee(rs,vs,mus)
            
            % Get the keplerian elements
            x = CoordConv.pv2po(rs,vs,mus);
           
            % convert kepler to mee
            mee =  CoordConv.kepler2MEOE(x);
        end
        
        
   

        function E = pv2po(rr, vv, mu)

            r = norm(rr);
            v = norm(vv);
            a = mu/(2*(mu/r-v^2/2));
            h = cross(rr,vv);

            % calcola OMEGA

            if (h(1)^2+h(2)^2)==0
                OMEGA=0;
            else

                sinOMEGA = h(1)/sqrt(h(1)^2+h(2)^2);
                cosOMEGA = -h(2)/sqrt(h(1)^2+h(2)^2);

                if cosOMEGA>=0
                    if sinOMEGA>=0
                        OMEGA = asin(h(1)/sqrt(h(1)^2+h(2)^2));
                    else
                        OMEGA = 2*pi+asin(h(1)/sqrt(h(1)^2+h(2)^2));
                    end
                else
                    if sinOMEGA>=0
                        OMEGA = acos(-h(2)/sqrt(h(1)^2+h(2)^2));
                    else
                        OMEGA = 2*pi-acos(-h(2)/sqrt(h(1)^2+h(2)^2));
                    end
                end
            end

            OMEGA = real(OMEGA);

            % calcola l'eccentricit?
            ee = 1/mu*(cross(vv,h))-rr/norm(rr);
            e = norm(ee);

            % calcola l'inclinazione
            i = acos(h(3)/norm(h));
            % caso particolare di orbita circolare e inclinazione nulla
            if e<=1e-6 && i<1e-6
                e = 0;
                omega = atan2(rr(2),rr(1));
                theta = 0;
                E = [a, e, i, OMEGA, omega, theta];
                return
            end

            % caso particolare di orbita circolare e inclinazione  non nulla

            if e<=1e-6 && i>=1e-6
                omega=0;
                K = [cos(omega)*cos(OMEGA)-sin(omega)*sin(i)*sin(OMEGA) cos(omega)*sin(OMEGA)+sin(omega)*cos(i)*cos(OMEGA) sin(omega)*sin(i);
                    -sin(omega)*cos(OMEGA)-cos(omega)*cos(i)*sin(OMEGA) -sin(omega)*sin(OMEGA)+cos(omega)*cos(i)*cos(OMEGA) cos(omega)*sin(i);
                    sin(OMEGA)*sin(i) -cos(OMEGA)*sin(i) cos(i)];
                rr = K*rr;
                theta = atan2(rr(2),rr(1));
                E = [a, e, i, OMEGA, omega, theta];
                return
            end

            %calcola  theta

            theta = acos((rr'*ee)/(norm(rr)*norm(ee)));
            if rr'*vv<0
                theta=2*pi-theta;
            end
            theta = real(theta);

            % calcola di omega

            if i<=1e-6 && e>=1e-6
                i=0;
                omega = atan2(ee(2),ee(1));
                E = [a, e, i, OMEGA, omega, theta];
                return
            end

            sino = rr(3)/r/sin(i);
            coso = (rr(1)*cos(OMEGA)+rr(2)*sin(OMEGA))/r;

            if coso>=0
                if sino>=0
                    o = asin(rr(3)/r/sin(i));
                else
                    o = 2*pi+asin(rr(3)/r/sin(i));
                end
            else
                if sino>=0
                    o = acos((rr(1)*cos(OMEGA)+rr(2)*sin(OMEGA))/r);
                else
                    o = 2*pi-acos((rr(1)*cos(OMEGA)+rr(2)*sin(OMEGA))/r);
                end
            end
            o = real(o);
            omega = o-theta;

            if omega<0
                omega = omega+2*pi;
            end
            omega = real(omega);

            E = [a, e, i, OMEGA, omega, theta]';

        end



    end
    

end