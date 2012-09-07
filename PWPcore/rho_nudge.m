

if ismember(it,tprofind)
    oldTracer = Tracer;
    Sold = S;
    Told = T;
    diven = find(tprofind == it);
    
    % mix mixed layer to observed mixed layer depth
    mld = float.iml(diven);
    mlmix;
    
    for ii = 1:nactive
        tr = float_tracers{ii};
        d = find(~isnan(float.tr(:,diven,tr2ind(tr))));
        fldens = sw_dens0(float.S(:,diven),float.T(:,diven));
        % identify mixed layer and thermolcine portion of profiles
        dml = find(d <= mld);
        dd = find(d > mld);
        % mixed layer values are nudged directly to float data by depth
        Tracer(dml,tr2ind(tr)) = float.tr(dml,diven,tr2ind(tr));
        % thermocline values are nudged by interpolating to density
        % surfaces -- should minimize isopycnal heaving effects
        Tracer(dd,tr2ind(tr)) = interp1(fldens(dd),float.tr(dd,diven,tr2ind(tr)),Sig(dd),'linear','extrap');
        % nudge T and S to profile values
        Tracer(d,tr2ind(tr)) = float.tr(d,diven,tr2ind(tr));
    end
    
    %Tracer = squeeze(tr_float(:,:,diven));
    D_Tracer = Tracer-oldTracer; 
    outt = [outt t(it)];
    outdS = [outdS S-Sold];
    outdT = [outdT T-Told];
    outS = [outS S];
    outT = [outT T];
    outTra=cat(3,outTra, Tracer);
    outD_Tra = cat(3,outD_Tra, D_Tracer);
    outPV = [outPV gpvo];
end
