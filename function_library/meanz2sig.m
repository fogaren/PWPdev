function [sig, zsig, sigtbl, ztbl] = meanz2sig(Siga, Z, zs)
% calculate sigma value with average depth of zs 
% Siga is full sigma values with each column represents one profile at a
% time at depth profile Z
nz = size(Siga, 1);
nt = size(Siga, 2);
if ~isvector(Z)
    error('Z must be a vector!')
end
if nz~=length(Z)
    error('Number of rows of Siga must equal length of Z!')
end
sig = zeros(size(zs));
zsig = sig;
zs = zs(:);

sigmin = nanmin(Siga(:));
sigmax = nanmax(Siga(:));
sigs = (sigmin:0.001:sigmax)';

zz = zeros(length(sigs), nt);
for it = 1:nt
    Y = Siga(:,it);
    [Y, ~, I] = unique(Y, 'rows');
    ZZ = accumarray(I, Z, [], @mean);
    zz(:,it) = interp1(Y, ZZ, sigs);    
end
zz = mean(zz,2);

ztbl = zz(~isnan(zz));
sigtbl = sigs(~isnan(zz));

for iz = 1:length(zs)
    [~, idx] = min(abs(ztbl - zs(iz)));
    sig(iz) = sigtbl(idx);
    zsig(iz) = ztbl(idx);
end

% sig1 = zeros(length(zs), nt);
% for it = 1:nt
%     sig1(:,it) = interp1(Z, Siga(:,it), zs);
% end
% sig1 = mean(sig1, 2);
% 
% z1 = zeros(length(zs), nt);
% for it = 1:nt
%     Y = Siga(:,it);
%     [Y, ~, I] = unique(Y, 'rows');
%     ZZ = accumarray(I, Z, [], @mean);
%     z1(:,it) = interp1(Y, ZZ, sig1);
% end
% z1 = nanmean(z1, 2);

