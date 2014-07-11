%
%	doStIns - do static instability adjustment
%
%		this routine relies on the fact that density increases
%		are always forced from the top (there is no in situ
%		cooling mechanism) so any instability will result in a
%		downward deepening from the top. The algorithm starts
%		every time with a mixed layer depth of 1 cell and goes
%		downward until static stability is achieved
%
%Sig=Sigref+Alpha*(T-Tref)+Beta*(S-Sref);	% compute density profile
Sig = sw_dens0(S,T);
mld=1;				% start with shoalest mixed layer
for i=1:nz-1				% static stability adjustment
    if Sig(i) > Sig(i+1)	% if unstable mix density of mixed layer
        mld=i+1;
%         mlmix;
        Sig(1:mld)=mean(Sig(1:mld)); 		% just mix density at first
        nstin=nstin+1;
    else
        mlmix;
        break;
    end
end

