function liststat(mstruc)
%
%	subroutine to list locked/unlocked status of all the parameters
%	to the screen
%
%	ipmin,ipmax,ivtic   for  display
%	ihmin,ihmax,ihtic   for display
%	baseline constant
%	type of continuum   g gaussian  p polynomial   n none  s straight line
%       p0,p1,p2  for continuum
%	number of bands
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	etc
%
%	clc
	idate = date;

	 fprintf( '%s     =====  Parameter Status  =====\n', idate ) 
%
%	now dump out the current parameters
%
%	now list bands
%
	 fprintf( '\r\r\n' ) 
	 fprintf( '                             Absorption Bands\n' ) 
	 fprintf( '\r\n' ) 
	disp( '    #            Center         FWHM            Strength' )
	 fprintf( '\r\n' ) 

	x      = 1:3*mstruc.nbands;
	pdx    = reshape( x, mstruc.nbands, 3 );
	setpar = cell( mstruc.nbands,3 );
	setpar(:,:) = {'Unlocked'};
 
	for k = 1:mstruc.nbands

	   ndx = find( mstruc.ipstat( pdx(k,:),1 ) );
	   setpar(k,ndx) = {' Locked '};

	   tmp = char( setpar(k,:) );
	   value = strcat( sprintf( '%s\t', tmp(1,:) ), ...
			   sprintf( '%s\t', tmp(2,:) ), ...
			   sprintf( '%s\t', tmp(3,:) ) );

	   disp( [sprintf('  %3i + ', k), '        ', value] );

	end
	 fprintf('\r\r\n') 
%
%	write error
%
	if mstruc.contyp ~= 'N'

	   setpar = cell( 4 ); 
	   setpar(:,:) = {'Unlocked'};
	   ndx = find( mstruc.ipstat( mstruc.nparam-3:mstruc.nparam,1 ) );
	   setpar( ndx ) = {' Locked '};

	   s = strcat( 'Continuum Parameters', ...
		       '          C0', ...
		       '           C1', ...
		       '              C2', ...
		       '              C3' );
	   disp( s )
	    fprintf( '\r\n' ) 

	   tmp = char( setpar );
	   value = strcat( sprintf( '%s\t', tmp(1,:) ), ...
			   sprintf( '%s\t', tmp(2,:) ), ...
			   sprintf( '%s\t', tmp(3,:) ), ...
			   sprintf( '%s\t', tmp(4,:) ) );

	   disp( [blanks(27), value] )

	end

	input(':')
return
