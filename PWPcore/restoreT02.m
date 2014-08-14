nd = datenum(floor(t(it))+1,1,1) - datenum(floor(t(it)),1,1);
tidx = find(abs(t(it)-tobs)*nd*86400<=dt/2);
if ~isempty(tidx)
    tidx = tidx(1);
    rstT_state = 1;
    rstT = (Tobs(:,tidx) - T)/rstT_scale/86400*dt;
    rstT(~isfinite(rstT)) = 0;
    rstT_tstop = t(it) + rstT_scale/nd;
    T = T + rstT;
elseif rstT_state == 1
    if t(it)<=rstT_tstop
        T = T + rstT;
    else
        rstT_state = 0;
    end
end