% -------------------------------------------------------------------------
% physical constants
% -------------------------------------------------------------------------

atm_Pa = 101325.0;      % atmospheric pressure in Pa
hcapy=1.e-6;			% heat capacity in deg/cal/m3
j2cal=0.23905;			% joules -> calories
tday = 60*60*24;        % seconds in a day
tyr = tday*365.25;      % seconds in a year (only used for bio rate conv.
g = 9.80665;              % grav. const. (m/s2)
rho_m = 1023;           % approx density
R = 8.314;              % gas constant
hfactor=540*1000/j2cal;	% converts watts to kg/s


% -------------------------------------------------------------------------
% Model parameters
% -------------------------------------------------------------------------

z = (1:dz:zmax)'; 
nz = length(z);
dtmin = 3600;

toutv = 8;
NumPerYear = 48; % screen output every # of recordings


BRiFac=g*dz/rho_m;		% factor for bulk Ri No Calculation
GRiFac=g*dz/rho_m;		% factor for Grad Ri No Calculation
BRiCrit=.65; GRiCrit=.25;	% critical values for overturning
TSOint_z = 600;         % z for depth integrated values