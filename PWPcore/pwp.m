% main pwp model module


%tic
%t0 = clock;

%
% -------------------------------------------------------------------------
% Initialize model parameters
% -------------------------------------------------------------------------

iniparams;
% inihydrors97;
[float, startday, stopday] = inifloatdata(float_path,floatfile,floatON_OFF);
inihydrors;
iniforcing;
inifctraquik;               % Initialize useful factors
inibio;                     % initialze biological parameters
if ismember(tracer_name,'O18')
    inio2isotopes;          % initialize oxygen isotope parameters
end
initracers;



% -------------------------------------------------------------------------
% Main time step loop
% -------------------------------------------------------------------------
for it=1:nt
    T(1)=T(1)+thf(it);		% add sensible + latent heat flux
    S(1)=S(1)*FWFlux(it);   % alter salinity due to precip/evap
    S=S+hsc;                % add horizontal eddy salt convergence
    if rst_ON_OFF > 0
        restoreS;           % restoring salinity
    end
    T=T+rhf(it)*dRdz;       % add radiant heat to profile
    T=T+hhc;                % add horizontal eddy heat convergence
    if rst_ON_OFF > 0
        restoreT;           % restoring temperature
    end
    dogasheatcorr;          % maintain gas sat. when heat is added
    dostins;                % do static instability adjustment
    addmom;                 % add wind stress induced momentum
    dobrino;                % do bulk Ri No Adjustment
    if isoadjON_OFF
        dolight;                % calculate light field; adjust light according
    end                        % to observed isopycnal displacement
    oxyprod;                % add biological oxygen
    dogasex;                % exchange gases
    dogrino;                % do gradient  Ri No Adjustment
    advdif2;                 % advect and diffuse
    if floatON_OFF ~= 0 
        %modelout; 
        rho_nudge;
    end                     % if time, save data
    dooutput;
    
end

%etime(clock,t0)/60

%toc