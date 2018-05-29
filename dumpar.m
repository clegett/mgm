function dumpar( mstruc, datstruc )
%
%	subroutine to list all the parameters to FOR004.dat
%
%	ipmin,ipmax,ivtic   for  display
%	ihmin,ihmax,ihtic   for display
%	baseline constant
%	type of continuum   g gaussians  p polynomial   n none  s straight line
%       p0,p1,p2  for continuum
%	number of bands
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	etc
%
%
	outfile1 = 'for004.dat';
	lun = fopen( outfile1, 'wt' );

	idate = date;
	itime=datestr(now,16);
	fprintf( lun, '%s   =====  MGM-Fit Parameters  =====   ', idate);
        fprintf( lun,'%s\n\n',itime );
%
%	now dump out the current parameters
%
%
%	baseline continuum list	
%	
	switch mstruc.contyp
	   case 'N'
		fprintf( lun, ' No Continuum \n\n' );
	   case 'P'
		fprintf( lun, ' Polynomial Continuum in Wavelength Space\n\n' );
	   case 'Q'
		fprintf(lun, ' Polynomial Continuum in Wavenumber Space\n\n' );
	   case 'G'
		fprintf( lun, ' Gaussian Continuum\n\n' );
	   case 'S'
		fprintf(lun,' Straight line removed in Wavelength');
		fprintf(lun, '%7.1f%9.1f\n\n', ...
			 	        num2str(mstruc.swav1), ...
			 	        num2str(mstruc.swav2)  );
	   case 'T'
		fprintf(lun,' Straight line removed in Wavenumber');
		fprintf(lun , '%7.1f%9.1f\n\n', ...
			 	        num2str(mstruc.swav1), ...
			 	        num2str(mstruc.swav2)  );
	   otherwise
		fprintf( lun, '\n\n' );
	end
	if (mstruc.contyp ~= 'N')
%         fprintf(lun, ' P0= %14.7e  P1= %14.7e  P2= %14.7e  P3= %14.7e', ...
          fprintf(lun, '   %14.7e   %14.7e   %14.7e   %14.7e', ...
                        mstruc.cparam );
	  fprintf(lun,'\n\n');
        end
%
%	now list bands
%
	fprintf( lun, '                    %4i  Absorption Bands\n', ...
               mstruc.nbands );
 
	OFORM = sprintf( '  #        Center             FWHM' );
	OFORM2 = sprintf('          Strength          Log Area\n' );
	OFORM = strcat( OFORM, OFORM2 );
  
	fprintf( lun, OFORM );

	gsum = sum( datstruc.gauss, 1 );

	for k=1:mstruc.nbands
	    fprintf( lun, '%3i   %15.8e   %15.8e   %15.8e   %15.8e\n', ...
		     k, mstruc.gcent(k), mstruc.gfwhm(k), ...
		     mstruc.gstr(k), gsum(k) );
	end
%
%	write error
%
	rmscur = rmserr( datstruc.fit, datstruc.ratio );

	fprintf( lun, '\n %12.6e = Current RMS Error', rmscur );

	rmscur = sqrt( ( rmscur^2 )*datstruc.npnts / ...
		       ( datstruc.npnts-(mstruc.nparam-4) ) );

	fclose(lun);	% closing file FOR004.dat %
% 	
%	write out for009 with 2 sigma range of parameters
%
        outfile2 = 'for009.dat';
        lun2 = fopen( outfile2, 'wt' );
	fprintf(lun2, '     MGM_Ver 2 --- 2 Sigma (95 perc. confidence)');
	fprintf(lun2,' Model Parameters\n\n');
%
%          baseline continuum list
%
        inparam = mstruc.nparam;

        ndx = find( mstruc.cparam == 0 );
        ncnt = length( ndx );
        inparam = inparam - ncnt;
          if ( mstruc.contyp ~= 'N' )
                ndx = find( mstruc.cparam );
                ncpar = length( ndx );
                clow  = mstruc.cparam(ndx) -mstruc.std(inparam-ncpar+1:inparam);
                chigh = mstruc.cparam(ndx)+mstruc.std(inparam-ncpar+1:inparam);
 
                for k=1:ncpar
                    fprintf( lun2, '  %12.2e < P%i <%12.2e\n', ...
                                clow(k), k, chigh(k) );
                end
                uncert = mstruc.std( inparam-ncpar+1:inparam );
                if ncpar < 4
                   uncert = [uncert, zeros( 4-ncpar,1 )];
                end
           end
  	fprintf( lun2, '\n%2i Absorption Bands\n', mstruc.nbands );

        fprintf( lun2, '\n');

%          now list bands...

        wconst= 2.354820;
        uncert = mstruc.std(1:mstruc.nbands);
        temp=ones(1,mstruc.nbands)';
        cntmax=temp./(temp./mstruc.gcent-uncert*1E-7);
        cntmin=temp./(temp./mstruc.gcent+uncert*1E-7);
        gform = '%3i%10.3f <c<%10.3f  %10.3f <w<%10.3f %10.3f <s<%10.3f\n';
          for k=1:mstruc.nbands
               fprintf(lun2, ...
                       gform, ...
                       k, ...
                       cntmin(k), ...
                       cntmax(k), ...
                       (mstruc.gfwhm(k)-mstruc.std(mstruc.nbands+k)), ...
                       (mstruc.std(mstruc.nbands+k)+mstruc.gfwhm(k)), ...
                       (mstruc.gstr(k)-mstruc.std(2*mstruc.nbands+k)), ...
                       (mstruc.std(2*mstruc.nbands+k)+mstruc.gstr(k)) );
          end
  	fclose( lun2 );

return
