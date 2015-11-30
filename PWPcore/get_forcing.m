%%%
%
% -------------------------------------------------------------------------
% INPUTS
% -------------------------------------------------------------------------
% ncep path:    root directory for ncep files (e.g.
%               /Users/Roo/Documents/MATLAB/Datasets/ncep.reanalysis
% lat, lon:     vectors of observed profile lat/lon (must be same length)
% t:            vector of matlab datenum dates for corresponding profiles
%               lat/lon/t 
% trng:         [tstart tend] for model simulation (in decimal year)
%
%
% USAGE: F = get_forcing('/ncepdir',fl.lat,fl.lon,fl.t,
%%%%%


function [F] = get_forcing(ncep_path,lat,lon,t)

% define study domain
%yrvec = datevec(datenum(t,1,1));
datenVec = datevec(t);
yrRng = [datenVec(1,1) datenVec(end,1)];
% make all longitudes positive
lon(lon < 0) = lon(lon < 0) + 360;
lat(isnan(lat)) = interp1(t(~isnan(lat)),lat(~isnan(lat)),t(isnan(lat)));
lon(isnan(lon)) = interp1(t(~isnan(lon)),lon(~isnan(lon)),t(isnan(lon)));

% initialize final output struct variables
F.u10m = [];
F.v10m = [];
F.nSWRS = [];
F.nLWRS = [];
F.nSHTFL = [];
F.nLHTFL = [];
F.PRATE = [];
F.PRES = [];
F.RHUM = [];
F.AIRT = [];
F.uStress = [];
F.vStress = [];
F.CURL = [];
F.DateTime = [];

% get forcing for each single year and then concatenate
for yr = yrRng(1):yrRng(2)
    
    latyr = lat(datenVec(:,1) == yr);
    lonyr = lon(datenVec(:,1) == yr);

    %t_yr = t(yrvec(:,1) == yr); 

    dn_tyr = t;%datenum(t_yr,1,1);
    %dn_tyr = datenum(t_yr,1,1);
    % data domain for yr
    dn_trng = [min(dn_tyr) max(dn_tyr)];
    
    lat_rng = [min(latyr) max(latyr)];
    lon_rng = [min(lonyr) max(lonyr)];
    
    % 10 meter zonal (u) wind (m/s)
    
    flxpath = [ncep_path '/surface_gauss/'];
    srfpath = [ncep_path '/surface/'];
    
    % get time vector, ncep lat and lon grids
    % Note: Different NCEP variables can be updated to different date
    time = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'],'time'); 
    time = intersect(time,ncread([flxpath 'vwnd.10m.gauss' '.' num2str(yr) '.nc'],'time')); 
    time = intersect(time,ncread([flxpath 'nswrs.sfc.gauss' '.' num2str(yr) '.nc'],'time')); 
    time = intersect(time,ncread([flxpath 'nlwrs.sfc.gauss' '.' num2str(yr) '.nc'],'time')); 
    time = intersect(time,ncread([flxpath 'shtfl.sfc.gauss' '.' num2str(yr) '.nc'],'time')); 
    time = intersect(time,ncread([flxpath 'lhtfl.sfc.gauss' '.' num2str(yr) '.nc'],'time')); 
    time = intersect(time,ncread([flxpath 'prate.sfc.gauss' '.' num2str(yr) '.nc'],'time')); 
    time = intersect(time,ncread([flxpath 'uflx.sfc.gauss' '.' num2str(yr) '.nc'],'time')); 
    time = intersect(time,ncread([flxpath 'vflx.sfc.gauss' '.' num2str(yr) '.nc'],'time')); 
    time = intersect(time,ncread([srfpath 'rhum.sig995' '.' num2str(yr) '.nc'],'time')); 
    time = intersect(time,ncread([srfpath 'air.sig995' '.' num2str(yr) '.nc'],'time')); 
    time = intersect(time,ncread([srfpath 'slp' '.' num2str(yr) '.nc'],'time')); 
    
    % ncep time --> matlab datenumber
    % for some reason need to add a 48 hour offset....
    % some dates are referenced to yr 0, some to 1800?
    if time(1) > 1e7
        dntime = datenum(1,1,1)+(time-48)/24;
    else
        dntime = datenum(1800,1,1)+time/24;
    end
    % only select forcing up to last observation for final year..
    if yr  == yrRng(2)
        dntime = dntime(dntime <= dn_trng(2));
    end
    
    
    nt = length(dntime);
    
    % note: surface flux variables are on a T62 grid (192 x 94) and
    % surface variables are on a 2.5x2.5 deg grid (144 x 73) 
    latT62 = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'],'lat');
    lonT62 = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'],'lon');
    
    lat25 = ncread([srfpath 'rhum.sig995' '.' num2str(yr) '.nc'],'lat');
    lon25 = ncread([srfpath 'rhum.sig995' '.' num2str(yr) '.nc'],'lon');
    
    % Find ncep indices that bound model domain (padded by 1 degree)
    % note: max and min are 'switched' here because ncep lat decreases
    % monotonically
    
    pad = 1;
    
    [~, min_T62(1)] = min(abs(lon_rng(1)-pad-lonT62));
    [~, max_T62(1)] = min(abs(lon_rng(2)+pad-lonT62));
    
    [~, max_T62(2)] = min(abs(lat_rng(1)-pad-latT62));
    [~, min_T62(2)] = min(abs(lat_rng(2)+pad-latT62));
    
    [~, min_25(1)] = min(abs(lon_rng(1)-pad-lon25));
    [~, max_25(1)] = min(abs(lon_rng(2)+pad-lon25));
    
    [~, max_25(2)] = min(abs(lat_rng(1)-pad-lat25));
    [~, min_25(2)] = min(abs(lat_rng(2)+pad-lat25));
    
    % initialize output vectors here
    %dv = datevec(dntime);
    %[~, yearfrac] = date2doy(dntime);
    DateTime = dntime;%dec_year(dntime);
    
    u10m = zeros(nt,1);
    v10m = zeros(nt,1);
    nSWRS = zeros(nt,1);
    nLWRS = zeros(nt,1);
    nSHTFL = zeros(nt,1);
    nLHTFL = zeros(nt,1);
    PRATE = zeros(nt,1);
    PRES = zeros(nt,1);
    RHUM = zeros(nt,1);
    AIRT = zeros(nt,1);
    uStress = zeros(nt,1);
    vStress = zeros(nt,1);
    CURL = zeros(nt,1);
    
    % time dimension here
    min_T62(3) = 1;
    max_T62(3) = Inf;
    
    min_25(3) = 1;
    max_25(3) = Inf;
    
    
    % get indices for hyperslab
    lonslab = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'], 'lon',min_T62(1),1+max_T62(1)-min_T62(1),1);
    latslab = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'], 'lat',min_T62(2),1+max_T62(2)-min_T62(2),1);
    n_ind = max_T62-min_T62+1;
    % load surface_flux ncep variables
    y_u10m = ncread([flxpath 'uwnd.10m.gauss' '.' num2str(yr) '.nc'], 'uwnd',min_T62,n_ind,[1 1 1]);
    y_v10m = ncread([flxpath 'vwnd.10m.gauss' '.' num2str(yr) '.nc'], 'vwnd',min_T62,n_ind,[1 1 1]);
    y_nswrs = ncread([flxpath 'nswrs.sfc.gauss' '.' num2str(yr) '.nc'], 'nswrs',min_T62,n_ind,[1 1 1]);
    y_nlwrs = ncread([flxpath 'nlwrs.sfc.gauss' '.' num2str(yr) '.nc'], 'nlwrs',min_T62,n_ind,[1 1 1]);
    y_shtfl = ncread([flxpath 'shtfl.sfc.gauss' '.' num2str(yr) '.nc'], 'shtfl',min_T62,n_ind,[1 1 1]);
    y_lhtfl = ncread([flxpath 'lhtfl.sfc.gauss' '.' num2str(yr) '.nc'], 'lhtfl',min_T62,n_ind,[1 1 1]);
    y_prate = ncread([flxpath 'prate.sfc.gauss' '.' num2str(yr) '.nc'], 'prate',min_T62,n_ind,[1 1 1]);
    y_uflx = ncread([flxpath 'uflx.sfc.gauss' '.' num2str(yr) '.nc'], 'uflx',min_T62,n_ind,[1 1 1]);
    y_vflx = ncread([flxpath 'vflx.sfc.gauss' '.' num2str(yr) '.nc'], 'vflx',min_T62,n_ind,[1 1 1]);
    
    
    % load surface ncep variables
    lonslab_25 = ncread([srfpath 'slp.' num2str(yr) '.nc'], 'lon',min_25(1),1+max_25(1)-min_25(1),1);
    latslab_25 = ncread([srfpath 'slp.' num2str(yr) '.nc'], 'lat',min_25(2),1+max_25(2)-min_25(2),1);
    n_ind = max_25-min_25+1;
    y_rhum = ncread([srfpath 'rhum.sig995' '.' num2str(yr) '.nc'], 'rhum',min_25,n_ind,[1 1 1]);
    y_air = ncread([srfpath 'air.sig995' '.' num2str(yr) '.nc'], 'air',min_25,n_ind,[1 1 1]);
    y_slp = ncread([srfpath 'slp' '.' num2str(yr) '.nc'], 'slp',min_25,n_ind,[1 1 1]);
    
    %
    % calculate curl
    %
    % Coordinate transform from deg to km
    %reflon = mean(lonslab);
    %reflat = mean(latslab);
    % meanm from mapping toolbox
    [latmean,lonmean] = meanm(latyr,lonyr);
    % calculate distance between longitudes @ reflat
    x_scale = distance(latmean,lonslab(1),latmean,lonslab(end))./(lonslab(end)-lonslab(1));
    %x_dist and y_dist in meters
    x_dist = 1000*deg2km(lonslab-lonmean).*x_scale;
    y_dist = 1000*deg2km(latslab-latmean);
    [X,Y] = meshgrid(y_dist,x_dist);
    
    % linearly interpolate latitude and longitude to ncep time variable
    % for ncep time out of range of observations, reference lat and lon are
    % used
    
    %%%!!! need to grab fenceposts from previous and following year for smooth interpolation....
    
    latint = interp1(t,lat,dntime,'linear',latmean);
    lonint = interp1(t,lon,dntime,'linear',lonmean);
    for jj = 1:nt
        [~, ila] = min(abs(latslab-latint(jj)));
        [~, ilo] = min(abs(lonslab-lonint(jj)));
        [~, ila25] = min(abs(latslab_25-latint(jj)));
        [~, ilo25] = min(abs(lonslab_25-lonint(jj)));
        u10m(jj) = y_u10m(ilo,ila,jj);
        v10m(jj) = y_v10m(ilo,ila,jj);
        nSWRS(jj) = y_nswrs(ilo,ila,jj);
        nLWRS(jj) = y_nlwrs(ilo,ila,jj);
        nSHTFL(jj) = y_shtfl(ilo,ila,jj);
        nLHTFL(jj) = y_lhtfl(ilo,ila,jj);
        PRATE(jj) = y_prate(ilo,ila,jj);
        uStress(jj) = y_uflx(ilo,ila,jj);
        vStress(jj) = y_vflx(ilo,ila,jj);
        jjcurl = curl(X,Y,y_uflx(:,:,jj),y_vflx(:,:,jj));
        CURL(jj) = jjcurl(ilo,ila);
        PRES(jj) = y_slp(ilo25,ila25,jj);
        RHUM(jj) = y_rhum(ilo25,ila25,jj);
        AIRT(jj) = y_air(ilo25,ila25,jj);
    end
    
    F.u10m = [F.u10m;u10m];
    F.v10m = [F.v10m;v10m];
    F.nSWRS = [F.nSWRS;nSWRS];
    F.nLWRS = [F.nLWRS;nLWRS];
    F.nSHTFL = [F.nSHTFL;nSHTFL];
    F.nLHTFL = [F.nLHTFL;nLHTFL];
    F.PRATE = [F.PRATE;PRATE];
    F.PRES = [F.PRES;PRES];
    F.RHUM = [F.RHUM;RHUM];
    F.AIRT = [F.AIRT;AIRT];
    F.uStress = [F.uStress;uStress];
    F.vStress = [F.vStress;vStress];
    F.CURL = [F.CURL;CURL];
    F.DateTime = [F.DateTime;DateTime];
end
                        


