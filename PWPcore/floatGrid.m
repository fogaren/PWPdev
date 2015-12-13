
function [float] = floatGrid(float_path,floatfile,float_tracers,z)




    floatFileName = fullfile(float_path,floatfile);
    if exist([floatFileName,'.mat'],'file') > 0
        load(floatFileName,'FT')
    else
        FT = parseFloatViz([floatFileName, '.txt']);
        save([floatFileName,'.mat'],'FT');
    end
    
    ntracers = length(float_tracers);
    
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
    [float.zml, float.iml] = calcmld(gsw_sigma0(float.S,float.T),z,0.03);
    
    ndives = size(float.T,2);
    nz = length(z);
    float.tr = zeros(nz,ndives,ntracers);
    for ii = 1:ntracers
        tr = float_tracers{ii};
        [~,float.(tr)] = findFloatProfile(FT,z,tr);
        % no float data from top 4 meters -- replace with 5 m data
        float.(tr)(1:4,:) = repmat(float.(tr)(5,:),4,1);
        if strcmpi(tr,'O2')
        % unit conversion from mmol m-3 --> mol/m-3
            float.O2 = float.O2./1e3;
        end
    end
  
    
    float.siggrid = ((floor(min(float.sig0(:)))):0.01:(ceil(max(float.sig0(:)))))';
    float.tr_sig = nan([length(float.siggrid),ndives,ntracers]);
    for ii = 1:ndives
        for jj = 1:ntracers
            float.([tr '_sig'])(:,ii) = bindata(float.sig0(:,ii),...
                float.(tr)(:,ii),float.siggrid);
        end
    end
    

