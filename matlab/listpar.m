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

	 fprintf( '%s   =====  MGM-Fit Parameters  ===== \n', idate ) 
	 fprintf( '\r\r\n') 
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
		 fprintf( '\r\r\n') 
	   case 'P'
		s = sprintf(' Polynomial Continuum in Wavelength Space' );
		disp( s )
		 fprintf( '\r\r\n') 
	   case 'Q'
		s = sprintf(' Polynomial Continuum in Wavenumber Space' );
		disp( s )
		 fprintf( '\r\r\n') 
	   case 'G'
		 fprintf(' Gaussian Continuum\n') 
		 fprintf( '\r\r\n') 
	   case 'S'
		s = sprintf(' Straight line removed in Wavelength ');
		s = strcat( s, sprintf( '%7.1f%7.1f', ...
			 	        num2str(mstruc.swav1), '   ', ...
			 	        num2str(mstruc.swav2) ) );
		disp( s )
		 fprintf( '\r\r\n') 
	   case 'T'
		s = sprintf(' Straight line removed in Wavenumber ');
		s = strcat( s, sprintf( '%7.1f%7.1f', ...
			 	        num2str(mstruc.swav1), '   ', ...
			 	        num2str(mstruc.swav2) ) );
		disp( s )
		 fprintf( '\r\r\n') 
	   otherwise
		 fprintf( '\r\r\n') 
	end

	if (mstruc.contyp ~= 'N')
	   s = sprintf( ' P0= %14.7e  P1= %14.7e  P2= %14.7e  P3= %14.7e', ...
			mstruc.cparam );
	   disp( s )
	    fprintf( '\r\r\n') 
	end
%
%	now list bands
%
	 fprintf( '%4i Absorption Bands\n', mstruc.nbands )
	 fprintf('\r\n') 
   
	for k = 1:mstruc.nbands
	    fprintf( '%2i  Center= %15.8e   FWHM= %15.8e   Str= %15.8e\n', ...
		          k, mstruc.gcent(k), mstruc.gfwhm(k), mstruc.gstr(k)) 
	end
%
%	write error
%
	rmscur = rmserr( datstruc.fit, datstruc.ratio );

	 fprintf( '\r\r\n') 
	 fprintf( ' Current RMS Error %12.6e\n', rmscur ) 

	input(':')
return
