figure;
ax(1)=subplot(4,1,1);
colororder({'k','r'})
yyaxis left
plot(mtime,B1crnt,'k.')
ylabel('Battery 1 Current');
yyaxis right
plot(mtime,B1volt,'r-')
ylabel('Battery 1 Voltage');

ax(2)=subplot(4,1,2);
colororder({'k','r'})
yyaxis left
plot(mtime,Heading,'k.')
ylabel('Heading');
yyaxis right
plot(mtime,Rangle,'r.')
ylabel('Rudder Angle');

ax(3)=subplot(4,1,3);
plot(mtime,Pitch,'.')
ylabel('Pitch');

ax(4)=subplot(4,1,4);
colororder({'k','r'})
yyaxis left
plot(mtime,Speed,'k.')
ylabel('Forward Speed');
yyaxis right
plot(mtime,RPM,'-r');
ylabel('RPM');

for ii=1:numel(ax)
    ax(ii);
    xlabel(ax(ii),'Time');
    datetick(ax(ii),'x');
end

sgtitle(char(statev2.MissionName(1)))
         
print(gcf,'-dpng',['figures/' char(statev2.MissionName(1)) '_' datestr(mtime(1),30) '_diagnostics']);