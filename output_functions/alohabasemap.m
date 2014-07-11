function f = alohabasemap()

w = 18;
h = 18;

latrng = [15 31];
lonrng = [-170, -150];

f = figure('color','white');
set(f,'Units','centimeters','PaperPositionMode', 'auto','Position',[0 0 w h]);
axesm('mercator','MapLatLimit',latrng,'MapLonLimit',lonrng,'Frame','on',...
    'Grid','on','MeridianLabel','on','ParallelLabel','on','PLineLocation',4,...
    'MLineLocation',4);
geoshow('landareas.shp', 'FaceColor', [0.8 0.8 0.8]);
axis off;
hold all;