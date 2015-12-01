
<<<<<<< HEAD
%function [float, startday, stopday] = inifloatdata(float_path,floatfile,floatON_OFF)
=======
%function [float yrstart yrstop] = inifloatdata(floatfile)
>>>>>>> origin/NCEP-forcing



if floatON_OFF == 1
<<<<<<< HEAD
    floatFileName = fullfile(float_path,floatfile);
    if exist([floatFileName,'.mat'],'file') > 0
        load(floatFileName,'FT')
    else
        FT = parseFloatViz([floatFileName, '.txt']);
        save([floatFileName,'.mat'],'FT');
    end
    
    float_tracers = {'O2','NO3'};
    
    activetr = intersect(float_tracers,tracer_name);
    nactive = length(activetr);
    
    % top few measurement points sometimes are bad...removed here
    [~,float.lon] = findFloatProfile(FT,z,'lon');
    float.lon = nanmean(float.lon,1);
    float.lon_mean = nanmean(float.lon);
    
    [~,float.lat] = findFloatProfile(FT,z,'lat');
    float.lat = nanmean(float.lat,1);
    
    float.lat_mean = nanmean(float.lat);
    [~,float.T] = findFloatProfile(FT,z,'T');
    float.T(1:4,:) = repmat(float.T(5,:),4,1);
    [~,float.S] = findFloatProfile(FT,z,'S');
    float.S(1:4,:) = repmat(float.S(5,:),4,1);
    [~,float.t] = findFloatProfile(FT,z,'daten');
    float.t = nanmean(float.t,1);
    % fill in missing gps reads with linear interp
    float.lon = naninterp1(float.t',float.lon',float.t)';
    float.lat = naninterp1(float.t',float.lat',float.t)';
    float.sig0 = gsw_sigma0(float.S,float.T);
    %float.t(1:4,:) = repmat(float.t(5,:),4,1);
    [float.zml, float.iml] = calcmld(gsw_sigma0(float.S,float.T),z,0.125);
    
    ndives = size(float.T,2);
    float.tr = zeros(nz,ndives,ntracers);
    for ii = 1:nactive
        tr = float_tracers{ii};
        [~,float.tr(:,:,tr2ind(tr))] = findFloatProfile(FT,z,tr);
        % no float data from top 4 meters -- replace with 5 m data
        float.tr(1:4,:,tr2ind(tr)) = repmat(float.tr(5,:,tr2ind(tr)),4,1);
    end
    
    % unit conversion from mmol m-3 --> mol/m-3
    float.tr(:,:,tr2ind('O2')) = float.tr(:,:,tr2ind('O2'))./1e3;
    % Multiply by correction factor....
    float.tr(:,:,tr2ind('O2')) = O2fact.*float.tr(:,:,tr2ind('O2'));
    
    if(~exist('startday','var'))
        startday = float.t(1,1);
    end
    % decimal date of end of float data (pad one day)
    if(~exist('stopday','var'))
        %stopday = float.t(1,end)+1/365;
        % t in days
        stopday = float.t(1,end)+1;
    end
    float.siggrid = ((floor(min(float.sig0(:)))):0.01:(ceil(max(float.sig0(:)))))';
    float.tr_sig = nan([length(float.siggrid),ndives,nactive]);
    for ii = 1:ndives
        for jj = 1:nactive
            float.tr_sig(:,ii,jj) = bindata(float.sig0(:,ii),...
                float.tr(:,ii,jj),float.siggrid);
        end
    end
    % seaglider data - need to sort by date - need to deal with Nan below
    % 200m
elseif strcmpi(floatON_OFF,'glider')
    load([glider_path '/' gliderfile]);
    it = find(strcmp('dectime',data_header));
    %U = sortrows(UP,it);
    float_tracers = {'O2'};
    activetr = intersect(float_tracers,tracer_name);
    nactive = length(activetr);
    [float.lon] = findGliderProf(UP,z,'lon',data_header);
    float.lon = nanmean(float.lon,1);
    float.lon_mean = nanmean(float.lon);
    [float.lat] = findGliderProf(UP,z,'lat',data_header);
    float.lat = nanmean(float.lat,1);
    float.lat_mean = nanmean(float.lat);
    [float.T] = findGliderProf(UP,z,'tempc',data_header);
    float.T(1:4,:) = repmat(float.T(5,:),4,1);
    [float.S] = findGliderProf(UP,z,'salin',data_header);
    float.S(1:4,:) = repmat(float.S(5,:),4,1);
    [float.t] = findGliderProf(UP,z,'daten',data_header);
    float.t = nanmean(float.t,1);
    %float.t(1:4,:) = repmat(float.t(5,:),4,1);
    
    ndives = size(float.T,2);
    float.tr = zeros(nz,ndives,ntracers);
    for ii = 1:nactive
        tr = float_tracers{ii};
        if strcmp('O2',tr)
            trstr = 'optode_dphase_oxygenc';
            trScaleFac = (1000+gsw_sigma0(float.S,float.T))./1e6;
        else
            trstr = tr;
            trScaleFac = 1;
        end
        [float.tr(:,:,tr2ind(tr))] = trScaleFac.*findGliderProf(UP,z,trstr,data_header);
        % no float data from top 4 meters -- replace with 5 m data
        float.tr(1:4,:,tr2ind(tr)) = repmat(float.tr(5,:,tr2ind(tr)),4,1);
    end
        
        
        
