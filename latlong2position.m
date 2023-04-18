function position_str = latlong2position(lat,lon)
% Convert lat/lon in to be displayed in Cast tab (EditField "Position")

% convert decimal degrees for latitude
[lg,lm,s] = deg2degmin(lat,'LAT');
LATstr = [num2str(lg) '° ' num2str(roundn(lm,-2)) ''' ' s];

% convert decimal degrees for longitude
[lg,lm,s] = deg2degmin(lon,'LON');
LONstr = [num2str(lg) '° ' num2str(roundn(lm,-2)) ''' ' s];

position_str = [LATstr '   ' LONstr];