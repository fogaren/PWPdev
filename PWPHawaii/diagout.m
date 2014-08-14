outf = 'D:\work\HOE_DYLAN\Results\testrun01\';
% outf = [outf, 'Kz_', num2str(Kz*1e5)];
% outf = [outf, 'P_', num2str(EkmHeatConv), '_', ...
%     num2str(VHEC), '_', ...
%     num2str(EkmSaltConv*1e6), '_', ...
%     num2str(Kz*1e5)];
if exist(outf, 'dir') == 0
    mkdir(outf)
end

maxz = 250;

Tobs = Tobs(zobs<=maxz,:);
Sobs = Sobs(zobs<=maxz,:);
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
tdays = (tobs-floor(tobs))*366;
%%
figure('position', [300,50,1000,765])
% Temperature
subplot(2,2,1)
hold on
h1a=waterfall(zobs(1:5:end), tdays(1:2:end), T_matched(1:5:end,1:2:end)');
h1b=waterfall(zobs(1:5:end), tdays(1:2:end), Tobs(1:5:end,1:2:end)');
hold off
set(h1a, 'edgecolor', 'b')
set(h1b, 'edgecolor', 'r')
legend([h1a, h1b], 'Model', 'HD CTD','Location','NorthEast')
set(gca, 'ylim', [tdays(1)-1, tdays(end)+1]);
ylabel('Day')
xlabel('Depth (m)')
zlabel('Temperature (\circC)')
view(25,25)
subplot(2,2,2)
meshc(zobs, tdays, ...
    T_matched' - Tobs');
set(gca, 'ylim', [tdays(1)-1, tdays(end)+1]);
ylabel('Day')
xlabel('Depth (m)')
zlabel('Temperature: Model - HD (\circC)')
view(25,25)
% Salinity
subplot(2,2,3)
hold on
h1a=waterfall(zobs(1:5:end), tdays(1:2:end), S_matched(1:5:end,1:2:end)');
h1b=waterfall(zobs(1:5:end), tdays(1:2:end), Sobs(1:5:end,1:2:end)');
hold off
set(h1a, 'edgecolor', 'b')
set(h1b, 'edgecolor', 'r')
legend([h1a, h1b], 'Model', 'HD CTD','Location','NorthEast')
set(gca, 'ylim', [tdays(1)-1, tdays(end)+1]);
ylabel('Day')
xlabel('Depth (m)')
zlabel('Salinity (PSU)')
view(25,25)
subplot(2,2,4)
meshc(zobs, tdays, ...
    S_matched' - Sobs');
set(gca, 'ylim', [tdays(1)-1, tdays(end)+1]);
ylabel('Day')
xlabel('Depth (m)')
zlabel('Salinity: Model - HD (PSU)')
view(25,25)
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\waterfall'])
%%
Taxis = [min([T_matched(:);Tobs(:)]), max([T_matched(:);Tobs(:)])];
Saxis = [min([S_matched(:);Sobs(:)]), max([S_matched(:);Sobs(:)])];
figure('position', [50,50,1500,765])
% temperature
subplot(2,3,1)
contourf(tdays, zobs, T_matched, 30)
title('Model Temperature (\circC)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Taxis)
shading flat
colorbar
subplot(2,3,2)
contourf(tdays, zobs, Tobs, 30)
title('HD Temperature (\circC)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Taxis)
shading flat
colorbar
subplot(2,3,3)
contourf(tdays, zobs, T_matched - Tobs, 30)
df = T_matched(zobs<=250,:) - Tobs(zobs<=250,:);
title(['Temperature: Model - HD (\circC), RMSe: ', ...
    num2str(rms(df(~isnan(df(:)))), '%6.4f')])
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
shading flat
colorbar
% Salinity
subplot(2,3,4)
contourf(tdays, zobs, S_matched, 30)
title('Model Salinity (PSU)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Saxis)
shading flat
colorbar
subplot(2,3,5)
contourf(tdays, zobs, Sobs, 30)
title('HD Salinity (PSU)')
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
caxis(Saxis)
shading flat
colorbar
subplot(2,3,6)
contourf(tdays, zobs, S_matched - Sobs, 30)
df = S_matched(zobs<=250,:) - Sobs(zobs<=250,:);
title(['Salinity: Model - HD (PSU), RMSe: ', ...
    num2str(rms(df(~isnan(df(:)))), '%6.4f')])
set(gca, 'ydir', 'reverse')
xlabel('Day')
ylabel('Depth (m)')
shading flat
colorbar
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\contour'])
%%
pt = 1:floor(size(Ta,2)/5):size(Ta,2);
lgd = {'Initial', '100 d','500 d', '1000 d','1500 d', 'Last'};
figure('position', [300,200,1000,500])
subplot(1,2,1)
plot(Ta(:,pt), z)
xlabel('Model Temperature (\circC)')
ylabel('Depth (m)')
set(gca, 'ydir', 'reverse')
subplot(1,2,2)
plot(Sa(:, pt),z)
xlabel('Model Salinity (PSU)')
set(gca, 'ydir', 'reverse')
set(gcf,'PaperPositionMode','auto')
legend(lgd, 'location', 'northwest')
print('-djpeg', [outf, '\vertical'])
