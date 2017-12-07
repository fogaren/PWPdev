% -------------------------------------------------------------------------
%	IniHydro - sets initial conditions for the hydrography
%
%		Interpolates first float profile to model grid
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% Set initial temperature and salinity profiles
% -------------------------------------------------------------------------

%T=zeros(nz,1); S=zeros(nz,1); 
UV=zeros(nz,2); epsUV=1e-8*ones(nz-1,1);


d = find(~isnan(float.T(:,1)));
T=interp1(z(d),float.T(d,1),z,'linear','extrap');
d = find(~isnan(float.S(:,1)));
S=interp1(z(d),float.S(d,1),z,'linear','extrap');	% interpolate to model grid

T0=T(1); S0=S(1);
TB=T(end); SB=S(end);
zmld = float.zml(1); mld=float.iml(1);

%Sig=Sigref+Alpha*(T-Tref)+Beta*(S-Sref);	% compute density
Sig = gsw_sigma0(S,T);
% initialize storage variables
Ta=T; Sa=S; Siga=Sig; UVa=UV;  tml=T(1); sml=S(1);
TotalHeat = dz*sum(T(z<=TSOint_z))/TSOint_z;
TotalSalt = dz*sum(S(z<=TSOint_z))/TSOint_z;

wct0=mean(T); wss0=mean(S);

