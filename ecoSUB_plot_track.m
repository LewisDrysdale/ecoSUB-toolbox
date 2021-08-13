% load bathy
ncfile='bathy/GEBCO_ardmucknish_bay.nc';
finfo=ncinfo(ncfile);
lat=ncread(ncfile,'lat');
lon=ncread(ncfile,'lon');
lev=ncread(ncfile,'elevation');
lev=lev'; % imvert eleveation

figure;

m_proj('lambert','lon',lon_lim,'lat',lat_lim);
[c,h]=m_contourf(lon,lat,lev,100,'linecolor', 'none');
colorbar;
cmap=cmocean('Deep');
colormap(cmap);
hold on   
good_pos=[Lon_raw(dr==1) Lat_raw(dr==1)];
bad_pos =[Lon_raw(dr==0)  Lat_raw(dr==0)];
[X,Y]=m_ll2xy(bad_pos(:,1),bad_pos(:,2));
hold on
plot(X,Y,'w.','MarkerSize',2); 
m_gshhs_f('patch',[0.95 0.95 0.95]); 
m_grid('linewidth',0.75,'linest','none','tickdir','out','fontsize',14,...
    'FontName','Arial');
set(findobj('tag','m_grid_color'),'facecolor','w'); 
