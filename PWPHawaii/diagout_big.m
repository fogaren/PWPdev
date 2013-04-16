outf = 'D:\work\HOE_DYLAN\Results\testrun01\';
% outf = [outf, 'Kz_', num2str(Kz*1e5)];
% outf = [outf, 'P_', num2str(EkmHeatConv), '_', ...
%     num2str(VHEC), '_', ...
%     num2str(EkmSaltConv*1e6), '_', ...
%     num2str(Kz*1e5)];
if exist(outf, 'dir') == 0
    mkdir(outf)
end

maxz = 200;

nctr = 50; % contourf number of intervals

load 'HD_CTD.mat'

Tobs = Tobs(zobs<=maxz,:);
Sobs = Sobs(zobs<=maxz,:);
SIGt = sw_dens0(Sobs, Tobs) - 1000;
zobs = zobs(zobs<=maxz,:);

t_match = tobs * 0;
for i = 1:length(t_match)
    tmp = find(ta>tobs(i));
    t_match(i) = tmp(1);
end
t_matched = t_match(t_match>0);
[x,y] = meshgrid(ta, z);
[xi,yi] = meshgrid(tobs, zobs);
T_matched = interp2(x,y,Ta,xi,yi, 'nearest');
S_matched = interp2(x,y,Sa,xi,yi, 'nearest');
SIG_matched = sw_dens0(S_matched, T_matched) - 1000;
tdays = (tobs-floor(tobs))*366;
% %%
% figure('position', [300,50,1000,765])
% % Temperature
% subplot(2,2,1)
% hold on
% h1a=waterfall(zobs(1:5:end), tdays(1:2:end), T_matched(1:5:end,1:2:end)');
% h1b=waterfall(zobs(1:5:end), tdays(1:2:end), Tobs(1:5:end,1:2:end)');
% hold off
% set(h1a, 'edgecolor', 'b')
% set(h1b, 'edgecolor', 'r')
% legend([h1a, h1b], 'Model', 'HD CTD','Location','NorthEast')
% set(gca, 'ylim', [tdays(1)-1, tdays(end)+1]);
% ylabel('Day')
% xlabel('Depth (m)')
% zlabel('Temperature (\circC)')
% view(25,25)
% subplot(2,2,2)
% meshc(zobs, tdays, ...
%     T_matched' - Tobs');
% set(gca, 'ylim', [tdays(1)-1, tdays(end)+1]);
% ylabel('Day')
% xlabel('Depth (m)')
% zlabel('Temperature: Model - HD (\circC)')
% view(25,25)
% % Salinity
% subplot(2,2,3)
% hold on
% h1a=waterfall(zobs(1:5:end), tdays(1:2:end), S_matched(1:5:end,1:2:end)');
% h1b=waterfall(zobs(1:5:end), tdays(1:2:end), Sobs(1:5:end,1:2:end)');
% hold off
% set(h1a, 'edgecolor', 'b')
% set(h1b, 'edgecolor', 'r')
% legend([h1a, h1b], 'Model', 'HD CTD','Location','NorthEast')
% set(gca, 'ylim', [tdays(1)-1, tdays(end)+1]);
% ylabel('Day')
% xlabel('Depth (m)')
% zlabel('Salinity (PSU)')
% view(25,25)
% subplot(2,2,4)
% meshc(zobs, tdays, ...
%     S_matched' - Sobs');
% set(gca, 'ylim', [tdays(1)-1, tdays(end)+1]);
% ylabel('Day')
% xlabel('Depth (m)')
% zlabel('Salinity: Model - HD (PSU)')
% view(25,25)
% set(gcf,'PaperPositionMode','auto')
% print('-djpeg', [outf, '\waterfall'])
%%
Taxis = [min([T_matched(:);Tobs(:)]), max([T_matched(:);Tobs(:)])];
Saxis = [min([S_matched(:);Sobs(:)]), max([S_matched(:);Sobs(:)])];
SIGaxis = [min([SIG_matched(:);SIGt(:)]), max([SIG_matched(:);SIGt(:)])];
% figure('position', [50,50,1500,765])
% temperature
figure %subplot(2,3,1)
contourf(tdays, zobs, T_matched, nctr)
title('Model Temperature (\circC)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Taxis)
shading flat
colorbar
figure %subplot(2,3,2)
contourf(tdays, zobs, Tobs, nctr)
title('HD Temperature (\circC)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Taxis)
shading flat
colorbar
figure %subplot(2,3,3)
contourf(tdays, zobs, T_matched - Tobs, nctr)
df = T_matched(zobs<=250,:) - Tobs(zobs<=250,:);
title(['Temperature: Model - HD (\circC), RMSe: ', ...
    num2str(rms(df(~isnan(df(:)))), '%6.4f')])
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
shading flat
colorbar
% Salinity
figure %subplot(2,3,4)
contourf(tdays, zobs, S_matched, nctr)
title('Model Salinity (PSU)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Saxis)
shading flat
colorbar
figure %subplot(2,3,5)
contourf(tdays, zobs, Sobs, nctr)
title('HD Salinity (PSU)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Saxis)
shading flat
colorbar
figure %subplot(2,3,6)
contourf(tdays, zobs, S_matched - Sobs, nctr)
df = S_matched(zobs<=250,:) - Sobs(zobs<=250,:);
title(['Salinity: Model - HD (PSU), RMSe: ', ...
    num2str(rms(df(~isnan(df(:)))), '%6.4f')])
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
shading flat
colorbar
% set(gcf,'PaperPositionMode','auto')
% print('-djpeg', [outf, '\contour'])
% Podential Density
figure %subplot(2,3,1)
contourf(tdays, zobs, SIG_matched, nctr)
title('Model Sigma-t (kg m^-^3)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(SIGaxis)
shading flat
colorbar
figure %subplot(2,3,2)
contourf(tdays, zobs, SIGt, nctr)
title('HD Sigma-t (kg m^-^3)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(SIGaxis)
shading flat
colorbar
figure %subplot(2,3,3)
contourf(tdays, zobs, SIG_matched - SIGt, nctr)
df = T_matched(zobs<=250,:) - Tobs(zobs<=250,:);
title(['Sigma-t: Model - HD (kg m^-^3), RMSe: ', ...
    num2str(rms(df(~isnan(df(:)))), '%6.4f')])
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
shading flat
colorbar
%%
% pt = 1:floor(size(Ta,2)/5):size(Ta,2);
% lgd = {'Initial', '100 d','500 d', '1000 d','1500 d', 'Last'};
% figure('position', [300,200,1000,500])
% subplot(1,2,1)
% plot(Ta(:,pt), z)
% xlabel('Model Temperature (\circC)')
% ylabel('Depth (m)')
% set(gca, 'ydir', 'reverse')
% subplot(1,2,2)
% plot(Sa(:, pt),z)
% xlabel('Model Salinity (PSU)')
% set(gca, 'ydir', 'reverse')
% set(gcf,'PaperPositionMode','auto')
% legend(lgd, 'location', 'northwest')
% print('-djpeg', [outf, '\vertical'])
