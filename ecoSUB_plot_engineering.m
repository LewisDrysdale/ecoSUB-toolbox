figure;
ax(1)=subplot(4,1,1);
colororder({'k','r'})
yyaxis left
plot(mtime,B1crnt,'k.','LineWidth',1.5)
ylabel('Battery 1 Current');
yyaxis right
plot(mtime,B1volt,'r-','LineWidth',1.5)
ylabel('Battery 1 Voltage');

ax(2)=subplot(4,1,2);
colororder({'k','r'})
yyaxis left
plot(mtime,Heading,'k.','LineWidth',1.5)
ylabel('Heading');
yyaxis right
plot(mtime,Rangle,'r.','LineWidth',1.5)
ylabel('Rudder Angle');

ax(3)=subplot(4,1,3);
colororder({'k','r'})
yyaxis left
plot(mtime,Depth,'k.','LineWidth',1.5)
ylabel('Depth (m)');
yyaxis right
plot(mtime,Pitch,'r-','LineWidth',1.5);
ylabel('Pitch');

ax(4)=subplot(4,1,4);
colororder({'k','r'})
yyaxis left
plot(mtime,Speed,'k.','LineWidth',1.5)
ylabel('Forward Speed');
yyaxis right
plot(mtime,RPM,'-r','LineWidth',1.5);
ylabel('RPM');

width=20; height=30; FS=14; FN='Helvetica';

for ii=1:numel(ax)
    ax(ii);
    xlabel(ax(ii),'Time');
    datetick(ax(ii),'x');
    set(ax(ii),'fontsize', FS, 'FontName',FN);

end

sgtitle(char(statev2.MissionName(1)))

set(gcf,'units','centimeters','position',[1 1 width height])

print(gcf,'-dpng',['figures/' char(statev2.MissionName(1)) '_' datestr(mtime(1),30) '_diagnostics']);