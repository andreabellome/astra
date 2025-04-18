function [name_output, name_input] = nameOfProcessedOutput( seq, res, t0, tf, idcentral )

if isempty(res)
    resname = 'nan';
else
    for ind = 1:length(res)
        resname(ind) = num2str(res(ind));
    end
end

date0 = mjd20002date(t0);
date1 = mjd20002date(tf);
if date1(2) == 12 && date1(3) == 31
    date1(1) = date1(1) + 1;
end

seqName        = seq2SeqName(seq, idcentral);
name_output    = [ 'modp_OUTPUT_' seqName '_' num2str(date0(1)) '_' num2str(date1(1)) '_res_' resname ];
name_input     = [ 'modp_INPUT_' seqName '_' num2str(date0(1)) '_' num2str(date1(1)) '_res_' resname ];

end