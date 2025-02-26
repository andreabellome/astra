function [epsMin, epsMax] = minMaxEps(NmanLeg)

epsMin = [];
epsMax = [];
for indman = 1:length(NmanLeg)
    nmanl = NmanLeg(indman);
    if nmanl > 1
        deps  = 0.99 - 0.01;
        deps = deps/(nmanl+1);
        epsMin = [ epsMin deps ];
        epsMax = [ epsMax deps+deps  ];
        if nmanl > 1
            for indm = 2:nmanl
                epsMin = [ epsMin epsMin(end)+deps  ];
                epsMax = [ epsMax epsMax(end)+deps  ];
            end
        end
    else
        epsMin = [ epsMin 0.01 ];
        epsMax = [ epsMax 0.99 ];
    end
end


end