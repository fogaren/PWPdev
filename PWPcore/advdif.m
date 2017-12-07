
if wv_up(it)
    ax = diag([0; -Cte(:,it)]) + diag(Cte(:,it),1);
else
    ax = diag([Cte(:,it); 0]) + diag(-Cte(:,it),-1);
end

An = diag(ones(nz,1))+TDKz + ax;
AnT = diag(ones(nz,1))+TDKt + ax;

Tend = T(end);
Send = S(end);
T = An*T;
S = An*S;
% T(end) = T(end);
% S(end) = S(end);
UV(:,1) = An*UV(:,1);
UV(:,2) = An*UV(:,2);

for ii = 1:ntracers
    %tr = ind2tr(ii);
    Tracer(:,ii) = AnT * Tracer(:,ii);
end




