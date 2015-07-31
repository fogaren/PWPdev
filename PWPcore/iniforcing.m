%%% Loads NCEP forcing


%%% if Forcing.mat exists, then loads from file, else extract forcing from
%%% ncep archive

try
    load forcing.mat;
    if F.DateTime(1) < startday || F.DateTime(end) > yrmax
        datetime = F.DateTime;
        idx = (datetime>=startday&datetime<=yrmax);
        names = fieldnames(F);
        for iname = 1:length(names)
            eval(['F.', names{iname}, '=F.', names{iname}, '(idx);'])
        end
        startday = F.DateTime(1);
        stopday = F.DateTime(end);
    end
catch
    if floatON_OFF == 1 || strcmpi('glider',floatON_OFF)
        %tbuff = 10./365; % 10 day buffer for loading forcing
        tbuff = 10;
        fltrng = find(float.t > startday - tbuff & float.t < stopday + tbuff);
        F = get_forcing(ncep_path,float.lat(fltrng),float.lon(fltrng),float.t(fltrng));
        latitude = float.lat_mean;
    elseif floatON_OFF == 0
        tseries = startday:1/4:yrmax;
        latseries = tseries*0 + lat0;
        lonseries = tseries*0 + lon0;
        F = get_forcing(ncep_path, latseries, lonseries, tseries);
        latitude = lat0;
        stopday = F.DateTime(end);
    end
end

% load salinity observations for restoring term
if rst_ON_OFF == 1
    load TS_CTD.mat
    Sig_obs = sw_dens0(Sobs, Tobs);
elseif rst_ON_OFF == 2
    load TS_SG.mat
    Sig_obs = sw_dens0(Sobs, Tobs);
elseif rst_ON_OFF == 3
    load TS_CTD_SG.mat
    Sig_obs = sw_dens0(Sobs, Tobs);
end
