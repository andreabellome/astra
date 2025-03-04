function dv1 = extract_dv1( minsol, seq )

x = minsol;

t0   = x(1);
x(1) = [];

tofs               = x(1:length(seq)-1);
x(1:length(seq)-1) = [];

dv1    = x(1:3);
x(1:3) = [];

end