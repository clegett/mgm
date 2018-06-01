function storcurv2( mstruc, datstruc )
%
%	Store stuff in log base e
%
	itime = date;

	disp( ' ')
	disp( ' ')
	fprintf('%s  ======  Log Base e Storage Routines  ======\n', itime)

	head = input('  Enter Header for Data Files: ', 's' );

%	There will be 2 files written out, one for the spectra of the individual
%	bands, and one containing the five following spectra: fit, continuum, 
%	combined absorptions, residual (spec-fit), spec-continuum.
% 
% 	File #1: Individual Bands...

	file = strcat( head,'LBNDS' );
	writegauss( datstruc.wavel, ...
		    datstruc.gauss, ...
		    file, ...
		    mstruc.gcent, ...
		    mstruc.gfwhm, ...
		    mstruc.gstr );

% 	File #2: Everything else...

	npnts = datstruc.npnts;

	EXT='.asc';
	filout = strcat( head,'LDATA',EXT );
	lun = fopen( filout, 'wt' );

	fprintf( lun, '%% File created: %s\n', itime );
	fprintf( lun, '%%\n');
	fprintf( lun, '%%                 *** Log Base e Format ****\n' );
	fprintf( lun, '%% Columns = (1) Wave, (2) Log Refl  (3) Fit,  (4) Continuum\n');
	fprintf( lun, '%%           (5) Cmb. Bands, (6) Resid, (7) Spec-Cont.\n');
	fprintf( lun, '%%\n');

	for k = 1:npnts
		rtemp = datstruc.ratio(k) - datstruc.fit(k);
		fprintf( lun, '%12.6f%12.6f%12.6f%12.6f%12.6f%12.6f%12.6f\n', ...
			     datstruc.wavel(k), ...
				 datstruc.ratio(k), ...
			     datstruc.fit(k), ...
			     datstruc.cont(k), ...
			     datstruc.gline(k), ...
			     rtemp, ...
			     datstruc.rcont(k) );

	end
	fclose( lun );
return


