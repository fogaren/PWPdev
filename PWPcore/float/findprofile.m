% function to break Argo data into discrete profiles

function [divev,dataout] = findFloatProfile(T,zgrid,varName)




divev = Table(size(T,1),1);



nz = length(zgrid);

%dataout = NaN*zeros(diven*nz,size(data,2));

profs = unique(T.stn);
nProfs = length(profs);
for ii = 1:nProfs
    d = T.stn == ii;
    dataout(:,ii) = naninterp1(T.depth(d),T.varName(d),zgrid);
end
    
   
function [out] = naninterp1(x, Y, xi)
    MIN_DATA_POINTS = 5;
    szY = size(Y);
    out = nan(length(xi),szY(2));
    for ii = 1:szY(2)
        gd = ~isnan(Y(:,ii));
        % at least two points needed to interpolate
        if sum(gd) >= MIN_DATA_POINTS
            out(:,ii) = interp1(x(gd),Y(gd,ii),xi);
        else
            out(:,ii) = nan.*xi;
        end
    end
end

    