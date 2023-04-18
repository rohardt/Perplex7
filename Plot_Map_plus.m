function [mstruct,h] = Plot_Map(S,LATLIM,LONLIM)
%
%

% setting for the tick label
x=[0.025 0.05 0.25 0.5 1 2 5 10 15 30 45];
% latitude ticks
m=(abs(diff(LATLIM)))./x;
xx=x(m<=10 & m>=2);
dpll=min(xx);
pll=-90:dpll:90;
clear m xx;
%longitude ticks
m=(abs(diff(LONLIM)))./x;
xx=x(m<=10 & m>=2);
dmll=min(xx);
mll=-180:dmll:360;
if dpll<1 || dmll<1
    lunits='dm';
else
    lunits='degrees';
end

MGRID = 'on';
hold on;

% Use PType == 'lambert' if LATmax >= 86° N --> einfügen
if LATLIM(2) >= 86 % stero
    PTYPE = 'lambert';
    % LATLIM = [60 90];
    % LONLIM = [-180 180];
    % flat = round(abs(diff(LATLIM)))
    % FLATLIM = [-inf flat];
    % FLONLIM = [-180 180];
    % OYOX = [90 0 0];
    % FLAT = flat;
    % DLON = 360;
    ax = axesm('MapProjection',PTYPE,...
        'MapLatLimit',LATLIM,...
        'MapLonLimit',LONLIM,...
        'MeridianLabel'         ,'on',...
        'ParallelLabel'         ,'on',...
        'MLabelLocation'        ,mll,...
        'PLabelLocation'        ,pll,...
        'LabelFormat'           ,'signed',...
        'LabelUnits'            ,'degrees',...
        'MLineLocation'         ,dmll,...
        'PLineLocation'         ,dpll,...
        'LabelUnits'            ,lunits,...
        'MLabelParallel'        ,LATLIM(1),...
        'PLabelMeridian'        ,LONLIM(1),...
        'Grid',MGRID);

else % map settings for mercator projection
    PTYPE = 'mercator';
    ax = axesm('MapProjection',PTYPE,...
	    'MapLatLimit',LATLIM,'MapLonLimit',LONLIM,...
	    'MeridianLabel','on','ParallelLabel','on',...
	    'MLabelLocation',mll,'PLabelLocation',pll,...
	    'LabelFormat','signed','LabelUnits','degrees',...
	    'MLineLocation',dmll,'PLineLocation',dpll,...
	    'LabelUnits',lunits,'FontSize',9,...
	    'Grid',MGRID);
end

framem('FlineWidth',1,'FEdgeColor','black');

mstruct = getm(ax);

% plot the coastline (blue)
% change here if other then the ones supplied with the mapping TB should be used
load('coastlines.mat');
hc=plotm(coastlat,coastlon,'b-');
set(hc,'LineWidth',1.5);

h = nan(1,5);

% plot the ships track, for S.Used == 1 only (black)
[lat,lon] = maptriml(S.Latitude(S.Used==1),S.Longitude(S.Used==1),LATLIM,LONLIM);

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
 
 