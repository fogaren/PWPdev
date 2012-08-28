outf = 'D:\work\HOE_DYLAN\Results\testrun01\';
% outf = [outf, 'Kz_', num2str(Kz*1e5)];
% outf = [outf, 'P_', num2str(EkmHeatConv), '_', ...
%     num2str(VHEC), '_', ...
%     num2str(EkmSaltConv*1e6), '_', ...
%     num2str(Kz*1e5)];
if exist(outf, 'dir') == 0
    mkdir(outf)
end

load 'D:\work\HOE_DYLAN\working\HOT_CTD_2007_2010\HOT_CTD_2007-2010.mat'

t_match = t_HOT * 0;
for i = 1:length(t_match)
    tmp = find(ta>t_HOT(i));
    t_match(i) = tmp(1);
end
t_matched = t_match(t_match>0);
[x,y] = meshgrid(ta, z);
[xi,yi] = meshgrid(t_HOT, z_HOT);
T_matched = interp2(x,y,Ta,xi,yi, 'nearest');
S_matched = interp2(x,y,Sa,xi,yi, 'nearest');
%%
figure('position', [300,50,1000,765])
% Temperature
subplot(2,2,1)
hold on
h1a=waterfall(z_HOT(1:5:end), t_HOT(1:2:end), T_matched(1:5:end,1:2:end)');
h1b=waterfall(z_HOT(1:5:end), t_HOT(1:2:end), T_HOT(1:5:end,1:2:end)');
hold off
set(h1a, 'edgecolor', 'b')
set(h1b, 'edgecolor', 'r')
legend([h1a, h1b], 'Model', 'HOT CTD','Location','NorthEast')
set(gca, 'ylim', [t_HOT(1)-1/365, t_HOT(end)+1/365]);
ylabel('Year')
xlabel('Depth (m)')
zlabel('Temperature (\circC)')
view(25,25)
subplot(2,2,2)
meshc(z_HOT, t_HOT, ...
    T_matched' - T_HOT');
set(gca, 'ylim', [t_HOT(1)-1/365, t_HOT(end)+1/365]);
ylabel('Year')
xlabel('Depth (m)')
zlabel('Temperature: Model - HOT (\circC)')
view(25,25)
% Salinity
subplot(2,2,3)
hold on
h1a=waterfall(z_HOT(1:5:end), t_HOT(1:2:end), S_matched(1:5:end,1:2:end)');
h1b=waterfall(z_HOT(1:5:end), t_HOT(1:2:end), S_HOT(1:5:end,1:2:end)');
hold off
set(h1a, 'edgecolor', 'b')
set(h1b, 'edgecolor', 'r')
legend([h1a, h1b], 'Model', 'HOT CTD','Location','NorthEast')
set(gca, 'ylim', [t_HOT(1)-1/365, t_HOT(end)+1/365]);
ylabel('Year')
xlabel('Depth (m)')
zlabel('Salinity (PSU)')
view(25,25)
subplot(2,2,4)
meshc(z_HOT, t_HOT, ...
    S_matched' - S_HOT');
set(gca, 'ylim', [t_HOT(1)-1/365, t_HOT(end)+1/365]);
ylabel('Year')
xlabel('Depth (m)')
zlabel('Salinity: Model - HOT (PSU)')
view(25,25)
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\waterfall'])
%%
Taxis = [min([T_matched(:);T_HOT(:)]), max([T_matched(:);T_HOT(:)])];
Saxis = [min([S_matched(:);S_HOT(:)]), max([S_matched(:);S_HOT(:)])];
figure('position', [50,50,1500,765])
% temperature
subplot(2,3,1)
contourf(t_HOT, z_HOT, T_matched, 30)
title('Model Temperature (\circC)')
set(gca, 'ydir', 'reverse')
ylabel('Depth (m)')
caxis(Taxis)
shading flat
colorbar
subplot(2,3,2)
contourf(t_HOT, z_HOT, T_HOT, 30)
title('HOT Temperature (\circC)')
set(gca, 'ydir', 'reverse')
ylabel('Depth (m)')
caxis(Taxis)
shading flat
colorbar
subplot(2,3,3)
contourf(t_HOT, z_HOT, T_matched - T_HOT, 30)
df = T_matched(z_HOT<=250,:) - T_HOT(z_HOT<=250,:);
title(['Temperature: Model - HOT (\circC), RMSe: ', ...
    num2str(rms(df(:)), '%6.4f')])
set(gca, 'ydir', 'reverse')
ylabel('Depth (m)')
shading flat
colorbar
% Salinity
subplot(2,3,4)
contourf(t_HOT, z_HOT, S_matched, 30)
title('Model Salinity (PSU)')
set(gca, 'ydir', 'reverse')
ylabel('Depth (m)')
caxis(Saxis)
shading flat
colorbar
subplot(2,3,5)
contourf(t_HOT, z_HOT, S_HOT, 30)
title('HOT Salinity (PSU)')
set(gca, 'ydir', 'reverse')
ylabel('Depth (m)')
caxis(Saxis)
shading flat
colorbar
subplot(2,3,6)
contourf(t_HOT, z_HOT, S_matched - S_HOT, 30)
df = S_matched(z_HOT<=250,:) - S_HOT(z_HOT<=250,:);
title(['Salinity: Model - HOT (PSU), RMSe: ', ...
    num2str(rms(df(:)), '%6.4f')])
set(gca, 'ydir', 'reverse')
ylabel('Depth (m)')
shading flat
colorbar
set(gcf,'PaperPositionMode','auto')
print('-djpeg', [outf, '\contour'])
%%
pt = [1,100,500,1000,1500,size(Ta,2)];
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
