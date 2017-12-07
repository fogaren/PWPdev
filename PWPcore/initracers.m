% -------------------------------------------------------------------------
%		initialize tracers and create index map
% -------------------------------------------------------------------------

%tracer_name is set in pwp_main



Tracer = zeros(nz,ntracers);

% list of all potential gases
gaslist = {'He','Ne','Ar','Kr','Xe','O2','O18','O17','O35','O36'};




% identify which gases are to be run
gases = intersect(gaslist,tracer_name);
ngas = length(gases);
% if ngas > 1
%     % from BATS
%     load batsinitgas_99;
% end
% Gas = zeros(nz,ngas);

xG = zeros(length(ngas));

for igas = 1:ngas
    gas = gases{igas};
    if strcmp(gas,'O17')
        xG(igas) = gas_mole_fract('O2');
        Tracer(:,tr2ind(gas)) = gasmoleq(S,T,gas);
        o17ind = tr2ind('O17');
    elseif strcmp(gas,'O18')
        xG(igas) = gas_mole_fract('O2');
        Tracer(:,tr2ind(gas)) = gasmoleq(S,T,gas);
        o18ind = tr2ind('O18');
    elseif strcmp(gas,'O36')
        ini = find(strcmp('O2',initgas_head));
        xG(igas) = gas_mole_fract('O2');
    elseif strcmp(gas,'O35')
        ini = find(strcmp('O2',initgas_head));
        xG(igas) = gas_mole_fract('O2');
    elseif ismember(gas,float_tracers)
        % Luo: do not know how to amende this part
        if floatON_OFF == 1 
            %Tracer(:,tr2ind(gas)) = sw_dens0(float.S(:,3),float.T(:,3)).*float.tr(:,3,tr2ind(gas))./1e6;
            % initializes with 3rd dives because often first dive or two
            % are shallow and will not initialize entire water column
            Tracer(:,tr2ind(gas)) = float.tr(:,3,tr2ind(gas));
            %Tracer(499:end,tr2ind(gas)) = Tracer(498,tr2ind(gas));
        elseif strcmpi(floatON_OFF,'glider')
            load([glider_path '/' tracerInitFile]);
            Tracer(:,tr2ind('O2')) = gasmoleq(S,T,'O2').*interp1(zInit,O2satInit,z);
        else
            % This initializes whole water column at 100% sat
            Tracer(:,tr2ind('O2')) = gasmoleq(S,T,gas);
        end
        xG(igas) = gasmolfract(gas);
    else
        Tracer(:,tr2ind(gas)) = gasmoleq(S,T,gas);
        xG(igas) = gasmolfract(gas);
%         ini = find(strcmp(gas,initgas_head));
%         Tracer(:,tr2ind(gas)) = interp1(initgas(:,1),initgas(:,ini),z).*gasmoleq(S,T,gas)./100;
%         xG(igas) = gas_mole_fract(gas);
    end
end

o2ind = tr2ind('O2');

% Tra = Tracer;
% Luo: reinitialize some of storage variables to save computation time
Tra = zeros(size(Tracer,1), size(Tracer,2), floor(nt/tintv));
Tra(:,:,1) = Tracer(:,:);
TotalOxy = dz*sum(Tracer((z<=TSOint_z),tr2ind('O2')))/TSOint_z;


% -------------------------------------------------------------------------
%		Gas exchange diagnostic variables
% -------------------------------------------------------------------------

%  DIAGNOSTICS: initialize variables that will be used to store gas fluxes
acflux=zeros(ngas,1); % diagnostic: air injection complete trapping flux -- used in each timepoint
apflux=zeros(ngas,1); % diagnostic: air injection partial trapping flux -- used in each timepoint
geflux=zeros(ngas,1); % diagnostic: gas exchange flux -- used in each time point
Acflux=acflux; % used to store Ac fluxes for reporting purposes
Apflux=apflux; % used to store Ap fluxes for reporting purposes 
Geflux=geflux; % used to store GE fluxes for reporting purposes
acfluxcum=zeros(ngas,1); % diagnostic: cumulative air injection complete trapping flux -- used to accumulate fluxes since last recording
apfluxcum=zeros(ngas,1); % diagnostic: cumulative air injection partial trapping flux -- used to accumulate fluxes since last recording
gefluxcum=zeros(ngas,1); % diagnostic: cumulative gas exchange flux -- used to accumulate fluxes since last recording
fluxcumnum=0; % initizalize number of data points being accumulated in the fluxes so know how to interpret the numbers
FluxNum=fluxcumnum; % use to store fluxcumnum for reporting purposes
GPVO = [];gpvo = [];



% Zbub=zbscale*(0.3*wspeed-1.1);  %bubble penetration depth, parameterization from graham et al, 2004
% Zbub(Zbub<0)=0; % sets any negative values to 0
% phydro=rho_m*g*Zbub/atm_Pa; % calculates hydrostatic pressure in atm 

