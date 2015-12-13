% function to break Argo data into discrete profiles

function [tout,dataout] = findFloatProfile(T,zgrid,varName)


profs = unique(T.stn(T.stn > 0));
nProfs = length(profs);
tout = nan(1,nProfs);
for ii = 1:nProfs
    d = T.stn == profs(ii);
    dataout(:,ii) = naninterp1(T.depth(d),T.(varName)(d),zgrid);
    tout(ii) = nanmean(T.daten(d));
end
end   
   
function [out] = naninterp1(x, Y, xi)
    MIN_DATA_POINTS = 5;
    szY = size(Y);
    out = nan(length(xi),szY(2));
    for ii = 1:szY(2)
        gd = ~isnan(Y(:,ii)) & ~isnan(x);
        % at least two points needed to interpolate
        if sum(gd) >= MIN_DATA_POINTS
            out(:,ii) = interp1(x(gd),Y(gd,ii),xi);
        else
            out(:,ii) = nan.*xi;
        end
    end
end

    