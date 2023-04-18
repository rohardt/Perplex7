function H = cruise_info_time2wp(H,S)
% H = cruise_info_time2wp(H,S)
% compute remaining time to arrive a specific waypoint or station
% Author: Gerd Rohardt
% Like computing [H.RemainTime] using datetime form the last row in 
% function "cruise_info" here the row was found by comparing two strings. 
n = find(strcmp(S.Comment,H.SelectedWP));
if ~isempty(n)
    d =  datetime(H.ArrivalDateTimeSelectedWP) - datetime(S.DateTime(n));
    hh = hours(d);
    dd = hh/24;
    DD = fix(dd);
    mm = mod(dd,DD);
    MM = round(mm*24);
    H.RemainTimeToWP = num2str([DD MM]);
else
    H.SelectedWP = '';
    H.ArrivalDateTimeSelectedWP ="";
    H.RemainTimeToWP = '';
end



