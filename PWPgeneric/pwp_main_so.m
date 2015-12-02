% -------------------------------------------------------------------------
%
%  Set all optional model paramters here
%
%  nnnnn
% -------------------------------------------------------------------------
%
% PWP paths

% CHANGE pwp_root to point to where PWP is located on your local machine
pwp_root = '/Users/Roo/github/PWP/';
data_root = '/Users/Roo/Documents/MATLAB/Datasets/';
core_path = [pwp_root 'PWPcore'];
lib_path = [pwp_root 'function_library'];

% CHANGE these to point to files where ncep and argo float data is located
float_path = fullfile(data_root,'floatdata');
glider_path = fullfile(data_root,'gliderdata');
ncep_path = fullfile(data_root,'ncep.reanalysis');
%
% Path for core functions here
addpath(core_path,0);
addpath(lib_path,0);

% -------------------------------------------------------------------------
% Model run parameters - yrstart and yrstop set auto if not specified
% -------------------------------------------------------------------------

%yrmax = 2012.999; % maximum end time, 12/30/2012 0000
%startday = datenum(2012,10,3);
%yrstop = 2014.9;
dz = 2;
zmax = 600; 
% -------------------------------------------------------------------------
% Running Mode, No float data or Nudging with float data
% -------------------------------------------------------------------------
floatON_OFF = 1; % floatON_OFF=0, No float data, fixed location 
             % floatON_OFF=1, Nudging with float data, location determined by
             % float data
%floatON_OFF = 'glider';             

% -------------------------------------------------------------------------
% Isopycnal adjustment and light attenuation
% -------------------------------------------------------------------------
isoadjON_OFF = 0; % isoadjON_OFF = 1 for isopyncal adjustment for and 
%                   light attuenuation calculations

% -------------------------------------------------------------------------
% list of tracers to be run
% -------------------------------------------------------------------------

%%%
floatfile = '6401HawaiiQC';
floatfile = '9018SoOcnQC';
%floatfile = '6976BermudaQC';
%floatfile = '0069BermudaQC';
%startday = datenum(2013,1,1);
% specify which tracers to include here
%tracer_name = {'Ar','O2','O18','O17'};
tracer_name = {'O2','NO3'};
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
loadprod = 1;  % load NCP from file
prodfile = ['inProd_',floatfile];
%oxyamp =  10;%5;  % amplitude of NCP (mol O2 m-2 y-1)
%oxycons= 18; % magnitude of biological consumption -- integrated
c14_2_GPP = 2.7;  % set fixed GOP:NPP(14C) here
O2fact =1;
if strcmpi(floatfile, '6403HawaiiQC.mat')
    O2fact = 0.97;
elseif strcmpi(floatfile, '6403HawaiiQCx.mat')
    O2fact = 0.98;  % scaling factor for float O2
elseif strcmpi(floatfile, '6401HawaiiQC.mat')
    O2fact = 1.01;  % scaling factor for float O2
elseif strcmpi(floatfile, '7622HawaiiQC.mat')
    O2fact = 0.985;  % scaling factor for float O2
elseif strcmpi(floatfile, '6891HawaiiQC.mat')
    O2fact = 0.97;  % scaling factor for float O2
elseif strcmpi(floatfile, '7672HawaiiQC.mat')
    O2fact = 0.97;  % scaling factor for float O2
elseif strcmpi(floatfile, '8374HOTQC.mat')
    O2fact = 0.97;  % scaling factor for float O2   
elseif strcmpi(floatfile, '8486HawaiiQC.mat')
    O2fact = 0.97;  % scaling factor for float O2
elseif strcmpi(floatfile, '8497HawaiiQC.mat')
    O2fact = 0.96;  % scaling factor for float O2 
end

% -------------------------------------------------------------------------
%  wind/gas exchange paramters
% -------------------------------------------------------------------------
%
airseafunc = @fas_N11;
% power of piston velocity
pvpower = 2; 
LowPassFactor = 0.99999; %1E-5;


% -------------------------------------------------------------------------
%  physical parameters
% -------------------------------------------------------------------------

% Ekman heat transport (W/m2)
EkmHeatConv = 50;
EkmHeatConv = 0;
% Depth range of lateral heat flux (in 100's of meters)
VHEC= 0.5;
% Ekman salt convergence (kg/m2/s)
EkmSaltConv = 0; 
% Depth range of lateral salt flux (in 100's of meters)
VSEC= 0.5;
% Restore model temperature and temperature (=1 only CTD data; =2 only sea
% glider data; =3 with Seaglider data fill gaps of CTD data) 
% or Not restore (=0)
rst_ON_OFF = 0;
rstT_scale = 5; % Temperature restoring time scale in days
rstS_scale = 5; % Salinity restoring time scale in days

% Vertical diffusivity (m2/s)
Kz = 8e-5; %11*1e-5;
TracerDiffFactor = 1;
Kt = TracerDiffFactor*Kz;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% -------------------------------------------------------------------------
% output storage arrays
% -------------------------------------------------------------------------

if floatON_OFF ~= 0

outt = [];
outS = [];
outT = [];
outdS = [];
outdT = [];
outTra = [];
outD_Tra = [];
outPV = [];
outProd = [];

end

% -------------------------------------------------------------------------
% run model
% -------------------------------------------------------------------------

 pwp;
 %[Sigref, zSigref] = meanz2sig(Siga, z, 125);
 
 if loadprod == 1
     outdO2 = squeeze(outD_Tra(:,o2ind,2:end));
     outdt = repmat(diff(outt),nz,1);
     Prod = Prod + outdO2./outdt;
     tProd = (outt(:,1:end-1)+outt(:,2:end))./2;
     save(prodfile,'tProd','Prod','outdt');
     O2a = squeeze(Tra(:,1,:));
     save([floatfile 'NCPdata.mat'],'ta','Ta','Sa','O2a','float');
 end
 %diagout_big;
 
% diagout;
