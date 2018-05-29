function writegauss( wavin, ratin, file, p1, p2, p3 )

	npnts  = length( wavin );
	nbands = length( p1 );

	ext='.asc';
	filout=strcat( file, ext );

	itime = date;

	lun = fopen( filout, 'wt' );

	fprintf( lun, '%% File created: %s\n', itime );
	fprintf( lun, '%%\n');
	fprintf( lun, '%% Absorption Bands with\n');

	cform = blanks(6);
	for k=1:nbands
	    cform = strcat( cform, '%12.4f' );
	end
	cform = strcat( cform, '\n' );

	cform1 = strcat('%% Center = ', cform); 
	fprintf( lun, cform1, p1 );

	cform1 = strcat('%% FWHM   = ', cform);
	fprintf( lun, cform1, p2 );

	cform1 = strcat('%% Str    = ', cform);
	fprintf( lun, cform1, p3 );
	fprintf( lun, '%\n' );

	cform = blanks(6);
	for k=1:nbands+1
	    cform = strcat( cform, '%15.6e' );
	end
	cform = strcat( cform, '\n' );

	for k=1:npnts
	    gband = ratin(k,:);
	    fprintf( lun, cform, wavin(k), gband );
	end

	fclose( lun );
return
