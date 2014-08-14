function [Jbio, Jbio_int,Jbio_rng,tJbio] = Jbio_yr(yr,tProd,outdt,Prod,z,zint)
% O2odt = squeeze(outD_Tra(:,o2ind,:));
% O2odt(:,1) = [];
% outdt = diff(outt);
% outdt = repmat(outdt,500,1);
d = find(floor(tProd) == yr);
tJbio = tProd(d);
outdt = outdt(:,d);
Prod = Prod(:,d);

NCP = outdt.*Prod;
%NCP = [zeros(length(z),1) NCP];
Jbio = cumsum(NCP,2);

r1 = find(zint(1) == z);
r2 = find(zint(2) == z);


Jbio_int = trapz(z(1:60),Jbio(1:60,:));
Jbio_rng = trapz(z(r1:r2),Jbio(r1:r2,:));

% Jbio_100_120 = dz.*sum(Jbio(51:60,:));
% Jbio_80_100 = dz.*sum(Jbio(41:50,:));
% Jbio_60_80 = dz.*sum(Jbio(31:40,:));
% Jbio_40_60 = dz.*sum(Jbio(21:30,:));
% Jbio_20_40 = dz.*sum(Jbio(11:20,:));
% Jbio_0_20 = dz.*sum(Jbio(1:10,:));
% 
% Jbio_80_120 = dz.*sum(Jbio(41:60,:));
% Jbio_40_80 = dz.*sum(Jbio(21:40,:));
% Jbio_0_40 = dz.*sum(Jbio(1:20,:));
% Jbio_int = dz.*sum(Jbio(1:60,:));
% 
% NCP_80_120 = tyr.*sum(Prod(41:60,:));
% NCP_40_80 = tyr.*sum(Prod(21:40,:));
% NCP_0_40 = tyr.*sum(Prod(1:20,:));
% NCP_int = tyr.*sum(Prod(1:60,:));