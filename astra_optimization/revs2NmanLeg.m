function [NmanLeg] = revs2NmanLeg(revs)

NmanLeg = zeros(1, length(revs));
for indr = 1:length(revs)
    b = str2double(regexp(num2str(revs(indr)),'\d','match'));
    if b(1) == 0
        NmanLeg(indr) = 1;
    else
        NmanLeg(indr) = b(1);
    end
end

end