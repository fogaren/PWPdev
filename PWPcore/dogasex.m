%
%		gasexch.m	exchanges gases from mixed layer to
%				atmosphere
%
% DESCRIPTION:-------------------------------------------------------------
%
% Calculate air-sea fluxes and steady-state supersat based on:
% Liang, J.-H., C. Deutsch, J. C. McWilliams, B. Baschek, P. P. Sullivan, 
% and D. Chiba (2013), Parameterizing bubble-mediated air-sea gas exchange 
% and its effect on ocean ventilation, Global Biogeochem. Cycles, 27, 
% 894?905, doi:10.1002/gbc.20080.


% -------------------------------------------------------------------------
% Oxygen isotope fractionation factors
% -------------------------------------------------------------------------

% cap17O2_eq:  Equilibrium cap17O as a function of temperature from Luz
% (2009 (in press))
%
if exist('lambda','var')
    
    %cap17eq = T(1).*0.6+1.8;
    % constant 8 per meg 17Deq value
    cap17eq = 8;
    
    % set equilibrium fractionation to equal cap17eq
    a18ge = 1+(-0.730 + 427./(T(1)+273.15))./1000;  % from Benson and Kraus (1980)
    a17ge = a18ge.^lambda.* (cap17eq./1e6+1);
    a36ge = a18ge.^2;
    a35ge = a18ge*a17ge;
end

for igas=1:ngas     % do all the gases
   
    % correct rates for equilibrium and kinetic fractionation factors
    gas = gases{igas};
    if ismember(gas,{'O18','O36','O35'})
        [D, Sc] = gasmoldiff(S(1),T(1),'O2');
        age = eval(['a',gas(2:end),'ge']);
        agek = eval(['a',gas(2:end),'gek']);
        Geq = age.*gasmoleq(S(1),T(1),gas);
        Sc = Sc.*agek.^(-1/2);
        D =  D.*agek.^(1/2);
    else   
        [D, Sc] = gasmoldiff(S(1),T(1),gas);
        Geq = gasmoleq(S(1),T(1),gas);
        
    end
    
    % NEED to check - slp or patmdry?
    % Fluxes are in mol m-3 s-1
    [geflux(igas),acflux(igas),apflux(igas),~,pv] = airseafunc(Tracer(1,tr2ind(gas)),wspeed(it),S(1),T(1),slp(it),gas);
    %[geflux(igas),apflux(igas),acflux(igas),~,pv] = fbub_L13(Tracer(1,tr2ind(gas)),wspeed(it),S(1),T(1),slp(it),'O2');
    Tracer(1:mld,tr2ind(gas))=Tracer(1:mld,tr2ind(gas)) + (geflux(igas)+acflux(igas)+apflux(igas))*dt/(dz*mld); %change in conc = old conc + change due to gas exchanve, complete trapping, partial trapping
    %the dt/dz/mld are to convert flux to a concentration change.

    % now accumulate the gas fluxes
    apfluxcum(igas)=apfluxcum(igas)+apflux(igas);
    acfluxcum(igas)=acfluxcum(igas)+acflux(igas);
    gefluxcum(igas)=gefluxcum(igas)+geflux(igas);
end

fluxcumnum=fluxcumnum+1; % number of fluxes accumulated so know how to average the numbers
gpv = pv;
if igas == o2ind
    gpvo = gpv;
end

