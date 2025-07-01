function save_fig_custom( fig, dpi, type, name_including_folder )

if nargin == 0
    fig = gcf;
    dpi = 600;
    type = 'pdf';
    name_including_folder = 'my_plot';
elseif nargin == 1
    dpi = 600;
    type = 'pdf';
    name_including_folder = 'my_plot';
elseif nargin == 2
    type = 'pdf';
    name_including_folder = 'my_plot';
elseif nargin == 3
    name_including_folder = 'my_plot';
end

if strcmpi(type, 'pdf')

    if ~strcmpi(name_including_folder(1:end-3), type)
        error('Extension in selected name does not match the selected type');
    end

    % Set figure paper properties to match the on-screen size
    set(fig, 'PaperUnits', 'inches');
    set(fig, 'PaperPositionMode', 'auto');
    fig_pos = get(fig, 'Position');
    
    % Convert figure size to inches for PaperSize
    screen_dpi = get(0, 'ScreenPixelsPerInch');
    fig_width = fig_pos(3) / screen_dpi;
    fig_height = fig_pos(4) / screen_dpi;
    set(fig, 'PaperSize', [fig_width fig_height]);
    
    name = [name_including_folder(end-2:end) '.pdf'];

    % Export to PDF with specified resolution
    print(fig, name, '-dpdf', ['-r' num2str(dpi)]);

elseif strcmpi(type, 'svg')

    if ~strcmpi(name_including_folder(end-2:end), type)
        error('Extension in selected name does not match the selected type');
    end

    % Match figure size to PDF logic (for consistency)
    set(fig, 'PaperUnits', 'inches');
    set(fig, 'PaperPositionMode', 'auto');
    fig_pos = get(fig, 'Position');
    screen_dpi = get(0, 'ScreenPixelsPerInch');
    fig_width = fig_pos(3) / screen_dpi;
    fig_height = fig_pos(4) / screen_dpi;
    set(fig, 'PaperSize', [fig_width fig_height]);

    name = [name_including_folder(1:end-3) '.svg'];
    
    % Save as SVG
    print(fig, name, '-dsvg', ['-r' num2str(dpi)]);
        
end

end