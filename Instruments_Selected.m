function [INSTR] = Instruments_Selected(I)
% This function takes all activated instruments from Instruments tab, see
% Perplex7.mlapp and add these in die Cast tab.

sz = [1 1];
varTypes = {'string'};
varNames = {'Instrument'};
            
INSTR = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
INSTR.Instrument(1) = "DUMMY";

I = sortrows(I,'Used','descend');

[n,~] = size(I);
j = 0;
for i = 1:n
    if I.Used(i)
        j = j + 1;
        INSTR.Instrument(j) = I.Instrument(i);
    else
        break;
    end
end
INSTR = sortrows(INSTR,'Instrument','ascend');

 