function print_schedule(row,S,C,pn)
% create station plan from selected row (station tab)
% row number fo the selected rows from selcted stations; e.g.
% row = [start nr :1: stop nr]

%%%MODIFIED BR 20240812
%%% correct wrong Lon values (used to take Lat values)

n = length(row);
for i = row
    if strcmp(S.Type(i),'ST') % skip WP
        % print one station list per station
        outfile = fullfile(pn,'Export',['Station-' num2str(S.StatNr(i)) '.txt']);
        fid = fopen(outfile,'w');
        % Station: 1
        fprintf(fid,'%s%d\r\n','Station: ',S.StatNr(i));
        % Latitude: 46° 11.83' N Longitude: 8° 0.22' W
        [lg1,lm1,s1]=deg2degmin(S.Latitude(i),'LAT');
        [lg2,lm2,s2]=deg2degmin(S.Longitude(i),'LON');
        fprintf(fid,'%s%d%s%5.2f%s%s\t%s%d%s%5.2f%s%s\r\n', ...
            'Latitude: ',lg1,'° ',lm1,''' ',s1,...
            'Longitude: ',lg2,'° ',lm2,''' ',s2);
        fprintf(fid,'%s%6.3f%s%s\t%s%6.3f%s%s\r\n', ...
            'Latitude: ',S.Latitude(i),'° ',s1,...
            'Longitude: ',S.Longitude(i),'° ',s2);
        % Water Depth: 4765 [m]
        fprintf(fid,'%s%d%s\r\n','Water Depth: ',S.Depth(i),' [m]');
        % Way to go (next Waypoint or Station): 22 [nm]
        %fprintf(fid,'%s%d%s\r\n',...
        fprintf(fid,'%s%d%s\r\n',...
            'Way to go (next Waypoint or Station): ',round(S.Dist(i)),' [nm]');
        %
        % Loop for each Cast:
        [n,~] = size(C{1,i});
        % Print header line
        % Cast Instrument DateTime Duration ProfileDepth Comment
        fprintf(fid,'%s\t%10s\t\t%s\t%s\t%s\t\t%s\t\r\n', ...
            'Cast','Instrument','DateTime      ','Duration (h)','ProfileDepth (m)', ...
            'User/Comment');
        for j = 1:n
            if C{1,i}.Used(j) %true == active
                tdate = datestr(C{1,i}.DateTime(j)); tdate = tdate(1:17);
                fprintf(fid,'(%d)\t %16s\t %s\t %5.2f\t %d\t %s\r\n',...
                    C{1,i}.CastNr(j), ...
                    C{1,i}.Instrument(j), ...
                        tdate, ...
                    C{1,i}.Duration(j), ...
                    C{1,i}.Depth(j), ...
                    C{1,i}.Comment(j));
            end
        end
    end
end
fclose all;