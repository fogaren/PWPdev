
% calculate kpp parameters
[KM, KT, KS, ghatu, ghatv, ghatt, ghats, hbl, D] = kpp(UV(:,1),UV(:,2),T,S,-z,-z,1.5e-3.*taux(it)./(dt./rho_m/dz),1.5e-3.*tauy(it)./(dt./rho_m/dz),thf(it),FWFlux(it),rhf(it),f);
% set up tridiagonal diffusion weighting
wKM = KM.*dt/dz/dz;
TDKM = diag(-wKM) + diag(wKM(2:end)./2,-1) + diag(wKM(1:end-1)./2,1);
% set boundary conditions
TDKM(1,1) = -wKM(2)./2;       % one-way diff for top box
TDKM(end,end) = 0;            % bottom C doesn't change
TDKM(end,end-1) = 0;          % bottom C doesn't change

wKT = KT*dt/dz/dz;
TDKT = diag(-wKT) + diag(wKT(2:end)./2,-1) + diag(wKT(1:end-1)./2,1);
% set boundary conditions
TDKT(1,1) = -wKT(2)./2;       % one-way diff for top box
TDKT(end,end) = 0;            % bottom C doesn't change
TDKT(end,end-1) = 0;          % bottom C doesn't change


wKS = KS*dt/dz/dz;
TDKS = diag(-wKS) + diag(wKS(2:end)./2,-1) + diag(wKS(1:end-1)./2,1);
% set boundary conditions
TDKS(1,1) = -wKS(2)./2;       % one-way diff for top box
TDKS(end,end) = 0;            % bottom C doesn't change
TDKS(end,end-1) = 0;          % bottom C doesn't change

if wv_up(it)
    ax = diag([0; -Cte(:,it)]) + diag(Cte(:,it),1);
else
    ax = diag([Cte(:,it); 0]) + diag(-Cte(:,it),-1);
end

AnM = diag(ones(nz,1))+TDKM + ax;
AnT = diag(ones(nz,1))+TDKT + ax;
AnS = diag(ones(nz,1))+TDKS + ax;

Tend = T(end);
Send = S(end);
for ii = 1:10
    T = (AnT./10)*T;
    S = (AnS./10)*S;
    UV(:,1) = (AnM./10)*UV(:,1);
    UV(:,2) = (AnM./10)*UV(:,2);
end
% T(end) = T(end);
% S(end) = S(end);
% UV(:,1) = AnM*UV(:,1);
% UV(:,2) = AnM*UV(:,2);
% 
% for ii = 1:ntracers
%     %tr = ind2tr(ii);
%     Tracer(:,ii) = AnS * Tracer(:,ii);
% end