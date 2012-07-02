%%% Loads NCEP forcing


%%% if Forcing.mat exists, then loads from file, else extract forcing from
%%% ncep archive
%%% note: currently only 2000-mid2011 available...

try
    load forcing.mat;
catch
    if floatON_OFF == 1
        F = get_forcing(ncep_path,float.lat(5,:),float.lon(5,:),float.t(5,:));
        latitude = float.lat_mean;
    elseif floatON_OFF == 0
        tseries = yrstart:yroutstp:yrmax;
        latseries = tseries*0 + lat0;
        lonseries = tseries*0 + lon0;
        F = get_forcing(ncep_path, latseries, lonseries, tseries);
        latitude = lat0;
        yrstop = F.DateTime(end) + 1/365;
    end
end

