function [C] = ShiftUpDown(dir,C,i,j)
% This function change the order of the casts: see Perplex7.mlapp; Cast
% tab; button [shift cast up] and [shift cast down]
% dir == direction, 1 == shift cast up to top
%                   0 == shift cast down to bottom
n = size(C{1,i},1);
if dir % up
    if j(1) > 1
        A = C{1,i};
        B = A(j(1)-1,:);
        A(j(1)-1,:) = A(j(1),:);
        A(j(1),:) = B;
        C{1,i} = A;
    end
else % down
    if j(1) < n
        A = C{1,i};
        B = A(j(1)+1,:);
        A(j(1)+1,:) = A(j(1),:);
        A(j(1),:) = B;
        C{1,i} = A;
    end
end
    
