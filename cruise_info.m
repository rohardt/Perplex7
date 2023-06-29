function H = cruise_info(H,S)
% H = cruise_info(H,S)
% Compute cruise details, displayed in TAB Cruise; see Perplex7.mlapp
% Author: Gerd Rohardt

% (1) Total Time between departure and arrival in day and hours
d = datetime(H.ArrivalDateTime) - datetime(H.DepartureDateTime);
hh = hours(d);
dd = hh/24;
DD = fix(dd);
mm = mod(dd,DD);
MM = round(mm*24);
H.TotalTime = num2str([DD MM]);

% (2) Work at Sea; Station work, time for steaming and delays
% (a) Steaming:
tshipH = sum(S.Dist./S.Speed,'omitnan'); % hours
% (b) Delays (a delay results if DateTime was manually changed):
tdelay = sum(S.Delay,'omitnan'); % hours
% (c) Time needed to do a station (duration in hours):
tstation = sum(S.Duration,'omitnan'); % hours
% work at sea, add up a, b, c:
twork = sum([tshipH tdelay, tstation],'omitnan');
twork = twork/24; % days
tD = fix(twork);
tH = round(mod(twork,tD)*24);
H.WorkAtSea = num2str([tD tH]); % in days and hours
% (3) Total route in nautical miles
route = sum(S.Dist,'omitnan'); % nautical miles
H.Route = round(route);
% (4) Time to go: days hours
tship = tshipH/24; % days
tD = fix(tship);
tH = round(mod(tship,tD)*24);
H.TimeTOgo = num2str([tD tH]); % in days and hours
% (5) Avaerage Ship Speed: knots
vel = route/tshipH; % nautical miles/hours
if isnan(vel)
    vel = S.Speed(1);
end
H.AvgShipSpeed = vel; % avg. speed in knots
% (6) Remaining Time to Port:
% H.ArrivalDateTime, given in TAB cruise, is the committed time of arrival
% but in the station table, TAB Station, the datetime in the last row (port
% of arrival) was calculated based an the real conditions (ship speed,
% number of stations and so on.
[n,~] = size(S); % n = number of the last row
d =  datetime(H.ArrivalDateTime) - datetime(S.DateTime(n)); % time difference
hh = hours(d);
dd = hh/24;
DD = fix(dd);
mm = mod(dd,DD);
MM = round(mm*24);
H.RemainTime = num2str([DD MM]); % remaining time in days and hours
% (7) Compute Remaining Time to WP
% (a) new cruise enter:
% H.SelectedWP = ''(empty string),
% H.ArrivalDateTimeSelectedWP ="" (empty string),
% H.RemainTimeToWP = '' (empty string)
if ~isfield(H,'SelectedWP') % (a)
    H.SelectedWP = '';
    H.ArrivalDateTimeSelectedWP ="";
    H.RemainTimeToWP = '';
else
    % (b) H.SelectedWP exist but is empty:
    if isempty(H.SelectedWP)
        H.SelectedWP = '';
        H.ArrivalDateTimeSelectedWP ="";
        H.RemainTimeToWP = '';
    else % (c) compute remaining time to WP
        % check if a WP 
        H = cruise_info_time2wp(H,S);
    end
end



