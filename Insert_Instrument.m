function [S,C] = Insert_Instrument(S,C,j,insertInstr)
% This function was called when inserting an instrument; see Perplex7.mlapp
% Cast tab 

           [n,~] = size(C{1,j});
            if strcmp(C{1, j}.Type(1),'WP')
                C{1, j}.Type(1) = "ST";        
                C{1, j}.Done(1) = 0;        
                C{1, j}.Used(1) = 1;        
                C{1, j}.CastNr(1) = 1;        
                C{1, j}.Instrument(1) = insertInstr;        
                C{1, j}.DateTime(1) = NaT;        
                C{1, j}.Duration(1) = NaN;        
                C{1, j}.Delay(1) = 0;        
                C{1, j}.Depth(1) = S.Depth(j);        
                C{1, j}.Comment(1) = "";
                S.Type(j) = "ST";
                S.NoCast(j) = 1;
            else 
                C{1, j}.Type(n+1) = "ST";        
                C{1, j}.Done(n+1) = 0;        
                C{1, j}.Used(n+1) = 1;        
                C{1, j}.CastNr(n+1) = n+1;        
                C{1, j}.Instrument(n+1) = insertInstr;        
                C{1, j}.DateTime(n+1) = NaT;        
                C{1, j}.Duration(n+1) = NaN;        
                C{1, j}.Delay(n+1) = 0;        
                C{1, j}.Depth(n+1) = C{1, j}.Depth(n);        
                C{1, j}.Comment(n+1) = "";
            end
