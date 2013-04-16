% -------------------------------------------------------------------------
%	IniHydro - sets initial conditions for the hydrography
%
%		Initial conditions : ML Depth = 32 m
%				     Tml = 24.4 C
%				     Sml = 35.1 psu
%		Boundary conditions : (@ zmax)
%				     Tbot = 2.99
%				     Sbot = 34.56
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% Set initial temperature and salinity profiles
% -------------------------------------------------------------------------

T=zeros(nz,1); S=zeros(nz,1); UV=zeros(nz,2); epsUV=1e-8*ones(nz-1,1);

I = zeros(nz,1); Ia = I; % light

load alohainithydro % initialize profile from HOE-DYLAN1 
%                     %(assumably 05-23-2012 0000) 
% load alohainithydro2007Feb
tr=data;
tr(1,5) = 0; % set shallowest depth to 0

T=interp1(tr(:,5),tr(:,7),z,'linear');
S=interp1(tr(:,5),tr(:,8),z,'linear');	% interpolate to model grid
lat0 = tr(1,3);
lon0 = tr(1,4);

T0=T(1); S0=S(1);
TB=T(end); SB=S(end);
zmld=32; mld=zmld/dz;

%Sig=Sigref+Alpha*(T-Tref)+Beta*(S-Sref);	% compute density
Sig = sw_dens0(S,T);
% Sig = sw_dens(S,T, z); % Luo: change to in-situ density
% initialize storage variables
Ta=T; Sa=S; Siga=Sig; UVa=UV;  tml=T(1); sml=S(1); zmld2=zmld; %ta=yrstart;
TotalHeat = dz*sum(T(z<=TSOint_z))/TSOint_z;
TotalSalt = dz*sum(S(z<=TSOint_z))/TSOint_z;

wct0=mean(T); wss0=mean(S);

