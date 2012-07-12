function y = mld_sig(Sig)
% calculate mixed layer depth using potential density criterion:
% offset to surface <= 0.125
% y = 1;
% while Sig(y+1) - Sig(1) < 0.125
%     y = y+1;
% end
% y = y + 1;
y = NaN;
tmp = find((Sig-Sig(1))>=0.125);
if ~isempty(tmp)
    y = tmp(1); 
end