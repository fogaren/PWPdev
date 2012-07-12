% -------------------------------------------------------------------------
% physical constants
% -------------------------------------------------------------------------

atm_Pa = 101325.0;      % atmospheric pressure in Pa
hcapy=1.e-6;			% heat capacity in deg/cal/m3
j2cal=0.23905;			% joules -> calories
tday = 60*60*24;        % seconds in a day
tyr = tday*365.25;      % seconds in a year
g = 9.807;              % grav. const. (m/s2)
rho_m = 1023;           % approx density
R = 8.314;              % gas constant



% -------------------------------------------------------------------------
% Model parameters
% -------------------------------------------------------------------------

z = [1:2:1500]'; 
nz = length(z);
dz = 2;
zmax = 1500; 

% yrstart = 2009 + 143/366; % initial time, 05/23/2011 00:00 (retrieved from HOE-DYLAN1, 05/23/2012, 22:00)
yrstart = 2007.1005;
yrmax = 2012 + 273/366; % maximum end time, 09/30/2012 0000
% lat0 = 22.75;
% lon0 = -158;
% recording interval in # per day
toutv = 1;
NumPerYear = 48; % screen output every # of recordings


BRiFac=g*dz/rho_m;		% factor for bulk Ri No Calculation
GRiFac=g*dz/rho_m;		% factor for Grad Ri No Calculation
BRiCrit=.65; GRiCrit=.25;	% critical values for overturning
TSOint_z = 600;         % z for depth integrated values