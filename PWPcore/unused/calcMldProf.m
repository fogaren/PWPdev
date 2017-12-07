function [zmld, iml] = calcMldProf(dens,z,dens_off)

% density offset threshold (kg/m3)
%dens_off = 0.125;



dens0 = dens(find(~isnan(dens),1,'first'));
try
    iml = find(dens - dens0 > dens_off,1,'first');
    zmld = z(iml);
catch
    zmld = z(end);
    iml = length(z);
end

    