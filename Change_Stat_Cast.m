function [H,S,C,msg] = Change_Stat_Cast(H,S,C,action,row,flg)
% [H,S,C,msg] = Change_Stat_Cast(H,S,C,action,row,flg)
% Author: Gerd Rohardt
% action == 'delete', 'insert', 'copy', 'order'
% row ==  for del row 3 to 6 : [3:6]
%         for insert blank row after row 3: 3
%         for cpaste line 3 to 6 and paste after row 10: [3:6,10]
%         for xpaste line 3 to 6 and paste after row 10: [3:6,10]
%         for order line 4 to 7 to flip order: [4:7]
%         see Check_selected_rows, which prepares row
% flg == 1: execute update_DateTime
%        0: do not update_DateTime
% output
% H,S,C == new tables for stations and casts
% msg == message if update is necessary
%                 

% check whether am update is required
if nargin == 4
    flg = 0;
end

if ~flg
	msg = 'Datetime must be updated';
end

% create a default Cast table
varTypes = {'string','logical','logical','double','string','datetime',...
        'double','double','double','string'};
varNames = {'Type','Done','Used','CastNr','Instrument','DateTime',...
        'Duration','Delay','Depth','Comment'};
sz = [1 10];
Ci{1} = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);


Ci{1}.Type(1) = 'WP';
Ci{1}.Done(1) = 0;
Ci{1}.Used(1) = 1;
Ci{1}.CastNr(1) = NaN;
Ci{1}.Instrument(1) = "-";
Ci{1}.DateTime(1) = NaT;
Ci{1}.Duration(1) = NaN;
Ci{1}.Delay(1) = NaN;
Ci{1}.Depth(1) = NaN;
Ci{1}.Comment(1) = "Waypoint";

% processing depending on the selected action
switch action
    case 'delete'
        % delete
        % i == zu löschende Zeile:
        i = row;
        Snew = S;
        Cnew = C;
        Snew(i,:) = [];
        Cnew = Cnew';
        Cnew(i,:) = [];
        Cnew = Cnew';
    case 'insert'
        % Zeile einfügen:
        flg = 0;
        msg = 'Datetime okay';
        i = row;
        [n,~] = size(S);
        S1 = S(i,:);
        Snew = [S(1:i,:);S1;S(i+1:n,:)];
        Snew.Type(i+1) = "WP";
        C0 = C';
%         C0 = ROWS2VARS(C);
%         C1 = C0(i,:);
        Cnew = [C0(1:i,:);Ci;C0(i+1:n,:)];
%         Cnew = ROWS2VARS(Cnew);
        Cnew = Cnew';
    case 'cpaste'
        % copy row and paste after row:
        n = size(S,1);
        m = size(row,2);
        i = row(1:m-1);
        S1 = S(i,:);
        Snew = [S(1:row(m),:);S1;S(row(m)+1:n,:)];
        C0 = C';
        C1 = C0(i,:);
        Cnew = [C0(1:row(m),:);C1;C0(row(m)+1:n,:)];
        Cnew = Cnew';
    case 'xpaste'
        % del row and paste after row:
        n = size(S,1);
        m = size(row,2);
        i = row(1:m-1);
        S1 = S(i,:);
        Snew = [S(1:row(m),:);S1;S(row(m)+1:n,:)];       
        C0 = C';
        C1 = C0(i,:);
        Cnew = [C0(1:row(m),:);C1;C0(row(m)+1:n,:)];
        if row(m) >= row(1)
            Cnew(i,:) = [];
            Cnew = Cnew';
            Snew(i,:) = [];
        else
            i = i + m - 1;
            Cnew(i,:) = [];
            Cnew = Cnew';
            Snew(i,:) = [];
        end 
    case 'order'
        % change order:
        n = size(S,1);
        m = size(row,2);
        i = row(1:m);
        S1 = flipud(S(i,:));
        Snew = [S(1:row(1)-1,:);S1;S(row(m)+1:n,:)];
        C0 = C';
        C1 = flipud(C0(i,:));
        Cnew = [C0(1:row(1)-1,:);C1;C0(row(m)+1:n,:)];
        Cnew = Cnew';      
    otherwise      
end

% save changes
clear S C;
S = Snew;
C = Cnew;
% update row-number in S:
S.Nr = (1:1:size(S,1))';
% execute update_DateTime and cruise_info:
if flg
    [H,S,C] = update_DateTime(H,S,C,I,latgrd,longrd,Zgrd);
    H = cruise_info(H,S);
    msg = 'Datetime okay';
end


    



    

