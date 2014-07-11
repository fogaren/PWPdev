%
%		adds/removes oxygen biologically
%
%

if bioON_OFF == 1  
    if loadprod == 1
        Prodt = Prodall(:,it);
    else
        Prodt = PofT(it)*Prod;
    end
    %Tracer(:,o2ind)=Tracer(:,o2ind)+PofT(it)*Prod;
    Tracer(:,o2ind)=Tracer(:,o2ind)+Prodt;
    %
    %DIC=DIC+PofT(it)*Prod*O2toC; % add biological flux to DIC pool based on redfield ratio
    
    % GPP in change in umol/kg per time-step
    dOP = GPP(:,it).*dt;
    % Respiration:  NOP = GOP + R
    dOR = Prodt-dOP;
    
    % Do photosythesis + respiration time-step
    % dOP = photosythesis (+oxygen)
    % dOR = respiration (-oxygen)
    T_K = T+273.15;
    if pfract
        D35p = -0.0572678132046329-0.104935049745242*(1000./T_K)+0.130233772527771*(1000./T_K).^2-0.0102900880119959*(1000./T_K).^3;
        D36p = -0.091258206019712-0.219309152781065*(1000./T_K)+0.253952203046618*(1000./T_K).^2-0.01999936037897*(1000./T_K).^3;
        a35p = 1+D35p./1000;
        a36p = 1+D36p./1000;
    end
    
    % Luo: messed up with O17 & O18?
    if ismember('O17',tracer_name)
        Tracer(:,o18ind) = Tracer(:,o18ind) + dOP.*a18p.*r18w + dOR.*a18r.*Tracer(:,o18ind)./Tracer(:,o2ind);
    end
    if ismember('O18',tracer_name)
        Tracer(:,o17ind) = Tracer(:,o17ind) + dOP.*a17p.*r17w + dOR.*a17r.*Tracer(:,o17ind)./Tracer(:,o2ind);
    end
    if ismember('O35',tracer_name)
        Tracer(:,tr2ind('O35')) = Tracer(:,tr2ind('O35')) + dOP.*a35p.*r35w + dOR.*a35r.*Tracer(:,tr2ind('O35'))./Tracer(:,o2ind);
    end
    if ismember('O36',tracer_name)
        Tracer(:,tr2ind('O36')) = Tracer(:,tr2ind('O36')) + dOP.*a36p.*r36w + dOR.*a36r.*Tracer(:,tr2ind('O36'))./Tracer(:,o2ind);
    end
end
