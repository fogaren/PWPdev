%%% Loads NCEP forcing


%%% if Forcing.mat exists, then loads from file, else extract forcing from
%%% ncep archive
%%% note: currently only 2000-mid2011 available...

try
    load forcing.mat;
    if F.DateTime(1) < yrstart || F.DateTime(end) > yrmax
        datetime = F.DateTime;
        idx = (datetime>=yrstart&datetime<=yrmax);
        names = fieldnames(F);
        for iname = 1:length(names)
            eval(['F.', names{iname}, '=F.', names{iname}, '(idx);'])
        end
        yrstart = F.DateTime(1);
        yrstop = F.DateTime(end);
    end
catch
    if floatON_OFF == 1 | strcmpi('glider',floatON_OFF)
        tbuff = 4./365; % 10 day buffer for loading forcing
        fltrng = find(float.t > yrstart - tbuff & float.t < yrstop + tbuff);
        F = get_forcing(ncep_path,float.lat(fltrng),float.lon(fltrng),float.t(fltrng));
        latitude = float.lat_mean;
    elseif floatON_OFF == 0
        tseries = yrstart:1/366/4:yrmax;
        latseries = tseries*0 + lat0;
        lonseries = tseries*0 + lon0;
        F = get_forcing(ncep_path, latseries, lonseries, tseries);
        latitude = lat0;
        yrstop = F.DateTime(end);
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
