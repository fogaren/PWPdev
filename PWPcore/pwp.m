% main pwp model module


%tic
t0 = clock;

%
% -------------------------------------------------------------------------
% Initialize model parameters
% -------------------------------------------------------------------------

iniparams;
inifloatdata;
inihydro;
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
    T=T+rhf(it)*dRdz;       % add radiant heat to profile
    T=T+hhc;                % add horizontal eddy heat convergence
    dogasheatcorr;          % maintain gas sat. when heat is added
    dostins;                % do static instability adjustment
    addmom;                 % add wind stress induced momentum
    dobrino;                % do bulk Ri No Adjustment
    oxyprod;                % add biological oxygen
    dogasex;                % exchange gases
    dogrino;                % do gradient  Ri No Adjustment
    advdif;                 % advect and diffuse
    if floatON ~= 0         % restore physical profile to obs
        rho_nudge;
    end                     
    dooutput;               % if time, save data
    
end

disp(['run completed in: ',num2str(etime(clock,t0)/60),' minutes']);

%toc