% relax model results towards observations
tscale = rstT_scale;
v2rst = T;
vobs = Tobs;

nd = datenum(floor(t(it))+1,1,1) - datenum(floor(t(it)),1,1); % number of days of that year
% time index for nearest observation profile before the model time step; the
% influence of observations has maximum range of tscale
tidx1 = find(tobs<=t(it)&(t(it)-tobs)*nd<=tscale/2);
if length(tidx1) > 1
    tidx1 = tidx1(end);
end
% time index for nearest observation profile after the model time step; the
% influence of observations has maximum range of tscale
tidx2 = find(tobs>=t(it)&(tobs-t(it))*nd<=tscale/2);
if length(tidx2) > 1
    tidx2 = tidx2(1);
end

% interpolated observation values at the time step; if the available
% observation is only on one side (i.e., observations available only before
% or only after the model time step), use that observation
if ~isempty(tidx1)&&~isempty(tidx2)
    v1 = vobs(:, tidx1);
    v2 = vobs(:, tidx2);
    vobs_itp = v1 + (v2-v1)/(tobs(tidx2)-tobs(tidx1))*(t(it)-tobs(tidx1));
    vobs_itp(isnan(v1)) = v2(isnan(v1));
    vobs_itp(isnan(v2)) = v1(isnan(v2));
elseif ~isempty(tidx1)
    vobs_itp = vobs(:,tidx1);
elseif ~isempty(tidx2)
    vobs_itp = vobs(:,tidx2);
end

if ~isempty(tidx1)||~isempty(tidx2)
    vobs_itp = interp1(zobs, vobs_itp, z);
    dv = (vobs_itp - v2rst) / tscale / 86400 * dt; % amount for relax
    dv(isnan(dv)) = 0;
    v2rst = v2rst + dv;
end

T = v2rst;