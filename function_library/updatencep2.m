%
%  This will download an entire year of ncep reanalysis 2 data (will take a long time 
%  if internet connection is slow...
%
%  'outdir' specifies where the path where files will be saved.
%

function [] = updatencep2(yr,outdir)

% open connection to noaa server
ft = ftp('ftp2.psl.noaa.gov','anonymous','fogaren@bc.edu');

datapath = '/Datasets/ncep.reanalysis2';

% specify variables to be downloaded here.  paths are relative to 
froots = {'/gaussian_grid/uwnd.10m.gauss','/gaussian_grid/vwnd.10m.gauss',...
    '/gaussian_grid/dlwrf.sfc.gauss','/gaussian_grid/dswrf.sfc.gauss',...
    '/gaussian_grid/ulwrf.sfc.gauss','/gaussian_grid/uswrf.sfc.gauss',...
    '/gaussian_grid/shtfl.sfc.gauss','/gaussian_grid/lhtfl.sfc.gauss',...
    '/gaussian_grid/prate.sfc.gauss','/surface/mslp','/pressure/rhum',...
    '/pressure/air','/gaussian_grid/uflx.sfc.gauss',...
    '/gaussian_grid/air.2m.gauss','/surface/pres.sfc',...
    '/gaussian_grid/pres.sfc.gauss','/gaussian_grid/vflx.sfc.gauss'};


nfls = length(froots);

% ftp each file
for ii = 1:nfls
    fname = strcat(datapath, froots{ii}, '.', num2str(yr), '.nc');
    mget(ft,fname,outdir);
end