function GS = GRIDONE_2D_subset(G,data)
% INPUT
% G :== structure variable is the global elivation grid (1 Minute
% resolution) 
% G.Z         21601x10801            1866499208  double              
% G.lat       10801x1                     86408  double              
% G.lon       21601x1                    172808  double
%
% data :== structure variable of the region
% data.LATLIM :== [Min Max]
% data.LONLIM :== [Min Max]
%
% OUTPUT
% GS :== structure variable is elivation grid of the region bounded by
% LATLIM and LONLIM. The Resolution is [1 5 10 15 30 60 120 180 360]
% minutes that GS.Z is <= 1.0E+06 grid points
% GS.LAT
% GS.LON
% GS.Z

% Get the Gebco Grid from the region given by the latitude- and longitude
% limits.

lat = G.latgrd(G.latgrd>=data.LATLIM(1) & G.latgrd<=data.LATLIM(2));
lon = G.longrd(G.longrd>=data.LONLIM(1) & G.longrd<=data.LONLIM(2));

Z = G.Zgrd(G.longrd>=data.LONLIM(1) & G.longrd<=data.LONLIM(2),G.latgrd>=data.LATLIM(1) & G.latgrd<=data.LATLIM(2));

% The global elivation grid are more then 230E+06 datapoints which is to
% much for plotting the depth contour lines.
% Resolution of 1 minute was changed that the number of points is max.
% 1.0E+06.


n = length(lat)*length(lon);
r = [1 5 10 15 30 60 120 180 360] ; % Resolution can be 1, 5, 10 ... or 360 minutes

q = n./(r.*r);
wo = find(q<=1.0e+06);
res= r(wo(1));

y = 1:res:length(lat);
x = 1:res:length(lon);

GS.LAT = lat(y);
GS.LON = lon(x);
Z0 = Z(x,y);
GS.Z = Z0';
