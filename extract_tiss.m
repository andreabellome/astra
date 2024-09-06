

load('Results_Full_Exploration.mat');
row          = 10;
pathtiss     = reshape(output(row).LEGS(1,:), 12, [])';

seq  = [ pathtiss(:,1) ];
vinf = [ pathtiss(:,10) ];

seq_vinf = [ seq vinf ];
