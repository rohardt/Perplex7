function [slat,slon] = Make_Station_LatLon(glat,glon,dx,latlon)
% function [slat,slon] = Make_Station_LatLon(glat,glon,latlon)
% glat, glon == lat/lon of section
% dx == spacing in minutes
% latlon == (1) for equal latitude spacing  
%           (0) for equal longitude spacing  

dx = dx/60;

xmod = mod(glat,dx);
latlim = glat-xmod;
latlim = sort(latlim);
latlim(2) = latlim(length(latlim));
x = latlim(1) : dx : latlim(2);

xmod = mod(glon,dx);
lonlim = glon-xmod;
lonlim = sort(lonlim);
lonlim(2) = lonlim(length(lonlim));
y = lonlim(1) : dx : lonlim(2);


if latlon
    n=2*length(x);
    lat=ones(1,n);
    lon=ones(1,n);
    i1 = 4:4:n;
    i2 = 2:4:n;
    lat(1:2:n) = x;
    lat(2:2:n) = x;
    lon(i1) = lonlim(1);
    lon(i1+1) = lonlim(1);
    lon(i2) = lonlim(2);
    lon(i2+1) = lonlim(2);
    lon= lon(1:n);
    lon(1) = lonlim(1);
    lon(n) = lonlim(2);
else
    n=2*length(y);
    lat=ones(1,n);
    lon=ones(1,n);
    i1 = 4:4:n;
    i2 = 2:4:n;
    lon(1:2:n) = y;
    lon(2:2:n) = y;
    lat(i1) = latlim(1);
    lat(i1+1) = latlim(1);
    lat(i2) = latlim(2);
    lat(i2+1) = latlim(2);
    lat= lat(1:n);
    lat(1) = latlim(1);
    lat(n) = latlim(2);
end

% [slat,slon] = polyxpoly(lat,lon, ...
%                     glat,glon, ...
%                     'unique');
[slat,slon] = polyxpoly(lat,lon, ...
                    glat,glon);
slat = slat';
slon = slon';


