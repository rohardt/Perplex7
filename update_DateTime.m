function [H,S,C] = update_DateTime(H,Sin,Cin,I,latgrd,longrd,Zgrd)
% [H,S,C] = update_DateTime(H,Sin,Cin,I,latgrd,longrd)
% old: [H,S,C] = update_DateTime(H,Sin,Cin,I,pn)
% Author: Gerd Rohardt
% function to be used for Perplex7.mlapp
% After any modification of the Station-, Cast- and Instrument table it
% updates H (the cruise details) S (the station table) and C (the cast
% table. Sin, Cin are the input of S and C;
% latgrd, longrd, Zgrd where loaded in Perplex7.mlapp startupfcn from
% GRINDONE.mat.
%
% old: pn :== path from gridone.grd; the netcdf file with 1-minute resolution
% topography.
%
%   C{i} cell of tables with columns: Type     Done     Used     CastNr    
%   Instrument    DateTime    Duration     Delay      Depth      Comment  
%           
%   S table with columns: Type    Done     Used     StatNr      DateTime
%   Latitude   Longitude  Depth  Speed  Dist    Delay    NoCast    Duration
%
% H ==: cruise details 
%   struct with fields:
%                 DeparturePort: 'Bremerhaven(gm)'
%             DepartureDateTime: '12-Jan-2023 12:00:00'
%                   ArrivalPort: 'Cape Town(sf)'
%               ArrivalDateTime: '24-Feb-2023 12:00:00'
%            StartStationNumber: 1
%                     TotalTime: '43   0'
%                     WorkAtSea: '29  17'
%                         Route: 6756
%                      TimeTOgo: '29   1'
%                  AvgShipSpeed: 9.6981
%                    RemainTime: '13   7'
%                    SelectedWP: "EndofWork"
%     ArrivalDateTimeSelectedWP: "20-Feb-2023 06:00:00"
%                RemainTimeToWP: '11   8'

% (1) normally station number counts starting with 1, but sometimes it was
% continued for all legs of a cruise. In this enter the start number in 
% "Cruise TAB".
if ~isfield(H,'StartStationNumber')
    nr = 0;
    H.StartStationNumber = 1;
else
    nr = H.StartStationNumber - 1;
end

% check Sin.Done is == 1 from Nr == 1 to the last indicted S.Done == 1
X = Sin(Sin.Done == 1,:);
if ~isempty(X)
    nrmax = max(X.Nr,[],'omitnan');
    Sin.Done(1:nrmax) = 1;
end


% (2) Remove rows; see "Station TAB" Done==1 (to indicate waypoints or
% stations which were done.
% Copy table Sin and Cin where Sin.Done==1 and
% copy table Cin(Sin.) and store in SX and CX and 
% keep Sin.Done==0
S = Sin(Sin.Done==0,:);
% check rows indicated as done
SX = Sin(Sin.Done==1,:);
if ~isempty(SX)
    % save max station number from SX
    nr = max(SX.StatNr,[],'omitnan');
    if isnan(nr)
        nr = 0;
    end
    % get last row of SX
    [nx,~] = size(SX);
    SX = SX(nx,:); % add last row which was indicated as processed
    % put last row of SX on top of S. Normally the calculation of datetime
    % and distance starts from the port of departure (row = 1 of S). I rows
    % were indicated as done, SX was used similar as the port of departure.
    S = vertcat(SX,S);
end

% (3) Skip rows Used==0
% Copy table S where S.Used==1 
% Waypoints and/or stations can be activated (Used = 1; default) or deactivated
% (Used = 0); just to check how it may change the cruise plan. 
S = S(S.Used==1,:);
C = Cin(S.Nr);

S.Depth = round((find_bdepth_gebco(latgrd,longrd,Zgrd,S.Latitude,S.Longitude).*-1),0);


% (4) Processing remaining rows of station table and cast,  see (Done=0, Used=1)
% number of rows in S
% setup for the loop 
[n,~] = size(S);
lat1 = S.Latitude(1);
lon1 = S.Longitude(1);
dt = S.DateTime(1);

for i = 2:n % weil mit n-1 der letzte record nicht bearbeitet wird
    % compute distance 
    lat2 = S.Latitude(i);
    lon2 = S.Longitude(i);
    dis = deg2nm(distance('rh',lat1,lon1,lat2,lon2));
    % save dist (nautical miles) in previous row:
    S.Dist(i-1) = round(dis,2);
    
    % save depth befor update, this will be used in CastDuration
    zold = S.Depth(i);
%     S.Depth(i) = (find_bdepth_gebco(pn,lat2,lon2)).*-1;
%     S.Depth(i) = (find_bdepth_gebco(latgrd,longrd,Zgrd,lat2,lon2)).*-1;

    % shift lat2/lon2 to lat1/lon1 for next row in S
    lat1 = lat2;
    lon1 = lon2;
     
    % compute datetime arriving at next waypoint
    % (a) time to go in hours, Dist in nautical miles, Speed in knots
    ttg = S.Dist(i-1)/S.Speed(i-1);

    % (b) add S.Delay (hours) which is also stored in the previour row
    % e.g. when manually change the datetime arriving at a waypoint or
    % station, a delay was stored in row before this point.
    delay = S.Delay(i-1);
   
    % (c) stationtime of the previous station; see function below. C
    % contains the cast data for each waypoint, Chours is the total time to
    % do all cast, ncast are the total number of cast at this station
    
    [C,Chours,ncast] = CastDuration(I,i,C,S,zold);
    
    % (d) finally add ttg, delay and S.Duration(i-1) to dt, which ist taken from 
    % the previous row (i-1); see dt.
    if isnan(S.Duration(i-1))
        duration = 0;
    else
        duration = S.Duration(i-1);
    end 

    S.DateTime(i) = datetime(dt + hours(ttg + delay + duration));

    % save datetime in cast and save S.DateTime(i) in dt
    C{1,i}.DateTime(1) = S.DateTime(i);
    dt = S.DateTime(i);

    % update Type 
    if ncast == 0
        S.Type(i) = 'WP';
    else
        S.Type(i) = 'ST';
    end            
    % Update 
    if strcmp(S.Type(i),'ST')
        nr = nr + 1;
        S.StatNr(i) = nr;
        S.Duration(i) = Chours;
        S.NoCast(i) = ncast;
    else
        S.StatNr(i) = NaN;
        S.Duration(i) = NaN;
        S.NoCast(i) = NaN;
    end            
end

% replace the new processed rows Sin and Cin 
row = S.Nr';
Sin(row,:) = S(1:n,:);
Cin(row) = C((1:n));
clear S C;
S = Sin;
C = Cin;

% insert dummy in none used rows:
k = find(S.Used == 0);
for i = 1:length(k)
    j = k(i);
    S.DateTime(j) = NaT;
    S.Dist(j) = NaN;
    S.Delay(j) = 0;
end

% Update cruise information diplayed in TAB: Cruise
H = cruise_info(H,S);

%% Sub routine to calculate the time e.g. to do a CTD-cast
function [C,Chours,ncast] = CastDuration(I,Cid,C,S,zold)
% I is the table containing the parameters for the instruments
% Cid = i;
% C (cell) containing the cast tables
% ncast is the number of instrumens deployed at i;
% Chours is the total duration (in h) needed complete the station.

ncast = 0;
n = size(C{Cid},1); % number of cast (incl. the de-active ones)
tsum = zeros(1,n);
dsum = zeros(1,n);
for ii = 1:n
    t = zeros(1,5);
    if C{1,Cid}.Used(ii) && strcmp(C{1,Cid}.Type(ii),'ST')
        % if cast is active (and not a waypoint
        ncast = ncast + 1;
        % keep depth (profil depth) unchanged if depth in cast is < zold
        z = C{1,Cid}.Depth(ii);
        if z < zold % this is the case if profile depth was e.g. 500m and water depth = 4500 m
            if z > S.Depth(Cid) 
                C{1,Cid}.Depth(ii) = S.Depth(Cid);
            else
                C{1,Cid}.Depth(ii) = z;
            end
        else
            C{1,Cid}.Depth(ii) = S.Depth(Cid);            
        end
        z = C{1,Cid}.Depth(ii); % save z to calculate duration for down and up        
        C{1,Cid}.CastNr(ii) = ncast; % CastNr
        such = C{1,Cid}.Instrument(ii);
        for jj = 1:size(I,1)
            if strcmp(I.Instrument(jj),such)
                break;
            end
        end
        if I.Fixed(jj)>0
            t(1) = I.Fixed(jj); % hours
            t(2) = 0;
            t(3) = 0;
            t(4) = 0;
            t(5) = 0;
        else
            t(1) = 0;
            t(2) = I.Handling(jj)/60; % minutes to hours
            t(3) = z/I.Down(jj)/3600; % t = s/v in seconds and sec. in hours
            t(4) = I.Trawling(jj)/60; % minutes to hours
            t(5) = z/I.Up(jj)/3600; % t = s/v in seconds and sec. in hours
        end
        t(t==Inf) = NaN;
        tsum(ii) = sum(t,'omitnan'); % duration for cast in hours
        % delays:
        dsum(ii)= C{1,Cid}.Delay(ii); % delay for cast in hours
        % store Duration:
        C{1,Cid}.Duration(ii) = tsum(ii);
        % for cast > 1 add C{n}.Datetime(i-1) plus tsum
%         if ii < size(C{Cid},1)
        if ncast == 1
            C{1,Cid}.DateTime(ii) = S.DateTime(Cid);
            ilast = ii;
        else
%             dt = datenum(C{1,Cid}.DateTime(ilast)); % in decimal days           
            dt = C{1,Cid}.DateTime(ilast);           
%             DDduration = datenum(0,0,0,tsum(ilast),0,0); % hours from tsum in decimal days
%             DDdelay = datenum(0,0,0,dsum(ilast),0,0); % hours from Delay in decimal days            
            C{1,Cid}.DateTime(ii) = datetime(dt + hours(tsum(ilast) + dsum(ilast)));
            ilast = ii;
        end
        % insert name in Comment
        C{1,Cid}.Comment(ii) = I.User(jj);
    else
        % if cast not active (and/or a waypoint)
        C{1,Cid}.CastNr(ii) = NaN;
        C{1,Cid}.DateTime(ii) = NaT;
        tsum(ii) = 0;
        dsum(ii) = 0;
    end
end
% duration of all cast together in hours converted in decimal days
Chours = sum(tsum) + sum(dsum);
clear tsum dsum;
    



    

