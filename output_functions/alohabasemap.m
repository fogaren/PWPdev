function f = alohabasemap()

w = 26;
h = 16;

latrng = [21.5 23.5];
lonrng = [-159, -157];

f = figure('color','white');
set(f,'Units','centimeters','PaperPositionMode', 'auto','Position',[0 0 w h]);
axesm('mercator','MapLatLimit',latrng,'MapLonLimit',lonrng,'Frame','on',...
    'Grid','on','MeridianLabel','on','ParallelLabel','on','PLineLocation',0.5,...
    'MLineLocation',0.5,'FontSize',18);
geoshow('landareas.shp', 'FaceColor', [0.8 0.8 0.8]);
axis off;
hold all;