% -------------------------------------------------------------------------
%
%  Set all optional model parameters here
%
%  nnnnn
% -------------------------------------------------------------------------
%
% PWP paths

% CHANGE pwp_root to point to where PWP is located on your local machine
pwp_root = '/Users/dnicholson/Documents/github/';
core_path = fullfile(pwp_root, 'PWPdev/PWPcore');
lib_path = fullfile(pwp_root, 'PWPdev/function_library');

% CHANGE these to point to files where ncep and argo float data is located
float_path = '/Users/dnicholson/Documents/MATLAB/Datasets/floatdata';
ncep_path = '/Users/dnicholson/Documents/MATLAB/Datasets/ncep.reanalysis';
%
% Path for core functions here
addpath(core_path,0);

% -------------------------------------------------------------------------
% run date range (if commented out, will use 1st/last float profile dates)
% -------------------------------------------------------------------------
dz = 2;
zmax = 1000;

startday = datenum(2013,1,1);
stopday = datenum(2014,2,1);
lat0 = 60;
lon0 = -30;

% -------------------------------------------------------------------------
% fixed location or float following
% -------------------------------------------------------------------------
floatON = 0;
addpath(fullfile(core_path,'float'));
%%% model currently running for bermuda...
if floatON == 1
    floatfile = '6391BermudaQC';
else
    hydroinitfunc = @inihydrors97;
end

% -------------------------------------------------------------------------
% list of tracers to be run
% -------------------------------------------------------------------------
% specify which tracers to include here

tracer_name = {'O2','NO3','Ar'};
ntracers = length(tracer_name);
tracer_ind = num2cell(1:ntracers);

% map tracer name to index and vice versa
% now can call for example: ind2tr('Ar') to get 1 or tr2ind(1) to get 'Ar'
ind2tr = containers.Map(tracer_ind,tracer_name);
tr2ind = containers.Map(tracer_name,tracer_ind);

% -------------------------------------------------------------------------
%  biology parameters
% -------------------------------------------------------------------------
pfract = 0;
bioON_OFF = 0;  % biology on/off switch for o2 isotopes.  1 = biology on, 0 = biology off 
loadprod = 0;  % load NCP from file
prodfile = 'inProd.mat';

oxyamp =  10;%5;  % amplitude of NCP (mol O2 m-2 y-1)
oxycons= 18; % magnitude of biological consumption -- integrated
%c14_2_GPP = 2.7;  % set fixed GOP:NPP(14C) here
O2fact = 1.07;  % scaling factor for float O2

% -------------------------------------------------------------------------
% smoothing factor for wind curl
% -------------------------------------------------------------------------
airseafunc = @fas_L13;
LowPassFactor = 1E-5;

% -------------------------------------------------------------------------
%  physical parameters
% -------------------------------------------------------------------------

% Ekman heat transport (W/m2)
EkmHeatConv = 12;
%EkmHeatConv = 0;
% Depth range of lateral heat flux (in 100's of meters)
VHEC= 2;
% Ekman salt convergence due to fresh water downward pumping
EkmSaltConv = 1.75E-6;  
VSEC = VHEC;
% Vertical diffusivity (m2/s)
Kz = 8*1e-5;
TracerDiffFactor = 1;
Kt = TracerDiffFactor*Kz;

% density offset for id of mixed layer in float data
dens_off = 0.05;

% restoring parameters
% Trestore = 1;
% tau_T = 30;
% Srestore = 1;
% tau_S = 30;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% -------------------------------------------------------------------------
% output storage arrays
% -------------------------------------------------------------------------

outt = [];
outS = [];
outT = [];
outdS = [];
outdT = [];
outTra = [];
outD_Tra = [];
outPV = [];

% -------------------------------------------------------------------------
% run model
% -------------------------------------------------------------------------

 pwp;
 %modelout;




