
clear all;

%%

close all; clc; format long g;

dist_to_sun = linspace(0.9, 1.7);

thrust_1au = 1050e-3; % --> N
n_engines  = 2;
thrust     = 255e-3;  % --> N

a0 = -0.84855;
a1 = 2.33383;
a2 = -1.01467;
b1 = -0.5;
b2 = 0; 

% factor = (a0 + a1 ./ dist_to_sun + a2 ./ dist_to_sun.^2)./( 1 + b1.*dist_to_sun + b2.*dist_to_sun.^2 ) .* 0.99 .*0.95;
factor = 1;

func_1 = thrust_1au ./ dist_to_sun.^2 .*factor;
func_2 = n_engines * thrust;

thrust_law = min(func_1, func_2);

%%

figMOTOR = figure( 'Color', [1 1 1] );
hold on; grid on;

xlabel('Distance to Sun [AU]'); ylabel('Thrust [mN]');

plotFontSizeAxesDim(14, 14, figMOTOR, gca);

epsilon_vector = flip([ 0.002:0.02:0.2]);

% epsilon_vector       = 0.005; % --> adjust this to best fit your curve

colors = cool(length(epsilon_vector));
for ind = 1:length(epsilon_vector)
    epsilon = epsilon_vector(ind);
    thrust_fitted = -epsilon.*log( exp( -(func_1)./epsilon ) + exp( -(func_2)./epsilon ));
    thrust_profile = func_thrust_fitted( dist_to_sun, epsilon, thrust_1au, n_engines, thrust);

    plot(dist_to_sun, thrust_profile .* 1e3 , ...
        'LineWidth', 2, 'Color', colors(ind,:), ...
        'DisplayName', ['\varepsilon= ' num2str(epsilon)]);
end

plot(dist_to_sun, thrust_law .* 1e3, '--', 'LineWidth', 4, 'DisplayName', 'Thrust profile');

xline( 1, '--', 'LineWidth', 4, 'HandleVisibility', 'off' );
xline( 1.524, '--', 'LineWidth', 4, 'HandleVisibility', 'off' );

text(1+ 0.01, 460, 'Earth orbit', 'FontSize', 12, 'FontWeight', 'bold', 'FontSize', 25);
text(1.524 + 0.01, 510, 'Mars orbit', 'FontSize', 12, 'FontWeight', 'bold', 'FontSize', 25);

lgd             = legend( 'Location', 'south' );
lgd.Interpreter = 'latex';
lgd.NumColumns  = 2;
lgd.EdgeColor   = 'none';
lgd.Color       = 'none';

custom_dpi = 300;
axes_dim = 25;

plotFontSizeAxesDim(axes_dim, axes_dim, figMOTOR, gca);

print(figMOTOR, 'figMOTOR_epsilon.png', '-dpng', ['-r' num2str(custom_dpi)]);

