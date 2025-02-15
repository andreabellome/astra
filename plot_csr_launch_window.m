function [fig1, fig2, fig3, fig4, fig5] = ...
    plot_csr_launch_window(SAMPLE_RETURN, ind_sample, cleaned_str) % , target_folder, name_fig)

% --> extract info of the sample return trajectory
[seq_to_go, seq_to_re, res_to_go, res_to_re, leg_to_go, revs_to_go, ...
 vinf_dep_to_go, vinf_arr_to_go, leg_to_re, revs_to_re, vinf_dep_to_re, ...
 vinf_arr_to_re, stay_days, tof_years_tot, tof_days_to_go, tof_days_to_re, ...
 cost_tot, dep_dates] = extract_info_sample_return(SAMPLE_RETURN, ind_sample);

%%

fig1 = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'Launch date' ); ylabel( 'Infinity velocity leaving Earth [km/s]' );

scatter(dep_dates, vinf_dep_to_go, 50, [leg_to_go(:,end) - leg_to_go(:,2)], 'filled');

colormap('cool'); % Seleziona una colormap (es. 'jet', 'parula', 'hot', etc.)
cb = colorbar; % Mostra la barra dei colori per riferimento
ylabel(cb, 'Time to asteroid [days]'); % Aggiungi l'etichetta alla barra dei colori

datetick('x','mmm.dd,yy' );

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

if nargin == 3
    title_name = ['Asteroid: ' cleaned_str];
    title(title_name);
end

%%

fig2 = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'Launch date' ); ylabel( 'Delta-v arriving at asteroid [km/s]' );

title_name = ['Asteroid: ' cleaned_str];
title(title_name);

scatter(dep_dates, vinf_arr_to_go, 50, [leg_to_go(:,end) - leg_to_go(:,2)], 'filled');

colormap('cool'); % Seleziona una colormap (es. 'jet', 'parula', 'hot', etc.)
cb = colorbar; % Mostra la barra dei colori per riferimento
ylabel(cb, 'Time to asteroid [days]'); % Aggiungi l'etichetta alla barra dei colori

datetick('x','mmm.dd,yy' );

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

%%

fig3 = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'Launch date' ); ylabel( 'Delta-v leaving asteroid orbit [km/s]' );

title_name = ['Asteroid: ' cleaned_str];
title(title_name);

scatter(dep_dates, vinf_dep_to_re, 50, [leg_to_re(:,end) - leg_to_re(:,2)], 'filled');

colormap('cool'); % Seleziona una colormap (es. 'jet', 'parula', 'hot', etc.)
cb = colorbar; % Mostra la barra dei colori per riferimento
ylabel(cb, 'Time to Earth [days]'); % Aggiungi l'etichetta alla barra dei colori

datetick('x','mmm.dd,yy' );

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

%%

fig4 = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'Launch date' ); ylabel( 'Infinity velocity arriving at Earth [km/s]' );

title_name = ['Asteroid: ' cleaned_str];
title(title_name);

scatter(dep_dates, vinf_arr_to_re, 50, [leg_to_re(:,end) - leg_to_re(:,2)], 'filled');

colormap('cool'); % Seleziona una colormap (es. 'jet', 'parula', 'hot', etc.)
cb = colorbar; % Mostra la barra dei colori per riferimento
ylabel(cb, 'Time to Earth [days]'); % Aggiungi l'etichetta alla barra dei colori

datetick('x','mmm.dd,yy' );

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

%%

fig5 = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'Departing date' ); ylabel( 'Cost [km/s]' );

title_name = ['Asteroid: ' cleaned_str];
title(title_name);

scatter(dep_dates, cost_tot, 50, tof_years_tot.*365.25, 'filled');

colormap('cool'); % Seleziona una colormap (es. 'jet', 'parula', 'hot', etc.)
cb = colorbar; % Mostra la barra dei colori per riferimento
ylabel(cb, 'Mission duration [days]'); % Aggiungi l'etichetta alla barra dei colori

datetick('x','mmm.dd,yy' );

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 


end