% function to break Argo data into discrete profiles


function [divev,dataout] = findFloatProfile(T,zgrid,varName)


divev = Table(size(T,1),1);
profs = unique(T.stn);
nProfs = length(profs);
for ii = 1:nProfs
    d = T.stn == ii;
    dataout(:,ii) = naninterp1(T.depth(d),T.varName(d),zgrid);
end
    

while 1
    tind = find(isnan(data(bind:end,zcol)),1,'first')+bind-2;
    divev(bind:tind) = diven;

    dvout = interp1(data(bind:tind,zcol),data(bind:tind,varcol),zgrid);
    dataout(:,diven) = dvout;
    
    % find start of next prof
    bind = tind+2;
    if bind > length(divev)
        break
    end
    diven = diven + 1;
end




    