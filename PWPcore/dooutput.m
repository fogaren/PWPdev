%
%		doOutput - every so often, accumulate snapshot of
%			the situation
now=mod(it,tintv);	% time counter (integer)

if now == 0
    %  	if now == 1			% do first time only
    %	    fprintf('Kz = %8.3e, dt = %8.2f hr\n',Kz,dt/3600);
    %  	    fprintf('Month Tsurf Ssurf MLDepth  StIns  BRiN  GRiN\n');
    %  	  end
    iout = iout+1;
%     Ta=[Ta T]; Sa=[Sa S]; Siga=[Siga Sig]; 
    Ta(:,iout) = T; Sa(:,iout) = S; Siga(:,iout) = Sig; 
    ta=[ta t(it)]; 
    %Ia(:,iout) = I; z_adja(:,iout) = z_adj;
    TotalHeat=[TotalHeat dz*sum(T(z<=TSOint_z))/TSOint_z];
    TotalSalt = [TotalSalt dz*sum(S(z<=TSOint_z))/TSOint_z]; 
    TotalOxy = [TotalOxy dz*sum(Tracer(z<=TSOint_z,tr2ind('O2')))/TSOint_z];
    
    tml = [tml T(1)]; sml = [sml S(1)];
    nbri=nbri/noften; ngri=ngri/noften; nstin=nstin/noften;
    nnbri=[nnbri nbri]; nngri=[nngri ngri]; nnstin=[nnstin nstin];
    zmld=[zmld dz*mld]; 
    %zmld2 = [zmld2 dz*mld_sig(Sig)];
    
    
    nclock=nclock + 1;
%     fprintf('%i,%i\r', it, nclock);
    if nclock >= NumPerYear				% report once a decade! 
        %fprintf('%.2f\r',t(it));
        disp(datestr(t(it),'dd-mmm-yyyy'));
        nclock = 0;
    end
    %
    
    %
    %Anom = cat(3,Anom, anom); 
%     Tra=cat(3,Tra, Tracer);
    Tra(:,:,iout) = Tracer(:,:);
    GPVO = [GPVO gpvo]; 
    Acflux=[Acflux acfluxcum]; Apflux=[Apflux apfluxcum]; Geflux=[Geflux gefluxcum]; % diagnostics for ai part, ai comp, gas ex fluxes all in units of ncc/g (or ucc/g)
    FluxNum=[FluxNum fluxcumnum];
    acfluxcum=zeros(ngas,1); apfluxcum=zeros(ngas,1); gefluxcum=zeros(ngas,1); % reset fluxes to start accumulating again
    fluxcumnum=0; 
    
    %DICa=[DICa DIC]; % store DIC values
    %Acfluxdic=[Acfluxdic acfluxcumdic]; Apfluxdic=[Apfluxdic apfluxcumdic]; Gefluxdic=[Gefluxdic gefluxcumdic]; % diagnostics for ai part, ai comp, gas ex fluxes all in units of ncc/g (or ucc/g)
    %acfluxcumdic=0; apfluxcumdic=0; gefluxcumdic=0; % reset fluxes to start accumulating again

   
    nbri=0;ngri=0;nstin=0;		% reset activity counters
end

