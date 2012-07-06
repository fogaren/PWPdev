%
%	mlmix -	mixes up the mixed layer
%
	T(1:mld)=mean(T(1:mld));
	S(1:mld)=mean(S(1:mld));
	Sig(1:mld)=mean(Sig(1:mld));
	UVm=mean(UV(1:mld,:),1); 
		UV(1:mld,1)=UVm(1)*ones(mld,1);
		UV(1:mld,2)=UVm(2)*ones(mld,1);
%
%	comment out below if not using gases
%
	for igas=1:ngas
        gas = gases{igas};
	    Trmean=mean(Tracer(1:mld,tr2ind(gas)));
	    Tracer(1:mld,tr2ind(gas))=Trmean*ones(mld,1);
	end


