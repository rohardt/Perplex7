function [action,row] = Check_selected_rows(action,n1,n2,n3)
% This function takes from Station tab, panel "Change List" the number 
% in Start Row, the  End Row and insertafter Row and creates the vector
% "row" 

% n1 must be less or equal n2
n = [n1 n2];
if n(1) > n(2)
    n = fliplr(n);
    n1 = n(1);
    n2 = n(2);
end
n1str = num2str(n1);
n2str = num2str(n2);
n3str = num2str(n3);

switch action
    case 'insert'
        % ignore n1 and n3
        row = str2num([n2str ':' n2str]);
    case 'delete'
        % ignore n3, if n1 = 0 set n1 = n2
        if n1 == 0
            row = str2num([n2str ':' n2str]);
        else
            row = str2num([n1str ':' n2str]);
        end
    case 'cpaste'
        % if n1 = 0 set n1 = n2
        % if n3 = 0 set n3 = n2
        if n1 == 0 && n3 == 0
            row = str2num([n2str ':' n2str ',' n2str]);
        elseif n3 == 0
            row = str2num([n1str ':' n2str ',' n2str]);
        else
            row = str2num([n1str ':' n2str ',' n3str]);
        end
    case 'xpaste'
        % if n1 = 0 set n1 = n2
        % if n3 = 0 set n3 = n2
        if n1 == 0 && n3 == 0
            row = str2num([n2str ':' n2str ',' n2str]);
        elseif n3 == 0
            row = str2num([n1str ':' n2str ',' n2str]);
        else
            row = str2num([n1str ':' n2str ',' n3str]);
        end
    case 'order'
        % ignore n3, if n1 = 0 set n1 = n2
        if n1 == 0
            row = str2num([n2str ':' n2str]);
        else
            row = str2num([n1str ':' n2str]);
        end
end
            

            
        