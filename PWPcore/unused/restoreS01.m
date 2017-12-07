nd = datenum(floor(t(it))+1,1,1) - datenum(floor(t(it)),1,1);
tidx = find(abs(t(it)-tobs)*nd*86400<=dt/2);
if ~isempty(tidx)
    tidx = tidx(1);
    rstS_state = 1;
    rstS = (Sobs(:,tidx) - S)/rstS_scale/86400*dt;
    rstS(~isfinite(rstS)) = 0;
    rstS_tstop = t(it) + rstS_scale/nd;
    S = S + rstS;
elseif rstS_state == 1
    if t(it)<=rstS_tstop
        S = S + rstS;
    else
        rstS_state = 0;
    end
end