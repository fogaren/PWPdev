

% -------------------------------------------------------------------------
% Load wind forcing - QScat winds
% -------------------------------------------------------------------------


%load HybridForcingQ.mat;  %% Qscat where available, otherwise NCEP


% % -------------------------------------------------------------------------
% % physical constants
% % -------------------------------------------------------------------------
% 
% atm_Pa = 101325.0;      % atmospheric pressure in Pa
% hcapy=1.e-6;			% heat capacity in deg/cal/m3
% j2cal=0.23905;			% joules -> calories
% tday = 60*60*24;        % seconds in a day
% tyr = tday*365.25;      % seconds in a year
% g = 9.807;              % grav. const. (m/s2)
% rho_m = 1023;           % approx density
% R = 8.314;              % gas constant

% % -------------------------------------------------------------------------
% % Model parameters
% % -------------------------------------------------------------------------
% 
% dz = 2;
% zmax = 1000;
% BRiFac=g*dz/rho_m;		% factor for bulk Ri No Calculation
% GRiFac=g*dz/rho_m;		% factor for Grad Ri No Calculation
% BRiCrit=.65; GRiCrit=.25;	% critical values for overturning
% TSOint_z = 600;         % z for depth integrated values

ta = startday; mlt=zeros(5,5); mls=zeros(5,5); wct=zeros(5,5); wcs=zeros(5,5);
EkpMaxDep = 550;

%
%		load the NCEP forcing (above) for the duration of the experiment
%		at 6 hourly intervals, with the following variables input
% 		from forcing.mat
%			 DateTime       time 					years
%			 LHTFL          latent heat flux 	watts/m^2
%			 PRATE          precipitation			kg/m^2
%			 PRES           sea level pressure	Pa
%			 SHTFL          sensible heat flux	watts/m^2
%			 nLWRS          net longwave radn	watts/m^2
%			 nSWRS          net shortwave radn	watts/m^2
%			 uStress        zonal stress			N/m^2
%			 uWind          zonal wind				m/s
%			 vStress        meridional stress	N/m^2
%			 vWind          meridional wind		m/s
%            CURL           wind stress curl   N/m^3
%


% calculated model parameters
ndays = stopday - startday;
dt=min([0.4*dz*dz/max(Kz) 0.4*dz*dz/max(Kt) dtmin]);	% time step must resolve diurnal scales (dt < 6 hours)
z=(dz/2:dz:zmax-dz/2)'; nz=length(z); zp=0:dz:zmax;       % useful depth vectors
%tmax=nyrs*tyr;                  % time constants
%treport = tyr;  nreport = treport/dt;           % report once a year

t = startday:(dt/tday):stopday;
nt = length(t);
%t=[1:nt]*dt/tyr + startday; tpf=2*pi*t/tyr;		% time vector, etc.
% recording time interval: convert to number of time steps
tintv=round(tday./(dt.*toutv));	

%
%		the following for easy sigmaT calculation
%		using a linearized equation of state
%
%
%
omega=2*pi/tday; f=2*omega*cosd(latitude);

% ------------------------------------------------------------------------
%       the wind stress curl data is very noisy as it is calculated
%       directly from wind stress data on 6-hourly basis, and we need
%       to filter out variations ocurring on times comparable to or less 
%       than a few inertial periods
% ------------------------------------------------------------------------
% 

oldcurl = F.CURL;


[b,a]=butter(12,.2/2);  % create low pass filter with 5 day period (if use 20 then get all zeros)
%               note that the nyquist limit is 2 per day
curl=filtfilt(b,a,F.CURL);    % and use a phase correcting implementation
ekp=curl/rho_m/f;			% compute vert vel. (pos. down) from curl
% wv = max vertical velocity on model t-grid (pos. up)
wv= -interp1(F.DateTime,ekp,t,'linear');     % actual curl calculated
nwmax=min(EkpMaxDep,zmax)/dz;
wvf=dt*[(nwmax:-1:1)/nwmax zeros(1,nz-nwmax)]'/dz;
%wvf0 = [(nwmax:-1:1)/nwmax zeros(1,nz-nwmax)]';
% upward w is positive
wv_up = wv > 0;
% vertical advection -  u*dt/dz (Courant number)
Ct = wvf*wv;
% average at edges between nodes
Cte = (Ct(1:end-1,:)+Ct(2:end,:))./2;

% do SUDM weighting for advection
% wp is weigth factor for when w is positive (upwelling)
%wf = zeros(nz-1,nt);
%wf(:,wv_up) = Ct(2:end,wv_up) + Ct(1:end-1,~wv_up);

