% main pwp model module


%tic
%t0 = clock;

%
% -------------------------------------------------------------------------
% Initialize model parameters
% -------------------------------------------------------------------------

iniparams;
% inihydrors97;
inihydrors_hawaii;
inifloatdata;
iniforcing;
inifctraquik;               % Initialize useful factors
inibio;                     % initialze biological parameters
inio2isotopes;              % initialize oxygen isotope parameters
initracers;



% -------------------------------------------------------------------------
% Main time step loop
% -------------------------------------------------------------------------
rstS_state = 0;             % restoring salinity state: 1 == undergoing
for it=1:nt
    
    T(1)=T(1)+thf(it);		% add sensible + latent heat flux
    S(1)=S(1)*FWFlux(it);   % alter salinity due to precip/evap
    if rstS_ON_OFF == 1
        restoreS;           % restoring salinity
    end
    if rstS_state == 0      % when rstS_ON_OFF is 0, rstS_state is always 0;
                            % otherwise rstS_state will be set to 0 or 1 by
                            % routine "restoreS"
        S=S+hsc;            % add horizontal eddy salt convergence
    end
    T=T+rhf(it)*dRdz;       % add radiant heat to profile
    T=T+hhc;                % add horizontal eddy heat convergence
    dogasheatcorr;          % maintain gas sat. when heat is added
    dostins;                % do static instability adjustment
    addmom;                 % add wind stress induced momentum
    dobrino;                % do bulk Ri No Adjustment
    oxyprod;                % add biological oxygen
    gasexchak;              % exchange gases
    dogrino;                % do gradient  Ri No Adjustment
    advdif;                 % advect and diffuse
    dooutput;
    if floatON_OFF == 1, modelout; end    % if time, save data
    
end

%etime(clock,t0)/60

%toc