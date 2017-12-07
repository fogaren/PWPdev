% restoreTS.m

if Trestore == 1
    d = find(~isnan(Tobs(:,it)));
    T(d) = T(d) + dt.*restore(Tobs(d,it),T(d),tday.*tau_T);
end
if Srestore == 1
    d = find(~isnan(Sobs(:,it)));
    S(d) = S(d) + dt.*restore(Sobs(d,it),S(d),tday.*tau_T);
end