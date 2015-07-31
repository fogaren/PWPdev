% function to break Argo data into discrete profiles

function [divev,dataout] = findprofile(data,zgrid,varcol)

zcol = 8;

bind = 1;
tind = [];
divev = NaN*zeros(size(data,1),1);
diven = 1;


nz = length(zgrid);

%dataout = NaN*zeros(diven*nz,size(data,2));

while 1
    tind = find(isnan(data(bind:end,zcol)),1,'first')+bind-2;
    divev(bind:tind) = diven;
%     if diven == 189
%         debug = 1;
%     end
    dvout = naninterp1(data(bind:tind,zcol),data(bind:tind,varcol),zgrid);
    dataout(:,diven) = dvout;
    
    % find start of next prof
    bind = tind+2;
    if bind > length(divev)
        break
    end
    diven = diven + 1;
end
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

    