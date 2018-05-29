function datstruc = get_data( DatFile, nbands )

%	NOW READ IN DATA FILE AND WRITE OUT TEXT

datarr = load( DatFile );
sz = size( datarr );

errors='n';

if sz(2) > 2
   disp(' ')
   errors=input(' Use Errorbars (y or n) ?   ', 's');
end
if errors=='Y'| errors=='y'   
   daterror = datarr(:,3);
else
   daterror = ones( sz(1),1 );
end

ratio = log( datarr(:,2) );         		% CONVERT TO LOG REF

wavel = datarr(:,1);		    		% input data in Nanometers
waven = wltown( wavel );		    	% CONVERT TO WAVENUMBER
%
%	CREATE DATA STRUCTURE
%
npnts = length( ratio );

datstruc.ratio 	  = ratio;
datstruc.wavel 	  = wavel;
datstruc.waven 	  = waven;
datstruc.daterror = daterror;
datstruc.wvrt 	  = zeros(npnts,1);
datstruc.fit 	  = zeros(npnts,1);
datstruc.cont 	  = zeros(npnts,1);
datstruc.resid 	  = zeros(npnts,1);
datstruc.rcont 	  = zeros(npnts,1);
datstruc.remain   = zeros(npnts,1);
datstruc.gline    = zeros(npnts,1);
datstruc.gauss    = zeros(npnts,nbands);
datstruc.npnts    = npnts;

return
