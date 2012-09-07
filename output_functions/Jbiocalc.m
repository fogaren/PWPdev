O2odt = squeeze(outD_Tra(:,o2ind,:));
O2odt(:,1) = [];
outdt = diff(outt);
outdt = repmat(outdt,500,1);
NCP = O2odt+outdt.*Prod.*tyr;
NCP = [zeros(length(z),1) NCP];
Jbio = cumsum(NCP,2);

Jbio_80_100 = dz.*sum(Jbio(40:50,:));
Jbio_60_80 = dz.*sum(Jbio(30:40,:));
Jbio_40_60 = dz.*sum(Jbio(20:30,:));
Jbio_20_40 = dz.*sum(Jbio(10:20,:));
Jbio_0_20 = dz.*sum(Jbio(1:10,:));
Jbio_int = dz.*sum(Jbio(1:50,:));