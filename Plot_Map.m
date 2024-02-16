function [mstruct,h] = Plot_Map(S,GS,data,pltgebco,plteez,scifile,land,depth)
% function [mstruct,h] = Plot_Map(S,GS,data,pltgebco,plteez,scifile,land,depth)
% Plot map ship route with landareas, waypoints and stations.
% As options users can deside plotting the EEZ, Seaice Concentration or Deth Contours 

ax = worldmap(data.LATLIM,data.LONLIM);
mstruct = getm(ax);    

if ~isempty(scifile)
        % Plotting sea ice concentration; e.g. asi-AMSR2-s6250-20231201-v5.4.hdf
        % Arctic or Antarctic?
        % get path of the scifile to open LongitudeLatitudeGrid
        [scipn,scifn,~] = fileparts(scifile);
        wo = strfind(scifn,'n6250');
        if ~isempty(wo)
            % Arctic
            latlonfile =fullfile(scipn,'LongitudeLatitudeGrid-n6250-Arctic.hdf');
        else
            % Antarctic
            latlonfile =fullfile(scipn,'LongitudeLatitudeGrid-s6250-Antarctic.hdf');   
        end
        
        Info     = hdfinfo(latlonfile);
        InfoSCI     = hdfinfo(scifile);
        
        latsci   = hdfread(latlonfile,Info.SDS(2).Name);
        lonsci  = hdfread(latlonfile,Info.SDS(1).Name);
        
        sic   = hdfread(scifile,InfoSCI.SDS.Name);
        
        geoshow(ax,latsci, lonsci, sic,'DisplayType','texturemap');
end

% 
% ax = worldmap(data.LATLIM,data.LONLIM);
% mstruct = getm(ax);    

% land = readgeotable("landareas.shp");
geoshow(ax,land,"FaceColor",[0.5 0.7 0.5])


h = nan(1,7);

% skip plotting coastlines if plot plotting eez (see checkbox in Map Tab
% if ~plteez
%     % plot the coastline (blue)
%     % change here if other then the ones supplied with the mapping TB should be used
%     load('coastlines.mat');
%     h(6)=plotm(coastlat,coastlon,'b-');
%     set(h(6),'LineWidth',1.5);
% end

% plot the ships track, for S.Used == 1 only (black)
[lat,lon] = maptriml(S.Latitude(S.Used==1),S.Longitude(S.Used==1),data.LATLIM,data.LONLIM);

h(1)=plotm(lat,lon,'k-');
% h(1)=plotm(S.Latitude(S.Used==1),S.Longitude(S.Used==1),'k-');
set(h(1),'LineWidth',1);

% plot marker at way points (black)
h(2)=plotm(S.Latitude(strcmp(S.Type,'WP')& S.Used==1), ...
         S.Longitude(strcmp(S.Type,'WP')& S.Used==1));
set(h(2),'LineStyle','none','Marker','.',...
    'MarkerSize',12,...
    'MarkerEdgeColor',[0 0 0], ...
    'MarkerFaceColor',[0 0 0]);

% plot marker at stations (red)
latST = S.Latitude(strcmp(S.Type,'ST')& S.Used==1);
lonST = S.Longitude(strcmp(S.Type,'ST')& S.Used==1);
if ~isempty(latST)
    h(3) = plotm(latST, lonST);
    set(h(3),'LineStyle','none','Marker','.',...
        'MarkerSize',12,...
        'MarkerEdgeColor',[1 0 0], ...
        'MarkerFaceColor',[1 0 0]);
end
 
% plot marker at way points and stations if S.Done == 1 (green)
latDone = S.Latitude(S.Done==1);
lonDone = S.Longitude(S.Done==1);
if ~isempty(latDone)
    h(4)=plotm(latDone, lonDone);
    set(h(4),'LineStyle','none','Marker','.',...
        'MarkerSize',12,...
        'MarkerEdgeColor',[0 1 0], ...
        'MarkerFaceColor',[0 1 0]);
end

% plot marker at way points and stations if not used: S.Used == 0 (black
% star)
latUsed = S.Latitude(S.Used==0);
lonUsed = S.Longitude(S.Used==0);
if ~isempty(latUsed)
    h(5)=plotm(latUsed,lonUsed);
    set(h(5),'LineStyle','none','Marker','*',...
        'MarkerSize',6,...
        'MarkerEdgeColor',[0 0 0], ...
        'MarkerFaceColor',[0 0 0]);
end

% plot eez
if plteez
    fn_eez = 'C:\bck\Matlab\Perplex7\Dataset\eez_v11.shp';
    
    % attributes = {'S_NAME' 'C_NAME' 'TERRITORY'};
    zonelats = [];
    zonelons = [];
    eez = shaperead(fn_eez,...
        'BoundingBox', ...
        [data.LONLIM(1), data.LATLIM(1); data.LONLIM(2), data.LATLIM(2)],...
        'UseGeoCoords',true);
    
    zonelats = [zonelats  eez(1:end).Lat];   % Move All Latitudes into single row matrix
    zonelons = [zonelons  eez(1:end).Lon];   % Move all longitudes into single row matrix
    
    h(7)=plotm(zonelats,zonelons,'g-');
    set(h(7),'LineWidth',1);
end

% plot depth contour lines
% Grid of the GEBCO subregion
% GS.LAT 
% GS.LON 
% GS.Z

if pltgebco
    depth = depth.*(-1);
    contourm(GS.LAT,GS.LON,GS.Z,depth);
end
 