end

%function [float, startday, stopday] = inifloatdata(float_path,floatfile,floatON_OFF)



if floatON_OFF == 1
    floatFileName = fullfile(float_path,floatfile);
    if exist([floatFileName,'.mat'],'file') > 0
        load(floatFileName,'FT')
    else
        FT = parseFloatViz([floatFileName, '.txt']);
        save([floatFileName,'.mat'],'FT');
    end
    
=======
    load([float_path '/' floatfile]);
>>>>>>> origin/NCEP-forcing
    float_tracers = {'O2','NO3'};
    
    activetr = intersect(float_tracers,tracer_name);
    nactive = length(activetr);
    
    % top few measurement points sometimes are bad...removed here
<<<<<<< HEAD
    [~,float.lon] = findFloatProfile(FT,z,'lon');
    float.lon = nanmean(float.lon,1);
    float.lon_mean = nanmean(float.lon);
    
    [~,float.lat] = findFloatProfile(FT,z,'lat');
    float.lat = nanmean(float.lat,1);
    
    float.lat_mean = nanmean(float.lat);
    [~,float.T] = findFloatProfile(FT,z,'T');
    float.T(1:4,:) = repmat(float.T(5,:),4,1);
    [~,float.S] = findFloatProfile(FT,z,'S');
    float.S(1:4,:) = repmat(float.S(5,:),4,1);
    [~,float.t] = findFloatProfile(FT,z,'daten');
    float.t = nanmean(float.t,1);
    % fill in missing gps reads with linear interp
    float.lon = naninterp1(float.t',float.lon',float.t)';
    float.lat = naninterp1(float.t',float.lat',float.t)';
    float.sig0 = gsw_sigma0(float.S,float.T);
    %float.t(1:4,:) = repmat(float.t(5,:),4,1);
    [float.zml, float.iml] = calcmld(gsw_sigma0(float.S,float.T),z,0.125);
=======
    [~,float.lon] = findprofile(data,z,find(strcmp('lon',data_header)));
    float.lon = nanmean(float.lon,1);
    float.lon_mean = mean(float.lon);
    [~,float.lat] = findprofile(data,z,find(strcmp('lat',data_header)));
    float.lat = nanmean(float.lat,1);
    float.lat_mean = mean(float.lat);
    [~,float.T] = findprofile(data,z,find(strcmp('T',data_header)));
    float.T(1:4,:) = repmat(float.T(5,:),4,1);
    [~,float.S] = findprofile(data,z,find(strcmp('S',data_header)));
    float.S(1:4,:) = repmat(float.S(5,:),4,1);
    [~,float.t] = findprofile(data,z,find(strcmp('yrdate',data_header)));
    float.t = nanmean(float.t,1);
    %float.t(1:4,:) = repmat(float.t(5,:),4,1);
>>>>>>> origin/NCEP-forcing
    
    ndives = size(float.T,2);
    float.tr = zeros(nz,ndives,ntracers);
    for ii = 1:nactive
        tr = float_tracers{ii};
<<<<<<< HEAD
        [~,float.tr(:,:,tr2ind(tr))] = findFloatProfile(FT,z,tr);
=======
        [~,float.tr(:,:,tr2ind(tr))] = findprofile(data,z,find(strcmp(tr,data_header)));
>>>>>>> origin/NCEP-forcing
        % no float data from top 4 meters -- replace with 5 m data
        float.tr(1:4,:,tr2ind(tr)) = repmat(float.tr(5,:,tr2ind(tr)),4,1);
    end
    
