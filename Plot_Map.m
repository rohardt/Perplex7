function [mstruct,h] = Plot_Map(S,LATLIM,LONLIM,latcenter,loncenter,radius)
%
%

% If latmax < 86 map projection is "mercator" otherwise "stereo"
if LATLIM < 86 
    % map settings for mercator:
    PTYPE = 'mercator';
    MGRID = 'on';
    
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
    ax = axesm('MapProjection',PTYPE,...
	    'MapLatLimit',LATLIM,'MapLonLimit',LONLIM,...
	    'MeridianLabel','on','ParallelLabel','on',...
	    'MLabelLocation',mll,'PLabelLocation',pll,...
	    'LabelFormat','signed','LabelUnits','degrees',...
	    'MLineLocation',dmll,'PLineLocation',dpll,...
	    'LabelUnits',lunits,'FontSize',9,...
        'FontSize', 8 ,...
	    'Grid',MGRID);
    framem('FlineWidth',1,'FEdgeColor','black');
    mstruct = getm(ax);
else
    % map settings for "stereo"
    % compute center of all locations
    if isnan(latcenter)
        [latm,lonm] = meanm(S.Latitude,S.Longitude);
        OY = round(latm,-1);
        if lonm < 100
            OX = round(lonm,0);
        else
            OX = round(lonm,-1);
        end
        % latmin to OY == FLAT
        FLAT = round((latm - LATLIM(1)),0).*2;
    else

        % zoom stereo map
        OY = round(latcenter,-1);
        if loncenter < 100
            OX = round(loncenter,0);
        else
            OX = round(loncenter,-1);
        end
        FLAT = round(radius,-1);
        LATLIM = [OY-FLAT OY+FLAT];
        LONLIM = [-180 180];
        if LATLIM(2) > 2
            LATLIM(2) = 90;
        end        
    end
    PTYPE = 'stereo';
    MGRID = 'on';
    FLATLIM = [-inf FLAT];
    FLONLIM = [-180 180];
    OYOX = [OY OX OX];

    DLON = 360;
    
    x = [0.025 0.05 0.25 0.5 1 2 5 10 15 30 45];
    m = 2.*FLAT ./ x;
    xx=x(m<=10 & m>=2);
    dpll=min(xx);
    pll=-90:dpll:90;
    clear m xx;
    m=DLON./x;
    xx=x(m<=10 & m>=2);
    dmll=min(xx);
    mll=-180:dmll:360;
    
    if dpll<1 || dmll<1
        lunits='dm';
    else
        lunits='degrees';
    end
    ax = axesm('MapProjection',PTYPE,...
        'FLatLimit'             ,FLATLIM,...
        'FLonLimit'             ,FLONLIM,...
        'MeridianLabel'         ,'on',...
        'ParallelLabel'         ,'on',...
        'Origin'                ,OYOX,...
    'MLabelLocation'        ,mll,...
    'PLabelLocation'        ,pll,...
    'LabelFormat'           ,'signed',...
    'LabelUnits'            ,'degrees',...
    'MLineLocation'         ,dmll,...
    'PLineLocation'         ,dpll,...
    'LabelUnits'            ,lunits,...
    'ParallelLabel'         ,'on',...
    'MLabelParallel'        ,OY,...
    'PLabelMeridian'        ,OX,...
    'FontSize', 8 ,...
    'Grid',MGRID);
    mstruct = getm(ax);    
    % framem('FlineWidth',1,'FEdgeColor','black');
end

hold on;
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
 
 