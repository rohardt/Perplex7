function New_Cruise_table(SC,CR,pn)
% DialogNew_Cruise.mlapp provides the data of the departure and arrival,
% like position and date/time. This function creates the station and cast
% tables as used in the cruise file. It further adds the
% Default_InstrTable.mat and cruise header. The cruise file (e.g. PS130.mat
% was saved and linked with Perplex7_cfg.mat, which Perplex7.mlapp starts
% with.


% Setup for Station Table: S
sz = [2 15];
varTypes = {'double','string','logical','logical','double','datetime','double',...
            'double','double','double','double','double','double','double','string'};
varNames = {'Nr','Type','Done','Used','StatNr','DateTime','Latitude','Longitude',...
            'Depth','Speed','Dist','Delay','NoCast','Duration','Comment'};

S = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);

% compute distance:
dis = deg2nm(distance('rh',SC.Latitude(1),SC.Longitude(1),SC.Latitude(2),SC.Longitude(2)));
 
for i = 1:2
    % First column in table S is the row number
    S.Nr(i) = i;
    S.Type(i) = "WP";
    S.Done(i) = 0; % not finished
    S.Used(i) = 1; % active
    S.StatNr(i) = NaN;
    S.Latitude(i) = SC.Latitude(i);
    S.Longitude(i) = SC.Longitude(i);
    S.Depth(i) = 0; % berechnen
    S.Speed(i) = 10;
    if i==1
        S.Dist(i) = dis;
        S.DateTime(i) = datetime(SC.Date_Time(i));
    else 
        S.Dist(i) = 0;
        ttg = S.Dist(i-1)/S.Speed(i-1); % Time to go in hours
        S.DateTime(i) = datetime(SC.Date_Time(i-1)) + hours(ttg);
    end
    S.Delay(i) = 0; 
    S.NoCast(i) = NaN;
    S.Duration(i) = 0;
    S.Comment(i) = SC.Name(i);
       
    % Setup for Cast Table: CA
    sz = [1 10];
    varTypes = {'string','logical','logical','double','string','datetime',...
                'double','double','double','string'};
    varNames = {'Type','Done','Used','CastNr','Instrument','DateTime',...
                'Duration','Delay','Depth','Comment'};

    C{i} = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
    
        C{i}.Type(1) = "WP";
        C{i}.Done(1) = 0;
        C{i}.Used(1) = 1;
        C{i}.CastNr(1) = NaN;
        C{i}.Instrument(1) = "-";
        C{i}.DateTime(1) = NaT;
        C{i}.Duration(1) = NaN;
        C{i}.Delay(1) = 0;
        C{i}.Depth(1) = NaN;
        C{i}.Comment(1) = SC.Name(i);
        
end
% Cruise Header
H.DeparturePort = char(SC.Name(1));
H.DepartureDateTime = char(SC.Date_Time(1));
H.ArrivalPort = char(SC.Name(2));
H.ArrivalDateTime = char(SC.Date_Time(2));
% load default instrument table
load('Default_InstrTable.mat'); % I

% save S, C, H, and I in e.g. "CR".mat"
% pn = 'C:\bck\Matlab\Perplex7';
outfile = fullfile(pn,'Cruise',[CR '.mat']);
% outfile = fullfile(pn,[CR '.mat']);
save(outfile,'S','C','H','I');

% create Perplext_cfg.mat:CreComple%
P.CRUISE = [CR '.mat'];
% save "P" in "CR"_cfg.mat
outfile = fullfile(pn,'Cruise',[CR '_cfg.mat']);
save(outfile,'P');
outfile = fullfile(pn,'Perplex7_cfg.mat');
save(outfile,'P');
    