% set up tridiagonal diffusion weighting
wKz = Kz*dt/dz/dz*ones(nz,1);
TDKz = diag(-wKz) + diag(wKz(2:end)./2,1) + diag(wKz(1:end-1)./2,-1);
% set boundary conditions
TDKz(1,1) = -wKz(2)./2;       % one-way diff for top box
TDKz(end,end) = 0;            % bottom C doesn't change
TDKz(end,end-1) = 0;          % bottom C doesn't change

wKt = Kt*dt/dz/dz*ones(nz,1);
TDKt = diag(-wKt) + diag(wKt(2:end)./2,1) + diag(wKt(1:end-1)./2,-1);
% set boundary conditions
TDKt(1,1) = -wKt(2)./2;       % one-way diff for top box
TDKt(end,end) = 0;            % bottom C doesn't change
TDKt(end,end-1) = 0;          % bottom C doesn't change

% % diffusion coefficients are time-invariant
% wim=Kz*dt/dz/dz*ones(nz,1); wp=wim; wim(1)=0; wi0=1-wp-wim; wi0(1)=1-wp(1);
% wimt=Kt*dt/dz/dz*ones(nz,1); wpt=wimt; wimt(1)=0; wi0t=1-wpt-wimt; wi0t(1)=1-wpt(1);

% -------------------------------------------------------------------------
%		vertical attenuation of w, going to zero at base of seasonal layer
%				For the stress: divide by rho and multiply by
%					dt/dz to get acceleration
%				and compute wind speed from components
%  -----------------------------------------------------------------------

taux=dt*F.uStress/rho_m/dz;  tauy=dt*F.vStress/rho_m/dz;

%if Qwinds    
    wspeed = (F.u10m.^2 + F.v10m.^2).^0.5;
%else   
%    wspeed = (uWind.^2 + vWind.^2).^0.5;
%end
%				and reiDateTime,curl,'r'nterpolate wind stress and speeds onto time vector
taux=interp1(F.DateTime,taux,t,'linear'); tauy=interp1(F.DateTime,tauy,t,'linear');
wspeed=interp1(F.DateTime,wspeed,t,'linear');

%  ------------------------------------------------------------------------ 
%		next compute heat flux, wind speed and radiant heat for run
%		and normalize for temperature change
%		NB: have to adjust offset in THF for closure
% -------------------------------------------------------------------------

htfact=hcapy*dt*j2cal/dz;	% converts to temperature change in cell
TotHeat = F.nLHTFL + F.nSHTFL + F.nLWRS + F.nSWRS;
ResidualHeat = csaps(F.DateTime,TotHeat,LowPassFactor,F.DateTime);  % use lowpassed heat offset
%ResidualHeat = csaps(DateTime,TotHeat,0.00,DateTime);  % use lowpassed heat offset
%NetHeatOffset = EkmHeatConv - ResidualHeat;


%%%%% CHANGED HERE


% actual net heat flux offset to make it sum to 0 over some time interval
% the above is to compensate for the net heat imbalance in the NCEP
% data for this locale partly compensated for ekman heat convergence
% (associated with downwelling of warm surface water)
rhf=-F.nSWRS*htfact; rhf=interp1(F.DateTime,rhf,t,'linear');
%???
thf=-(F.nLWRS + F.nLHTFL + F.nSHTFL - 0.*ResidualHeat)*htfact; 
%thf=-(F.nLWRS + F.nLHTFL + F.nSHTFL - ResidualHeat)*htfact; 

thf=interp1(F.DateTime,thf,t,'linear');
slp=interp1(F.DateTime,F.PRES/atm_Pa,t,'linear');     % compute/interpolate sea level pressure pascals -> atmospheres
% relative humidity in mm Hg?
ph2o=F.RHUM/100.*vpress(S(1),T(1)); % compute partial pressure of water in atm
ph2o=interp1(F.DateTime,ph2o,t,'linear'); 
patmdry=slp-ph2o; % pressure of dry air in atm -- used in gasexhak

try
    load EkmHeatConvF.mat;
    hhc = EkmHeatConv * hcapy * j2cal * dt;
    % hhc=-interp1(F.DateTime,EkmHeatConv*htfact,t,'linear');
    % Luo 2012.08.05, changed sign of hhc, so that positive EkmHeatConv
    % represents net influx of lateral heat, and vice versa
catch
    hhc = zeros(size(z));
    hhc_int = EkmHeatConv*htfact;
    vhec=zeros(zmax/dz,1);
    if VHEC ~= 0
        ndepvhec=100*VHEC/dz;
        hhc(1:ndepvhec)=hhc_int/ndepvhec;
    else
        hhc(1)=hhc_int;
    end
end

% Surface Shortwave radiation interpolated
SWR = interp1(F.DateTime,-F.nSWRS,t,'linear');
%  ------------------------------------------------------------------------
%  
%		differential irradiance curve, and the
%		surface irradiance history (minus sign for direction
%		of difference)
% -------------------------------------------------------------------------
  
