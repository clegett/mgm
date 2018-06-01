function storcurv1( mstruc, datstruc )

	itime = date;

	disp( ' ')
	disp( ' ')
	fprintf('%s  ======  Reflectance Storage Routines  ======\n', itime)

	head = input('  Enter Header for Data Files: ', 's' );

%	There will be 2 files written out, one for the spectra of the individual
%	bands, and one containing the five following spectra: fit, continuum, 
%	combined absorptions, residual (spec-fit), spec-continuum.
% 
% 	File #1: Individual Bands...

	file = strcat( head,'BNDS' );
	writegauss( datstruc.wavel, ...
		    exp(datstruc.gauss), ...
		    file, ...
		    mstruc.gcent, ...
		    mstruc.gfwhm, ...
		    exp( mstruc.gstr ) );

% 	File #2: Everything else...

	npnts = datstruc.npnts;

	EXT='.asc';
	filout = strcat( head,'DATA',EXT );
	lun = fopen( filout, 'wt' );

	fprintf( lun, '%% File created: %s\n', itime );
	fprintf( lun, '%%\n');
	fprintf( lun, '%% Columns = (1) Wave, (2) Refl  (3) Fit,  (4) Continuum\n');
	fprintf( lun, '%%           (5) Cmb. Bands, (6) Resid, (7) Spec-Cont.\n');
	fprintf( lun, '%%\n');

	for k = 1:npnts
		rtemp = exp( datstruc.ratio(k) ) - exp( datstruc.fit(k) );
		fprintf( lun, '%12.6f%12.6f%12.6f%12.6f%12.6f%12.6f%12.6f\n', ...
			     datstruc.wavel(k), ...
			     exp( datstruc.ratio(k) ), ...
				 exp( datstruc.fit(k) ), ...
			     exp( datstruc.cont(k) ), ...
			     exp( datstruc.gline(k) ), ...
			     rtemp, ...
			     exp( datstruc.rcont(k) ) );

	end
	fclose( lun );
return


