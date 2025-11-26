
clearDeleteAdd;
close all; clc; 

%% --> Soyuz ST-B & Ariane 62

vinf         = 1:1:6;   % --> dep. infinity velocity [km/s]
mass_adapter = 0;       % --> launcher adapter mass [kg]

mass_soyuz_stb = soyuz_stb_launcher( vinf, mass_adapter );
mass_ariane_62 = ariane_62_launcher( vinf, mass_adapter );

fig = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel('v-inf [km/s]'); ylabel('mass [kg]');
plot( vinf, mass_soyuz_stb, '-o', 'LineWidth', 2, 'DisplayName', 'Soyuz ST-B');
plot( vinf, mass_ariane_62, '-o', 'LineWidth', 2, 'DisplayName', 'Ariane 62');
lgd = legend('Location', 'best');
plotFontSizeAxesDim(14, 14, fig, gca);

%% --> Ariane 64 -- mono-boost performances

vinf         = 1:1:6;        % --> dep. infinity velocity [km/s]
dla_vec_deg  = [-5 0 5];     % --> declination at launch [deg]
mass_adapter = 0;            % --> launcher adapter mass [kg]
type         = 'mono_boost'; % --> type (either 'mono_boost' or 'bi_boost')

fig = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel('v-inf [km/s]'); ylabel('mass [kg]');

for ind = 1:length(dla_vec_deg)
    mass = ariane_64_launcher( vinf, dla_vec_deg(ind), mass_adapter, type );

    name = [ 'DLA= ' num2str(dla_vec_deg(ind)) ' deg'];
    plot( vinf, mass, '-o', 'LineWidth', 2, 'Color', colors(ind,:), 'DisplayName', name );
end

lgd = legend('Location', 'best');
plotFontSizeAxesDim(14, 14, fig, gca);

%% --> Ariane 64 -- bi-boost performances

vinf         = 1:1:6;                           % --> dep. infinity velocity [km/s]
dla_vec_deg  = [-40 -30 -20 -10 0 10 20 30 40]; % --> declination at launch [deg]
mass_adapter = 0;                               % --> launcher adapter mass [kg]
type         = 'bi_boost';                      % --> type (either 'mono_boost' or 'bi_boost')

colors = cool(length(dla_vec_deg));

fig = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel('v-inf [km/s]'); ylabel('mass [kg]');

for ind = 1:length(dla_vec_deg)
    mass = ariane_64_launcher( vinf, dla_vec_deg(ind), mass_adapter, type );

    name = [ 'DLA= ' num2str(dla_vec_deg(ind)) ' deg'];
    plot( vinf, mass, '-o', 'LineWidth', 2, 'Color', colors(ind,:), 'DisplayName', name );
end

lgd = legend('Location', 'best');
plotFontSizeAxesDim(14, 14, fig, gca);


