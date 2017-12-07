function [zmld, iml] = calcmld(dens,z,dens_off)

% density offset threshold (kg/m3)
%dens_off = 0.125;

t = size(dens,2);
zmld = zeros(t,1);
iml = zeros(t,1);
for ii = 1:t
    dens0 = dens(find(~isnan(dens(:,ii)),1,'first'),ii);
    try
        ml = find(dens(:,ii) -dens0 > dens_off,1,'first');
        zmld(ii) = z(ml);
        iml(ii) = ml;
    catch
        zmld(ii) = z(end);
        iml(ii) = length(z);
    end
end
    