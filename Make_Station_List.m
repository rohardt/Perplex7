function [clat,clon]=Make_Station_List(lat,lon,pdist)
% 
% 

az=azimuth('rh',lat(1),lon(1),lat(2),lon(2));
sdist=deg2nm(distance('rh',lat(1),lon(1),lat(2),lon(2)));
la=lat(1);
lo=lon(1);
if (fix(sdist/pdist) > 0)
   for i=1:fix(sdist/pdist)
	   [nlat,nlon]=reckon('rh',la,lo,nm2deg(pdist),az);
	   la=nlat;
	   lo=nlon;
	   xlat(i)=nlat;
	   xlon(i)=nlon;
   end
   clat=[lat(1) xlat lat(2)];
   clon=[lon(1) xlon lon(2)];
else
   clat=lat;
   clon=lon;
end

wd = find_bdepth_gebco(latgrd,longrd,Zgrd,clat,clon);
