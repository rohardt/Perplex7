function MFP_CoordinatesExportCSV
% Convert cruise plan made with Marine Facilities Planning (MFP) 
% Coordinates of waypoints/station can be exported from the MFP-plan into a
% csv-file.
% This script converts the exported csv-file that it can be inported into
% Perplex7; see manual:"Import a cruise plan created with Marine Facilities
% Planning into Perplex7.pdf"
% Gerd Rohardt
% March 2025

% Example of MFP export:
% WPT No.,LAT,,,LON,,,
% 1,54,27.19,N,007,45.28,E
% 2,54,33.97,N,008,07.52,E

% create output file:
[fn,pn] = uiputfile("*.txt","Open Outputfile for MFP-Waypoints");
outfile = fullfile(pn,fn);
fidout= fopen(outfile,'w');
% select and open the MFP export:
[fn,pn] = uigetfile("*.csv","Open File MFP_CoordinatesExport");
infile = fullfile(pn,fn);

fid = fopen(infile,'r');
fgetl(fid); % skip header line of export file

% convert latitude and longitude into dezimal degrees, using the function 
% "degminNE2deg"

while ~feof(fid)
    C = textscan(fid,'%s%s%s%s%s%s%s',1,'Delimiter',',');
    latD = char(C{2});
    latM = char(C{3});
    ns = char(C{4});
    lonD = char(C{5});
    lonM = char(C{6});
    ew = char(C{7});
    lstr = [latD,' ',latM,' ','ns'];
    LAT=degminNE2deg(lstr);
    lstr = [lonD,' ',lonM,' ','ew'];
    LON=degminNE2deg(lstr);
    if ~isnan(LAT)
        fprintf(fidout,'%f\t%f\r\n',LAT,LON);
    end
end
fclose(fid);
fclose(fidout);
end

function ldg=degminNE2deg(lstr)
    %

    % remove blanks with function "mydeblank"
    lstr=mydeblank(lstr,1);
    wo=findstr(lstr,' ');
    if length(wo) ~= 2
        % disp(['can not convert this format: ' lstr]);
        ldg=NaN;
        return
    end
    
    lg=str2num(lstr(1:wo(1)-1));
    lm=str2num(lstr(wo(1)+1:wo(2)-1));
    ne=lstr(wo(2)+1:length(lstr));
    
    if ne=='S' | ne=='s' | ne=='W' | ne=='w'
        lg=-lg;
    end
    
    if lg<0, lm=abs(lm)*(-1); end,
    ldg=lg + lm/60;
    ldg=(round(ldg*10000))/10000;
end

function newline=mydeblank(line,schalter)
    %
    % Enfernt fuehrende und folgende Blanks in dem String line
    %
    % Gebrauch: newline=mydeblank('   TEST    TEST  ')
    % bzw.      newline=mydeblank('   TEST    TEST  ',schalter) 
    %
    % Ausgabe waere line = 'TEST    TEST'
    %
    % Wenn schalter gesetzt wird (beliebiger Wert) werden zudem
    % alle mehrfachen Leerzeichen im Satz enfernt.
    %
    % Ausgabe waere line = 'TEST TEST'
    %
    % HR 27.02.2001
    
    line=char(line);
    
    if (nargin == 0)
     help mydeblank
     return;
    end
    
    if ~isstr(line)
     help mydeblank
     return;
    end
    
    
    newline=fliplr(deblank(fliplr(deblank(line))));
    
    if (nargin > 1)
     line=newline;
     clear newline;
     j=2;
    
     newline(1)=line(1);
         for i=2:length(line)
           if ((~strcmp(newline(j-1),' ') & ~strcmp(line(i),' ')) | ...
               ( strcmp(newline(j-1),' ') & ~strcmp(line(i),' ')) | ...
               (~strcmp(newline(j-1),' ') &  strcmp(line(i),' ')))
             newline(j)=line(i);
             j=j+1; 
           end
         end
    end
end
