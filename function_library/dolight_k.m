% Calculate light field using attenuation, adjust light according to
% obseved isopycnal displacement (potential density Sig)
%% load/estimate attenuation
try
    load attenuation.mat
catch
    K = zeros(nz,1);
    K_z = [10,20,30,40,50,75,100,150,200];
    K_v = [0.15,0.087,0.066,0.056,0.051,0.046,0.044,0.043, 0.043];
    K(z<=K_z(1)) = K_v(1);
    for i = 2:length(K_z)
        K(z>K_z(i-1)&z<=K_z(i)) = K_v(i);
    end
    K(z>K_z(end)) = K_v(end);
end
%% Light Profile
I = SWR(it) * exp(-K.*z*SigDisFact(it));