<<<<<<< HEAD
    % unit conversion from mmol m-3 --> mol/m-3
    float.tr(:,:,tr2ind('O2')) = float.tr(:,:,tr2ind('O2'))./1e3;
    % Multiply by correction factor....
    float.tr(:,:,tr2ind('O2')) = O2fact.*float.tr(:,:,tr2ind('O2'));
    
    if(~exist('startday','var'))
        startday = float.t(1,1);
    end
    % decimal date of end of float data (pad one day)
    if(~exist('stopday','var'))
        %stopday = float.t(1,end)+1/365;
        % t in days
        stopday = float.t(1,end)+1;
    end
    float.siggrid = ((floor(min(float.sig0(:)))):0.01:(ceil(max(float.sig0(:)))))';
    float.tr_sig = nan([length(float.siggrid),ndives,nactive]);
    for ii = 1:ndives
        for jj = 1:nactive
            float.tr_sig(:,ii,jj) = bindata(float.sig0(:,ii),...
                float.tr(:,ii,jj),float.siggrid);
        end
=======
    % unit conversion from umol/kg --> mol/m-3
    float.tr(:,:,tr2ind('O2')) = sw_dens0(float.S,float.T).*float.tr(:,:,tr2ind('O2'))./1e6;
    % Multiply by correction factor....
    float.tr(:,:,tr2ind('O2')) = O2fact.*float.tr(:,:,tr2ind('O2'));
    
    if(~exist('yrstart'))
        yrstart = float.t(1,1);
    end
    % decimal date of end of float data (pad one day)
    if(~exist('yrstop'))
        yrstop = float.t(1,end)+1/365;
>>>>>>> origin/NCEP-forcing
    end
    % seaglider data - need to sort by date - need to deal with Nan below
    % 200m
elseif strcmpi(floatON_OFF,'glider')
    load([glider_path '/' gliderfile]);
    it = find(strcmp('dectime',data_header));
<<<<<<< HEAD
    %U = sortrows(UP,it);
    float_tracers = {'O2'};
    activetr = intersect(float_tracers,tracer_name);
    nactive = length(activetr);
    [float.lon] = findGliderProf(UP,z,'lon',data_header);
    float.lon = nanmean(float.lon,1);
    float.lon_mean = nanmean(float.lon);
    [float.lat] = findGliderProf(UP,z,'lat',data_header);
    float.lat = nanmean(float.lat,1);
    float.lat_mean = nanmean(float.lat);
    [float.T] = findGliderProf(UP,z,'tempc',data_header);
    float.T(1:4,:) = repmat(float.T(5,:),4,1);
    [float.S] = findGliderProf(UP,z,'salin',data_header);
    float.S(1:4,:) = repmat(float.S(5,:),4,1);
    [float.t] = findGliderProf(UP,z,'daten',data_header);
=======
    %U = sortrows(U,it);
    float_tracers = {'O2'};
    activetr = intersect(float_tracers,tracer_name);
    nactive = length(activetr);
    [float.lon] = findGliderProf(U,z,'lon',data_header);
    float.lon = nanmean(float.lon,1);
    float.lon_mean = nanmean(float.lon);
    [float.lat] = findGliderProf(U,z,'lat',data_header);
    float.lat = nanmean(float.lat,1);
    float.lat_mean = nanmean(float.lat);
    [float.T] = findGliderProf(U,z,'tempc',data_header);
    float.T(1:4,:) = repmat(float.T(5,:),4,1);
    [float.S] = findGliderProf(U,z,'salin',data_header);
    float.S(1:4,:) = repmat(float.S(5,:),4,1);
    [float.t] = findGliderProf(U,z,'dectime',data_header);
>>>>>>> origin/NCEP-forcing
    float.t = nanmean(float.t,1);
    %float.t(1:4,:) = repmat(float.t(5,:),4,1);
    
    ndives = size(float.T,2);
    float.tr = zeros(nz,ndives,ntracers);
    for ii = 1:nactive
        tr = float_tracers{ii};
        if strcmp('O2',tr)
            trstr = 'optode_dphase_oxygenc';
<<<<<<< HEAD
            trScaleFac = (1000+gsw_sigma0(float.S,float.T))./1e6;
=======
            trScaleFac = sw_dens0(float.S,float.T)./1e6;
>>>>>>> origin/NCEP-forcing
        else
            trstr = tr;
            trScaleFac = 1;
        end
<<<<<<< HEAD
        [float.tr(:,:,tr2ind(tr))] = trScaleFac.*findGliderProf(UP,z,trstr,data_header);
=======
        [float.tr(:,:,tr2ind(tr))] = trScaleFac.*findGliderProf(U,z,trstr,data_header);
>>>>>>> origin/NCEP-forcing
        % no float data from top 4 meters -- replace with 5 m data
        float.tr(1:4,:,tr2ind(tr)) = repmat(float.tr(5,:,tr2ind(tr)),4,1);
    end
        
        
        
end
