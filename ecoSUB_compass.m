clearvars; close('all')
% 1. set paths to data and figure folder
if exist('C:\ecoSUB C3 GUI\Logs', 'dir')==7
    indir       ='C:\ecoSUB C3 GUI\Logs'; 
elseif exist('C:\Users\sa01ld\OneDrive - SAMS\Instruments\EcoSub\Logs', 'dir')==7
    indir       ='C:\Users\sa01ld\OneDrive - SAMS\Instruments\EcoSub\Logs'
else
    disp('Log file diretory not set!')
    return
end

figdir      = 'figures\'; % set outpath for figures

% 2. change testdate
testdate    ='20211020';                        % enter test date
testdate    ='20211026';                        % enter test date
% testdate    ='20210821';                        % enter test date

% 3. check IMEI
mimei        ='300434062118160' ;                % micro
uimei        ='300434063182400' ;                % milli

if exist(fullfile(indir,testdate,mimei),"dir")==7
    inst        = 'micro'
    infolder    =fullfile(indir,testdate,mimei); 
else
    inst        = 'milli'
    infolder    = fullfile(indir,testdate,uimei);   
end


state_file  = dir([infolder filesep '*1151*_ecosub_state_v2.csv']); % list relevant files
cstate_file = dir([infolder filesep '*1151*_current_state.csv']); % list relevant files

% 4. choose some quality control parameters
lat_lim     = [76 80];%
lat_lim     = [56.47 56.49];  % geographical exclusion
lon_lim     = [8 16];%
lon_lim     = [-5.46 -5.43];  % geographical exclusion
dep_lim     = -2;          % depth exclusion

for kk = 1:numel(state_file)
    % read state v2
    statev2=readtable([infolder filesep state_file(kk).name],"PreserveVariableNames",false);
    % read current state
    cstate=readtable([infolder filesep cstate_file(kk).name],"PreserveVariableNames",false);
    
    statev2.D       =statev2.Depth;    
    statev2.C       =statev2.Conductivity;
    statev2.T       =statev2.Temperature;
    statev2.Lat     =statev2.Latitude;
    statev2.Lon     =statev2.Longitude;
    
    % calculate salinity and TEOS-10 salinity, temperature, density
    statev2.SP              = gsw_SP_from_C(statev2.C,statev2.T,statev2.D);
    [statev2.SA, in_ocean]  = gsw_SA_from_SP(statev2.SP,statev2.D,statev2.Lon,statev2.Lat);
    statev2.CT              = gsw_CT_from_t(statev2.SA,statev2.T,statev2.D);
    statev2.rho             = gsw_rho(statev2.SA,statev2.CT,statev2.D);

    % extract engineering units
    Time    =statev2.Time;
    mtime   =datenum(datetime(Time, 'convertfrom','posixtime'));
    Speed   =statev2.ForwardSpeed;
    Heading =statev2.Heading;
    Pitch   =statev2.Pitch;
    Roll    =statev2.Roll;
    RPM     =statev2.RPM;
    B1volt  =statev2.Battery1Volt;
    B1crnt  =statev2.Battery1Current;
    Rangle  =statev2.RudderAngle;
    Depth   =statev2.Depth;
    MM      =statev2.MovingMassPosition;
    dr_ind      =statev2.PositionEstimation;
    lat_raw     =statev2.Latitude;
    lon_raw     =statev2.Longitude;
    % get mission name and filepath 
    mission =char(statev2.MissionName(1));
    fpath=fullfile(figdir,[char(statev2.MissionName(1)) '-' datestr(mtime(1),30)]);
    
    % seperate mission time from surface time
    headingDR=Heading(dr_ind==1);
    headingGPS=Heading(dr_ind==0);
    mmDR=MM(dr_ind==1);
    mmGPS=MM(dr_ind==0);
    ntime=[0; cumsum(diff(Time))];
    tDR=ntime(dr_ind==1);
    tGPS=ntime(dr_ind==0);
    
    figure;

    h1=plot(mmGPS,headingGPS,'k+');
    hold on
    h2=plot(mmDR,headingDR,'r+');
    
    xlabel('Moving Mass position')
    ylabel('Compass heading');
    
    legend([h2 h1],'ON MISSION','RECOVERY/BOAT');
    fname=fullfile(figdir,[char(statev2.MissionName(1)) '-' datestr(mtime(1),30) '-compass']);
    print(gcf,'-dpng',fname)


    
    figure;

    scatter(mmDR,headingDR,25,tDR,'filled')
    xlim([0 100])
    C=colorbar
    cmap=cmocean('Thermal');colormap(cmap);
    xlabel('Moving Mass position')
    ylabel('Compass heading');
    ylabel(C,'Elapsed time');    
    title('On Mission MRF Bench 0m depth');
    fname=fullfile(figdir,[char(statev2.MissionName(1)) '-' datestr(mtime(1),30) '-scatter-compass']);
    print(gcf,'-dpng',fname)
    
    % plot track
    fname=fullfile(figdir,[char(statev2.MissionName(1)) '-' datestr(mtime(1),30) '-track']);
    bathy='';
    ecoSUB_track(statev2,lat_lim,lon_lim,bathy,fname)

end