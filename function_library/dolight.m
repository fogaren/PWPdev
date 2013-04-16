% Calculate light field using attenuation, adjust light according to
% obseved isopycnal displacement (potential density Sig)
%% load/estimate attenuation
try
    load attenuation.mat
catch
    K = zeros(nz,1);
    K_z = [10,20,30,40,50,75,100,150,200];
    K_v = [0.15,0.087,0.066,0.056,0.051,0.046,0.044,0.043, 0.043];
    K(z<=K_z(1)) = K_v(1);
    for i = 2:length(K_z)
        K(z>K_z(i-1)&z<=K_z(i)) = K_v(i);
    end
    K(z>K_z(end)) = K_v(end);
end
%% Light Profile
I = SWR(it) * exp(-K.*z);
% adjust according to observed isopycnal displacement
tobs1 = tobs(1:end-1);
tobs2 = tobs(2:end);
idx = find(tobs1<=t(it)&tobs2>t(it));
if ~isempty(idx)
    Sig_obsp1 = Sig_obs(:,idx);
    Sig_obsp2 = Sig_obs(:,idx+1);
    Sig_obsp1 = interp1(zobs, Sig_obsp1, z, 'linear');
    Sig_obsp2 = interp1(zobs, Sig_obsp2, z, 'linear');
    Sig_obsp = Sig_obsp1 + (Sig_obsp2 - Sig_obsp1)/(tobs(idx+1)-tobs(idx)) ...
        * (t(it) - tobs(idx));
    Sigi = Sig_obsp(~isnan(Sig_obsp));
    zi = z(~isnan(Sig_obsp));
    % Sigi has to be monotonically decreasing toward surface
    Sigi1 = Sigi(end);
    zi1 = zi(end);
    for jj = length(Sigi)-1:-1:1
        if Sigi(jj)<Sigi1(1)
            Sigi1 = [Sigi(jj); Sigi1];
            zi1 = [zi(jj); zi1];
        end
    end
    % interpolation to find adjusted depth z according to observed Sigma
    if max(zi1)>=150
        z_adj = interp1(Sigi1, zi1, Sig, 'linear');
        idx = find(~isnan(z_adj));
        if idx(1)>1
            dzz = (z_adj(idx(1)) - z(1))/(idx(1)-1);
            z_adj(1:idx(1)-1) = z(1):dzz:(z_adj(idx(1))-dzz)+dzz/1e6;
        end
        if idx(end)<length(z_adj)
            dzz = (z(end) - z_adj(idx(end)))/(length(z_adj) - idx(end));
            dzz = max(dzz, 0);
            z_adj(idx(end)+1:end) = z_adj(idx(end))+dzz:dzz:z(end)+dzz/1e6;
        end
        if sum(isnan(z_adj))>0
            pause
        end
        I = SWR(it) * exp(-K.*z_adj);
    end
end
if it>1
    Ia = [Ia, I];
else
    Ia = I;
end