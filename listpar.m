function listpar( mstruc, datstruc )
%
%	subroutine to list all the parameters to the screen
%
%	ipmin,ipmax,ivtic   for  display
%	ihmin,ihmax,ihtic   for display
%	baseline constant
%	type of continuum   g gaussain  p polynomial   n none  s straight line
%       p0,p1,p2  for continuum
%	number of gaussians
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	etc
%
%
%	clc
	idate = date;

	disp( sprintf( '%s   =====  MGM-Fit Parameters  ===== ', idate ) )
	disp( sprintf( '\r\r') )
%
%	now dump out the current parameters
%
%
%	baseline continuum list	
%	
	switch mstruc.contyp
	   case 'N'
		s = sprintf( ' No Continuum ' );
		disp( s )
		disp( sprintf( '\r\r') )
	   case 'P'
		s = sprintf(' Polynomial Continuum in Wavelength Space' );
		disp( s )
		disp( sprintf( '\r\r') )
	   case 'Q'
		s = sprintf(' Polynomial Continuum in Wavenumber Space' );
		disp( s )
		disp( sprintf( '\r\r') )
	   case 'G'
		disp( sprintf(' Gaussian Continuum') )
		disp( sprintf( '\r\r') )
	   case 'S'
		s = sprintf(' Straight line removed in Wavelength ');
		s = strcat( s, sprintf( '%7.1f%7.1f', ...
			 	        num2str(mstruc.swav1), '   ', ...
			 	        num2str(mstruc.swav2) ) );
		disp( s )
		disp( sprintf( '\r\r') )
	   case 'T'
		s = sprintf(' Straight line removed in Wavenumber ');
		s = strcat( s, sprintf( '%7.1f%7.1f', ...
			 	        num2str(mstruc.swav1), '   ', ...
			 	        num2str(mstruc.swav2) ) );
		disp( s )
		disp( sprintf( '\r\r') )
	   otherwise
		disp( sprintf( '\r\r') )
	end

	if (mstruc.contyp ~= 'N')
	   s = sprintf( ' P0= %14.7e  P1= %14.7e  P2= %14.7e  P3= %14.7e', ...
			mstruc.cparam );
	   disp( s )
	   disp( sprintf( '\r\r') )
	end
%
%	now list bands
%
	disp( sprintf( '%4i Absorption Bands', mstruc.nbands ) )
	disp( sprintf('\r') )
   
	for k = 1:mstruc.nbands
	   disp( sprintf( '%2i  Center= %15.8e   FWHM= %15.8e   Str= %15.8e', ...
		          k, mstruc.gcent(k), mstruc.gfwhm(k), mstruc.gstr(k) ) )
	end
%
%	write error
%
	rmscur = rmserr( datstruc.fit, datstruc.ratio );

	disp( sprintf( '\r\r') )
	disp( sprintf( ' Current RMS Error %12.6e', rmscur ) )

	input(':')
return