dRdz=-diff(0.62*exp(-1.67*zp)+0.38*exp(-0.05*zp))';
  
  % param version from Hamme et a. (2006) light a bit deeper...use for HOT
  %dRdz=-diff(0.49*exp(-0.04*zp)+0.51*exp(-zp))';

% -------------------------------------------------------------------------
%		now compute fresh water flux effects
% -------------------------------------------------------------------------

FWfact=dt/dz;			% converts fw flux to salinity change


% -------------------------------------------------------------------------
%		net water flux = PRATE - LHTFL/factor
%		where PRATE is in kg/m^2/s
%		where factor = 0.23905 J/cal * 540 cal/g * 1000 g/kg
%		and LHTFL is in watts/m^2 = J / s/m^2
%		Also: net E - P is about 65 cm/y, so an offset is applied to balance the FWF
%		over the period, assuming that this is achieved by lateral FWF divergence
% -------------------------------------------------------------------------

NetEminusPOffset=csaps(F.DateTime,F.PRATE-F.nLHTFL/hfactor,LowPassFactor,F.DateTime);		% balance salt
% NetEminusPOffset=F.PRATE-F.nLHTFL/hfactor;		% balance salt
FWFlux=FWfact * (F.PRATE - F.nLHTFL/hfactor);% - NetEminusPOffset); 
FWFlux=1-FWFlux/1000;			% convert to salinity multiplier (1 - kg/m^3)
FWFlux=interp1(F.DateTime,FWFlux,t,'linear');		% recast onto time vector
try
    load EkmSaltConvF.mat;
    hsc = EkmSaltConv * dt;
% Luo 2012.08.04, Lateral salt flux distributed on a certain depth (VSEC) 
catch
    hsc = zeros(size(z));
    hsc_int = FWfact * EkmSaltConv;
    if VSEC ~= 0
        ndepvsec=100*VSEC/dz;
        hsc(1:ndepvsec)=hsc_int/ndepvsec;
    else
        hsc(1)=hsc_int;
    end
end

% -------------------------------------------------------------------------
%       calculating isopycnal displacement factor at each time step
% -------------------------------------------------------------------------
% load HD_Sig_Dis.mat
% SigDisFact = interp1(t_Sig_dis, Sig_dis_fact, t);
% SigDisFact(t<min(t_Sig_dis)|t>max(t_Sig_dis)) = 1.0;
% SigDisFact(isnan(SigDisFact)) = 1.0;
Sigref = 1024.469;
zSigref = 124.989;

% -------------------------------------------------------------------------
%		compute the weight factors for FUDM advection
%		but cannot include vertical advection because it
%		changes with time, so the minus and "0" factors
%		are provisional and will be adjusted for wv in advdif.m
%		(this is not done on a "wim")
% -------------------------------------------------------------------------

wim=Kz*dt/dz/dz*ones(nz,1); wf=wim; wim(1)=0; wi0=1-wf-wim; wi0(1)=1-wf(1);
wimt=Kt*dt/dz/dz*ones(nz,1); wpt=wimt; wimt(1)=0; wi0t=1-wpt-wimt; wi0t(1)=1-wpt(1);

% -------------------------------------------------------------------------
%	Various factors/vectors of convenience
% -------------------------------------------------------------------------

% index of float profile times

if floatON ~= 0
    tprofind = (round(interp1(t,1:length(t),float.t(1,:))));
end

% -------------------------------------------------------------------------
%		rotation matrix for velocity/momemtum
%		"f" factor is rotation effect due to coriolis
% -------------------------------------------------------------------------

angle=f*dt*.5;		% half angle of coriolis rotation during dt
cosang=cos(angle);
sinang=sin(angle);
rotn=[cosang -sinang; sinang cosang];	% velocity rotation matrix

% -------------------------------------------------------------------------
%		counters for tracking profile adjustment activity
% -------------------------------------------------------------------------

nbri=0;ngri=0;nstin=0;			% counters
nnbri=0;nngri=0;nnstin=0;		% accumulated counters
oldnow=0;                       % start with clean slate
noften=tintv/dt;                % how many iterations in a report cycle
nclock=0;                       % for telling time every so often
nlineret=0;


% -------------------------------------------------------------------------
%		observed temperature for restoring interpolated
% -------------------------------------------------------------------------



% Luo: reinitialize some of storage variables to save computation time 
Ta = zeros(length(z), floor(nt/tintv));
Sa = Ta; Siga = Ta; Ia = Ta; z_adja = Ta;
Ta(:,1) = T; Sa(:,1) = S; Siga(:,1) = Sig;
z_adja(:,1) = z;
iout = 1;

tempa = [];
    
    
