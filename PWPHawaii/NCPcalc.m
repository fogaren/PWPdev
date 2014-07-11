figure;
hold on;
zint = [1 121];

load('inProd_6401HawaiiQC.mat')
[Jbio, Jbio_int,Jbio_rng,tJbio] = Jbio_yr(2012,tProd,outdt,Prod,z,zint);
plot(tJbio,Jbio_rng,'b','LineWidth',2);
[Jbio, Jbio_int,Jbio_rng,tJbio] = Jbio_yr(2011,tProd,outdt,Prod,z,zint);
plot(tJbio,Jbio_rng,'b','LineWidth',2);
load('inProd_6403HawaiiQC.mat')
[Jbio, Jbio_int,Jbio_rng,tJbio] = Jbio_yr(2011,tProd,outdt,Prod,z,zint);
plot(tJbio,Jbio_rng,'r','LineWidth',2);
[Jbio, Jbio_int,Jbio_rng,tJbio] = Jbio_yr(2012,tProd,outdt,Prod,z,zint);
plot(tJbio,Jbio_rng,'r','LineWidth',2);
load('inProd_6891HawaiiQC.mat')
[Jbio, Jbio_int,Jbio_rng,tJbio] = Jbio_yr(2012,tProd,outdt,Prod,z,zint);
plot(tJbio,Jbio_rng,'c','LineWidth',2);
[Jbio, Jbio_int,Jbio_rng,tJbio] = Jbio_yr(2011,tProd,outdt,Prod,z,zint);
plot(tJbio,Jbio_rng,'c','LineWidth',2);
load('inProd_7622HawaiiQC.mat')
[Jbio, Jbio_int,Jbio_rng,tJbio] = Jbio_yr(2011,tProd,outdt,Prod,z,zint);
plot(tJbio,Jbio_rng,'Color',[0 0.5 0],'LineWidth',2);
[Jbio, Jbio_int,Jbio_rng,tJbio] = Jbio_yr(2012,tProd,outdt,Prod,z,zint);
plot(tJbio,Jbio_rng,'Color',[0 0.5 0],'LineWidth',2);