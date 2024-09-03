function [LEGSnext, VASnext, VINFnext] = checkResonance_DP(LEGSnext, VASnext, VINFnext, plt, res, parallel, idcentral)

% DESCRIPTION
% This function checks if specific resonances can be achieved during a spacecraft's flyby
% based on the provided resonance ratio. It evaluates the feasibility of resonant orbits 
% by calculating the spacecraft's post-flyby trajectory and comparing it with the 
% required conditions for resonance.
% 
% INPUT
% - LEGSnext : Matrix containing the legs of the spacecraft's trajectory, where each row 
%              corresponds to a different leg.
% - VASnext  : Matrix containing the spacecraft's velocities corresponding to each leg.
% - VINFnext : Matrix containing the hyperbolic excess velocities for each leg.
% - plt      : Identifier for the planet the flyby is around.
% - res      : Array containing the desired resonance ratio [numerator, denominator].
% - parallel : Boolean flag to indicate whether to run the resonance checks in parallel.
% 
% OUTPUT
% - LEGSnext : Updated matrix of legs after filtering out those that cannot achieve resonance.
% - VASnext  : Updated matrix of velocities after filtering.
% - VINFnext : Updated matrix of hyperbolic excess velocities after filtering.
% 
% -------------------------------------------------------------------------

if nargin == 6
    idcentral = 1;
end

if idcentral == 1

    mu = 132724487690;
    
    [muPL, radius, smapl] = planetConstants(plt); % --> planet semi-major axis
    rpmin = maxmin_flybyAltitude(plt) + radius;

else

    [mu, muPL, smapl, radpl, hmin] = constants(idcentral, plt);
    rpmin = radpl + hmin;

end

Tpl = 2*pi*sqrt(smapl^3/mu);     % --> period of the planet
Tsc = res(1)/res(2)*Tpl;         % --> period of the SC
sma = (mu*(Tsc/(2*pi))^2)^(1/3); % --> semi-major axis of the resonant orbit

rows_to_throw = zeros(size(LEGSnext, 1), 1);

if parallel == true
    
    parfor indi = 1:size(LEGSnext, 1)

        vvIN = VASnext(indi, :);
        plIN = LEGSnext(indi, end-1);
        tIN  = LEGSnext(indi, end);

        [rrga, vvga] = EphSS_car(plIN, tIN, idcentral);

        vvinfIN = vvIN - vvga;

        alphaIN = acos(dot(vvinfIN, vvga)/(norm(vvinfIN)*norm(vvga)));
        alphaIN = wrapToPi(alphaIN);
        thIN    = pi - alphaIN;
        thIN    = wrapToPi(thIN);

        vscou1 = sqrt(mu*(2/norm(rrga) - 1/sma)); % --> SC velocity after the first flyby

        thOU = acos((norm(vvinfIN)^2 + norm(vvga)^2 - vscou1^2)/(2*norm(vvinfIN)*norm(vvga)));
        if ~isreal(thOU) && abs(imag(thOU)) > 1e-4
            rows_to_throw(indi,1) = indi;
        else
            thOU  = wrapToPi(thOU);

            delta = abs(thOU - thIN);
            delta = wrapToPi(delta);

            % --> compute max. deflection (delta_A)
            e_A     = 1 + (rpmin*norm(vvinfIN)^2)/muPL; % --> max. deflection hyperbola eccentricity
            delta_A = 2*asin(1/e_A);                    % --> max. deflection turning angle
            delta_A = wrapToPi(delta_A);

            if delta > delta_A
                rows_to_throw(indi,1) = indi;
            end
        end
    end

else

    for indi = 1:size(LEGSnext, 1)

        vvIN = VASnext(indi, :);
        plIN = LEGSnext(indi, end-1);
        tIN  = LEGSnext(indi, end);

        [rrga, vvga] = EphSS_cartesian(plIN, tIN, idcentral);

        vvinfIN = vvIN - vvga;

        alphaIN = acos(dot(vvinfIN, vvga)/(norm(vvinfIN)*norm(vvga)));
        alphaIN = wrapToPi(alphaIN);
        thIN    = pi - alphaIN;
        thIN    = wrapToPi(thIN);

        vscou1 = sqrt(mu*(2/norm(rrga) - 1/sma)); % --> SC velocity after the first flyby

        thOU = acos((norm(vvinfIN)^2 + norm(vvga)^2 - vscou1^2)/(2*norm(vvinfIN)*norm(vvga)));
        if ~isreal(thOU) && abs(imag(thOU)) > 1e-4
            rows_to_throw(indi,1) = indi;
        else
            thOU  = wrapToPi(thOU);

            delta = abs(thOU - thIN);
            delta = wrapToPi(delta);

            % --> compute max. deflection (delta_A)
            e_A     = 1 + (rpmin*norm(vvinfIN)^2)/muPL; % --> max. deflection hyperbola eccentricity
            delta_A = 2*asin(1/e_A);                    % --> max. deflection turning angle
            delta_A = wrapToPi(delta_A);

            if delta > delta_A
                rows_to_throw(indi,1) = indi;
            end
        end
    end

end

% --> eliminate rows all equal to zero
rows_to_throw = rows_to_throw(~all(rows_to_throw == 0, 2),:);

% --> eliminate the rows to throw
LEGSnext(rows_to_throw,:) = [];
VASnext(rows_to_throw,:)  = [];
VINFnext(rows_to_throw,:) = [];

end