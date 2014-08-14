
%function [float yrstart yrstop] = inifloatdata(floatfile)



if floatON_OFF == 1
    load([float_path '/' floatfile]);
    float_tracers = {'O2','NO3'};
    
    activetr = intersect(float_tracers,tracer_name);
    nactive = length(activetr);
    
    % top few measurement points sometimes are bad...removed here
    [~,float.lon] = findprofile(data,z,find(strcmp('lon',data_header)));
    float.lon = nanmean(float.lon,1);
    float.lon_mean = nanmean(float.lon);
    [~,float.lat] = findprofile(data,z,find(strcmp('lat',data_header)));
    float.lat = nanmean(float.lat,1);
    float.lat_mean = nanmean(float.lat);
    [~,float.T] = findprofile(data,z,find(strcmp('T',data_header)));
    float.T(1:4,:) = repmat(float.T(5,:),4,1);
    [~,float.S] = findprofile(data,z,find(strcmp('S',data_header)));
    float.S(1:4,:) = repmat(float.S(5,:),4,1);
    [~,float.t] = findprofile(data,z,find(strcmp('yrdate',data_header)));
    float.t = nanmean(float.t,1);
    %float.t(1:4,:) = repmat(float.t(5,:),4,1);
    
    ndives = size(float.T,2);
    float.tr = zeros(nz,ndives,ntracers);
    for ii = 1:nactive
        tr = float_tracers{ii};
        [~,float.tr(:,:,tr2ind(tr))] = findprofile(data,z,find(strcmp(tr,data_header)));
        % no float data from top 4 meters -- replace with 5 m data
        float.tr(1:4,:,tr2ind(tr)) = repmat(float.tr(5,:,tr2ind(tr)),4,1);
    end
    
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
    end
    % seaglider data - need to sort by date - need to deal with Nan below
    % 200m
elseif strcmpi(floatON_OFF,'glider')
    load([glider_path '/' gliderfile]);
    it = find(strcmp('dectime',data_header));
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
    float.t = nanmean(float.t,1);
    %float.t(1:4,:) = repmat(float.t(5,:),4,1);
    
    ndives = size(float.T,2);
    float.tr = zeros(nz,ndives,ntracers);
    for ii = 1:nactive
        tr = float_tracers{ii};
        if strcmp('O2',tr)
            trstr = 'optode_dphase_oxygenc';
            trScaleFac = sw_dens0(float.S,float.T)./1e6;
        else
            trstr = tr;
            trScaleFac = 1;
        end
        [float.tr(:,:,tr2ind(tr))] = trScaleFac.*findGliderProf(U,z,trstr,data_header);
        % no float data from top 4 meters -- replace with 5 m data
        float.tr(1:4,:,tr2ind(tr)) = repmat(float.tr(5,:,tr2ind(tr)),4,1);
    end
        
        
        
end
