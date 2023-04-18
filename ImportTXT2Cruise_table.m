function [S,C] = ImportTXT2Cruise_table(S,C,nr)
% This function was called from menu [In-Out - Import from txt-file]; see Perplex7.mlapp
% e.g. way points from Bremerhaven to Cape Town:
%   54.0304	   7.6479
%   53.4575	   4.5802
%   52.8962	   3.9666
%   51.9709	   2.7395
% Format latitude <TAB> longitude, no header line


% Import latitude and longitude from text file
[fn,pnx] = uigetfile('C:\*.txt','Import Latitude, Longitude');
infi = fullfile(pnx,fn);
% infi = 'C:\PERPLEX-V5\Sections\Bremerhaven-Las Palmas-Cape Town.txt';
fid = fopen(infi,'r');
T = textscan(fid,'%f%f',-1);

SC.Latitude = cell2mat(T(1));
SC.Longitude = cell2mat(T(2));

% Setup for Station Table: SI

n = size(SC.Latitude,1);
sz = [n 15];
varTypes = {'double','string','logical','logical','double','datetime','double',...
            'double','double','double','double','double','double','double','string'};
varNames = {'Nr','Type','Done','Used','StatNr','DateTime','Latitude','Longitude',...
            'Depth','Speed','Dist','Delay','NoCast','Duration','Comment'};

SI = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
 
for i = 1:n
    % First column in table S is the row number
    SI.Nr(i) = i;
    SI.Type(i) = "WP";
    SI.Done(i) = 0; % not finished
    SI.Used(i) = 1; % active
    SI.StatNr(i) = NaN;
    SI.DateTime(i) = NaT;
    SI.Latitude(i) = SC.Latitude(i);
    SI.Longitude(i) = SC.Longitude(i);
    SI.Depth(i) = 0; % berechnen
    SI.Speed(i) = 10;
    SI.Dist(i) = 0; % berechnen!!! 
    SI.Delay(i) = 0; 
    SI.NoCast(i) = NaN;
    SI.Duration(i) = 0;
    SI.Comment(i) = '';
    
    
    % Setup for Cast Table: CA
    sz = [1 10];
    varTypes = {'string','logical','logical','double','string','datetime',...
                'double','double','double','string'};
    varNames = {'Type','Done','Used','CastNr','Instrument','DateTime',...
                'Duration','Delay','Depth','Comment'};

    CI{i} = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
    
        CI{i}.Type(1) = "WP";
        CI{i}.Done(1) = 0;
        CI{i}.Used(1) = 1;
        CI{i}.CastNr(1) = NaN;
        CI{i}.Instrument(1) = "-";
        CI{i}.DateTime(1) = NaT;
        CI{i}.Duration(1) = NaN;
        CI{i}.Delay(1) = 0;
        CI{i}.Depth(1) = NaN;
        CI{i}.Comment(1) = '';
        
end
% S, C are read from the STATION- and CAST table
i = nr;
[n,~] = size(S);
Snew = [S(1:i,:);SI;S(i+1:n,:)];
Snew.Type(i+1) = "WP";
C0 = C';
C2 = CI';
Cnew = [C0(1:i,:);C2;C0(i+1:n,:)];
Cnew = Cnew';

clear S C;

S = Snew;
C = Cnew;
% update row-number in S:
S.Nr = (1:1:size(S,1))';
% execute update_DateTime
% [H,S,C] = update_DateTime(H,S,C,I,pn);
% disp('end');


    