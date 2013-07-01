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

tcrt = 0.5; % criterion used in mask_nd function, to limit interpolation in 
            % contour plot of observations 
            
Tobs = Tobs(zobs<=maxz,:);
Sobs = Sobs(zobs<=maxz,:);
SIGobs = sw_dens0(Sobs, Tobs) - 1000;
zobs = zobs(zobs<=maxz,:);

tidx = find(ta>=tobs(1)&ta<=tobs(end)); % time range with measurements
tdays = (ta - floor(ta)) * 366;
zidx = find(z<=maxz);


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
tdays_obs = (tobs-floor(tobs))*366;
if rst_ON_OFF == 3
    tdays_sg = (tsg - floor(tsg))*366;
end
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
SIGaxis = [min([SIG_matched(:);SIGobs(:)]), max([SIG_matched(:);SIGobs(:)])];
% figure('position', [50,50,1500,765])
%% temperature
h=figure; %subplot(2,3,1)
contourf(tdays(tidx), z(zidx), Ta(zidx, tidx), nctr)
title('Model Temperature (\circC)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Taxis)
shading flat
colorbar
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\T_mdl'])
delete(h)

h=figure; %subplot(2,3,2)
[y2, t2] = mask_nd(Tobs, tdays_obs, tcrt);
contourf(t2, zobs, y2, nctr)
title('HD Temperature (\circC)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Taxis)
shading flat
colorbar
if rst_ON_OFF == 3
    yaxis = get(gca, 'yaxis');
    ysg = zeros(size(tdays_sg)) + mean(yaxis);
    hold on
    plot(tdays_sg, ysg, 'k.')
    hold off
end
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\T_obs'])
delete(h)

h=figure; %subplot(2,3,3)
T_cmp = T_matched - Tobs;
% [y2, t2] = mask_nd(T_cmp, tdays_obs, tcrt);
% contourf(t2, zobs, y2, nctr)
contourf(tdays_obs, zobs, T_cmp, nctr)
df = T_matched(zobs<=maxz,:) - Tobs(zobs<=maxz,:);
title(['Temperature: Model - HD (\circC), RMSe: ', ...
    num2str(rms(df(~isnan(df(:)))), '%6.4f')])
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
shading flat
caxismin = prctile([T_cmp(:);-T_cmp(:)], 1);
caxis([caxismin, -caxismin]);
colormap(redblue)
colorbar
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\T_cmp'])
delete(h)
%% Salinity
h=figure; %subplot(2,3,4)
contourf(tdays(tidx), z(zidx), Sa(zidx, tidx), nctr)
title('Model Salinity (PSU)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Saxis)
shading flat
colorbar
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\S_mdl'])
delete(h)

h=figure; %subplot(2,3,5)
[y2, t2] = mask_nd(Sobs, tdays_obs, tcrt);
contourf(t2, zobs, y2, nctr)
title('HD Salinity (PSU)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Saxis)
shading flat
colorbar
if rst_ON_OFF == 3
    yaxis = get(gca, 'yaxis');
    ysg = zeros(size(tdays_sg)) + mean(yaxis);
    hold on
    plot(tdays_sg, ysg, 'k.')
    hold off
end
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\S_obs'])
delete(h)

h=figure; %subplot(2,3,6)
S_cmp = S_matched - Sobs;
% [y2, t2] = mask_nd(S_cmp, tdays_obs, tcrt);
% contourf(t2, zobs, y2, nctr)
contourf(tdays_obs, zobs, S_cmp, nctr)
df = S_matched(zobs<=maxz,:) - Sobs(zobs<=maxz,:);
title(['Salinity: Model - HD (PSU), RMSe: ', ...
    num2str(rms(df(~isnan(df(:)))), '%6.4f')])
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
shading flat
caxismin = prctile([S_cmp(:);-S_cmp(:)], 1);
caxis([caxismin, -caxismin]);
colormap(redblue)
colorbar
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\S_cmp'])
delete(h)
%% Podential Density
h=figure; %subplot(2,3,1)
contourf(tdays(tidx), z(zidx), Siga(zidx, tidx)-1000, nctr)
title('Model Sigma-t (kg m^-^3)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(SIGaxis)
shading flat
colorbar
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\Sig_mdl'])
delete(h)

h=figure; %subplot(2,3,2)
[y2, t2] = mask_nd(SIGobs, tdays_obs, tcrt);
contourf(t2, zobs, y2, nctr)
title('HD Sigma-t (kg m^-^3)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(SIGaxis)
shading flat
colorbar
if rst_ON_OFF == 3
    yaxis = get(gca, 'yaxis');
    ysg = zeros(size(tdays_sg)) + mean(yaxis);
    hold on
    plot(tdays_sg, ysg, 'k.')
    hold off
end
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\Sig_obs'])
delete(h)

h=figure; %subplot(2,3,3)
SIG_cmp = SIG_matched - SIGobs;
% [y2, t2] = mask_nd(SIG_cmp, tdays_obs, tcrt);
% contourf(t2, zobs, y2, nctr)
contourf(tdays_obs, zobs, SIG_cmp, nctr)
df = SIG_matched(zobs<=maxz,:) - SIGobs(zobs<=maxz,:);
title(['Sigma-t: Model - HD (kg m^-^3), RMSe: ', ...
    num2str(rms(df(~isnan(df(:)))), '%6.4f')])
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
shading flat
caxismin = prctile([SIG_cmp(:);-SIG_cmp(:)], 1);
caxis([caxismin, -caxismin]);
colormap(redblue)
colorbar
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\Sig_cmp'])
delete(h)
%% plot model light
h=figure;
Iap = max(Ia, 1e-6);
contourf(tdays(tidx),z(zidx),log10(Iap(zidx,tidx)),nctr)
shading flat
set(gca, 'ydir', 'reverse')
colorbar
caxis([-1,2.5])
title('Log10 Modeled Short Wave Radiation')
xlabel('Day')
ylabel('Model Coordinate Depth (m)')
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\I_mdl'])
delete(h)