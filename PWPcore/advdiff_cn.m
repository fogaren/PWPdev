% Does one time-step of Crank-Nicolson advection-diffusion
%
% inputs:
% -------------------------
% Cn:  Vector of concentrations
% D:   Diffusion coefficient (variable with depth)
% u:   advection velocity
% dt:  time-step
% dx:  vector spacing (should be uniform)
% -------------------------
% output:  
% -------------------------
% Cn1: Vector of concentration after 1 time-step 




function [Cn1] = advdiff_cn(Cn,D,u,dt,dx,J)

sz = size(Cn);

if length(D) == 1
    D = repmat(D,sz);
end
if length(u) == 1
    u = repmat(u,sz);
end

alph = dt.*D./dx.^2;
beta = u.*dt./dx./2;


% Setup tridiagonal matrices
%
% [1-alpha/2        alpha/2+beta/4      0               .           .             ]
% [alpha/2-beta/4   1-alpha             alpha/2+beta/4  .           .             ]
% [0                alpha/2-beta/4      1-alpha         .           .             ]
% [.                0                   alpha/2-beta/4  .           .             ]
% [.                .                   .               1-alpha     alpha/2+beta/4]
% [.                .                   .               0           1             ]


An = diag(1-alph) + diag(alph(2:end)./2-beta(2:end)./2,-1) + diag(alph(1:end-1)./2-beta(1:end-1)./2,1);
An1 = diag(1+alph) + diag(-alph(2:end)./2+beta(2:end)./2,-1) + diag(-alph(1:end-1)./2+beta(1:end-1)./2,1);


% An_diag = 1-alpha./2;
% An_diagoff = alpha./2 + beta(2:end)./4;
% 
% 
% An1_diag = 1+alpha./2;
% % % calculate values for main diagonal
% % for i = 1:sz
% %     Andiag(i) = 1-dt.*nanmean([D(i),D(i+1)])./dx.^2;
% %     An1diag(i) = 1+dt.*nanmean([D(i),D(i+1)])./dx.^2;
% % end;
% % 
% % % calculate values for rows directly above and below the main diagonal
% % for i = 1:sz-1
% %     Andiag1(i) = alpha(i+1)./2+beta./4;
% %     An1diag1(i) = -alpha(i+1)./2+beta./4;
% %     Andiag0(i) = alpha(i)./2+beta./4;
% %     An1diag0(i) = -alpha(i)./2+beta./4;
% % end;
% 
% % shift positions in row directly above, 
% % so we end up with each column and row summing to 1
% Andiag0 = [Andiag0(2:end), NaN];    
% An1diag0 = [An1diag0(2:end), NaN];   
% 
% An = diag(Andiag)+diag(Andiag1,1)+diag(Andiag0,-1);
% 
% An1 = diag(An1diag)+diag(An1diag1,1)+diag(An1diag0,-1);


% Correct top and bottom boxes
% bottom = fixed boundary condition
% top has one-way diff and mix

% here, top box is not influenced by diffusion (check this implementation)
An(1,1) = 1-alph(2)./2;       % one-way diff for top box
An(end,end) = 1;            % bottom C doesn't change
An(end,end-1) = 0;          % bottom C doesn't change

An1(1,1) = 1+alph(2)./2;      % one-way diff for top box
An1(end,end) = 1;           % bottom C doesn't change
An1(end,end-1) = 0;         % bottom C doesn't change


Cn1 = An1\(An*Cn+J);