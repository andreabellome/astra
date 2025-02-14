

vinf = [ 0.2:0.05:4 ];
C3   = vinf.*vinf;

M = -4.79.*C3.*C3 - 81.19.* C3 + 3294.35;

plot( vinf, M );

%%



