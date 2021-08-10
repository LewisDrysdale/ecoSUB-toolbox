% profile data
figure;
ax1=subplot(1,3,1);
plot(SA,D,'k.');
axis ij;
xlabel('Absolute Salinity (g kg^(-1)'); ylabel('Depth');
grid on

ax2=subplot(1,3,2);
plot(T,D,'r.');
axis ij;
xlabel('Conservative Temperature (^o C)'); ylabel('Depth');
grid on

ax3=subplot(1,3,3);
plot(rho,D,'m.');
axis ij;
xlabel('In-situ density'); ylabel('Depth');
grid on
print(gcf, '-dpng',['figures/' char(statev2.MissionName(1))  '-' datestr(mtime(1),30) '-2dplot']);

% 3D scatter plot salinity
figure;
scatter3(Lon,Lat,D*-1,30,SP,'filled');
sgtitle(statev2.MissionName(1));
view(-30,10)
xlabel('Longitude'); ylabel('Latitude'); zlabel('Depth')
C=colorbar;
C.Label.String ='Absolute Salinity (g kg^(-1)';
cmap=cmocean('-Haline');
colormap(cmap);
print(gcf, '-dpng',['figures/' char(statev2.MissionName(1))  '-' datestr(mtime(1),30) '-salinity-3d']);

% 3D scatter plot temperature
figure;
scatter3(Lon,Lat,D*-1,30,T,'filled');
view(-30,10)
xlabel('Longitude'); ylabel('Latitude'); zlabel('Depth')
C=colorbar;
C.Label.String ='Conservative Temperature (^oC)';
cmap=cmocean('Thermal');
colormap(cmap);sgtitle(statev2.MissionName(1));

print(gcf, '-dpng',['figures/' char(statev2.MissionName(1)) '-' datestr(mtime(1),30) '-temperature-3dplot'])