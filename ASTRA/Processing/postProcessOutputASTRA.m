function [processed_OUTPUT] = postProcessOutputASTRA( OUTPUT )

% DESCRIPTION
% This function processes the output of the ASTRA tool, extracting key information 
% and organizing it into a structured format for easier analysis and querying.
% The processed data includes mission sequences, leg parameters, resonance information, 
% cost functions, time of flight, Pareto-front solutions, and the path with minimum cost.
% 
% INPUT
% - OUTPUT : Structure array containing the raw results from ASTRA, with fields such as:
%            * minPATH  : Matrix with the path of minimum cost.
%            * res      : Resonance information (optional).
%            * LEGS     : Matrix with leg parameters (e.g., departure/arrival times, 
%                         velocity values, etc.).
%            * VAS      : Arrival velocity vectors (km/s).
%            * VINFa    : Arrival infinity velocities (km/s).
%            * COSTS    : Cost values for the trajectories (e.g., delta-v in km/s).
%            * TOFYS    : Time of flight (years).
%            * ovPF     : Pareto-front solutions.
%            * minCOST  : Minimum cost value across solutions.
%            * chosenRevs : Resonance data for each leg.
%
% OUTPUT
% - processed_OUTPUT : Structure containing the processed and reorganized data:
%                      * seq            : Sequence of IDs for the flyby bodies.
%                      * res            : Resonance information (empty if not present).
%                      * LEGS           : Matrix of leg parameters for all solutions.
%                      * VAS            : Arrival velocity vectors (km/s).
%                      * VINFd          : Departure infinity velocities (km/s).
%                      * VINFa          : Arrival infinity velocities (km/s).
%                      * REVS           : Resonance data for all legs.
%                      * depDates       : Departure dates (MJD2000).
%                      * arrDates       : Arrival dates (MJD2000).
%                      * defectsPerLeg  : Defects per leg (km/s) if present, otherwise empty.
%                      * COSTS          : Overall cost function values (km/s).
%                      * TOFYS          : Overall time of flight (years).
%                      * PARETO_FRONT   : Pareto-front solutions.
%                      * LEGSpf         : Leg parameters corresponding to Pareto-front solutions.
%                      * VASpf          : Arrival velocity vectors for Pareto-front solutions.
%                      * VINFapf        : Arrival infinity velocities for Pareto-front solutions.
%                      * REVSpf         : Resonance data for Pareto-front solutions.
%                      * minPATH        : Path corresponding to the minimum cost solution.
%                      * minCOST        : Minimum cost value.
%                      * minTOFY        : Time of flight for the minimum cost solution.
%                      * minVINFd       : Departure infinity velocity for the minimum cost solution.
%                      * minVINFa       : Arrival infinity velocity for the minimum cost solution.
%                      * minREVS        : Resonance data for the minimum cost solution.
%
% -------------------------------------------------------------------------

if ~isempty(OUTPUT)

    % --> parameters
    processed_OUTPUT.seq = OUTPUT(1).minPATH(:,7)'; % --> MGA sequence
    processed_OUTPUT.res = OUTPUT(1).res;           % --> resonances (empty if not present)
    
    % --> overall solutions -- in this way you can do queries
    processed_OUTPUT.LEGS     = cell2mat({OUTPUT.LEGS}');
    processed_OUTPUT.VAS      = cell2mat({OUTPUT.VAS}');            % --> arrival velocity vectors (km/s)
    processed_OUTPUT.VINFd    = processed_OUTPUT.LEGS(:,3);         % --> departing infinity velocity (km/s)
    processed_OUTPUT.VINFa    = cell2mat({OUTPUT.VINFa}');          % --> arrival infinity velocity (km/s)
    processed_OUTPUT.REVS     = cell2mat({OUTPUT.chosenRevs}');
    
    processed_OUTPUT.depDates      = processed_OUTPUT.LEGS(:,2);         % --> departing dates (MJD2000)
    processed_OUTPUT.arrDates      = processed_OUTPUT.LEGS(:,end);       % --> arrival dates (MJD2000)
    
    if size(processed_OUTPUT.LEGS,2) > 5
        processed_OUTPUT.defectsPerLeg = processed_OUTPUT.LEGS(:,6:3:end-2); % --> defects per leg (km/s)
    else
        processed_OUTPUT.defectsPerLeg = [];                                 % --> no defects are present
    end
    
    % --> cost function and time-of-flight
    processed_OUTPUT.COSTS = cell2mat({OUTPUT.COSTS}'); % --> overall cost function (typically km/s -- depends upon the user)
    processed_OUTPUT.TOFYS = cell2mat({OUTPUT.TOFYS}'); % --> overall time of fligth (years)
    


    % --> Pareto-front solutions
    fieldname = 'ovPF';  % the field you want to check
    isOnlyFirstPopulated = ~isempty(OUTPUT(1).(fieldname)) && ...
        all(arrayfun(@(x) isempty(x.(fieldname)), OUTPUT(2:end)));

    if isOnlyFirstPopulated

        processed_OUTPUT.PARETO_FRONT = OUTPUT(1).ovPF;
        processed_OUTPUT.LEGSpf       = OUTPUT(1).LEGovPF;
        processed_OUTPUT.VASpf        = OUTPUT(1).VASovPF;
        processed_OUTPUT.VINFapf      = OUTPUT(1).VINFovPF;
        processed_OUTPUT.REVSpf       = OUTPUT(1).REVSovPF;

    else
        warning('on', 'all');
        warning('ASTRA DATES option identified. For the overall Pareto front, the sum of departing v-inf, arrival v-inf and defects is considered and time of flight.');
        warning('off','all');
        
        [processed_OUTPUT.LEGSpf, ...
         processed_OUTPUT.VASpf, ...
         processed_OUTPUT.VINFapf, ...
         processed_OUTPUT.PARETO_FRONT] = ...
         costFunction2_MODP(processed_OUTPUT.LEGS, ...
                            processed_OUTPUT.VAS, ...
                            processed_OUTPUT.VINFa);

        processed_OUTPUT.REVSpf = processed_OUTPUT.REVS(processed_OUTPUT.PARETO_FRONT(:,end),:);
    end
    
    % --> path with minimum cost
    [~, row] = min( [OUTPUT.minCOST]' );
    
    processed_OUTPUT.minPATH  = OUTPUT(row).minPATH;
    processed_OUTPUT.minCOST  = OUTPUT(row).minCOST;
    processed_OUTPUT.minTOFY  = OUTPUT(row).minTOFy;
    processed_OUTPUT.minVINFd = OUTPUT(row).minVINFd;
    processed_OUTPUT.minVINFa = OUTPUT(row).minVINFa;
    processed_OUTPUT.minREVS  = OUTPUT(row).chosenRevs(1,:);

else
    processed_OUTPUT = [];
end

end
