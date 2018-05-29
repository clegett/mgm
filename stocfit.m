function [mstruc,datstruc] = stocfit( mstruc, datstruc, isampres, itimes ) 
%
%	subroutine to CALCULATE BEST FIT
%          using stochastic non-linear inverse
%          Tarantola & Vallete (1982) Reviews in Geophysics

warning off
%lun = fopen( 'for003.dat', 'wt' );

ITR=0;
wconst = mstruc.wconst;
%
%	Create an index array into data array based on fit frequency
%
ddx = 1:isampres:datstruc.npnts;
keepgoing = 1;

while keepgoing == 1

	FACTI=1.0;
%
%	SAVE OLDPAR
%
	OLDPAR = mstruc.params;
%
%	COMPUTE BEST FIT FOR SINGLE BAND
%
	inparam = mstruc.nparam;

	ndx = find( mstruc.cparam == 0 );
	ncnt = length( ndx );
	inparam = inparam - ncnt;
%
%	BUILD THE PARTIAL DERIVAIVE MATRIX
%
%	NPARUS = number of parameters used in fit (i.e., all UNLOCKED params)
%
	ppp    = find( mstruc.ipstat(1:inparam,1) == 0 );
	NPARUS = length( ppp );
	G      = zeros( length(ddx), NPARUS );

	for k=1:NPARUS

	   ipart1 = mstruc.ipstat(ppp(k),2);    % SECOND COLUMN CONTAINS DERIVATIVES
%
%	   FIND OUT WHAT KIND OF DERIVATIVE WE NEED
%
	   switch ipart1
%
%	   COMPUTE ALL THE PARTIALS 
%
	   case 4				% LINEAR OF POLYNOMIAL
		G(:,k) = 1.0 ./ exp( datstruc.cont(ddx) );
	   case 5				% X TERM OF POLYNOMIAL
		if (mstruc.contyp == 'Q') || ...
		   (mstruc.contyp == 'T')
			value = datstruc.waven(ddx);
		elseif (mstruc.contyp == 'P') || ...
		       (mstruc.contyp == 'S')
			value = datstruc.wavel(ddx);
		else
			value = datstruc.waven(ddx);
		end
		G(:,k) = value ./ exp( datstruc.cont(ddx) );
	   case 6				% X SQUARED TERM OF POLYNOMIAL
		if (mstruc.contyp == 'Q') || ...
		   (mstruc.contyp == 'T')
			value = datstruc.waven(ddx);
		elseif (mstruc.contyp == 'P') || ...
		       (mstruc.contyp == 'S')
			value = datstruc.wavel(ddx);
		else
			value = datstruc.waven(ddx);
		end
		G(:,k) = (value .* value ) ./ exp( datstruc.cont(ddx) );
	   case 7				% X CUBED TERM OF POLYNOMIAL
		if (mstruc.contyp == 'Q') || ...
		   (mstruc.contyp == 'T')
			value = datstruc.waven(ddx); 
		elseif (mstruc.contyp == 'P') || ...
		       (mstruc.contyp == 'S')
			value = datstruc.wavel(ddx);
		else
			value = datstruc.waven(ddx);
		end
		G(:,k) = (value .* value .* value) ./ exp( datstruc.cont(ddx) );
	    otherwise				% Gaussian parameters
%
%	  	IS A BAND WHICH BAND ?
%
%		Set up an array to identify which band we're working on...
%
		pdx = zeros( mstruc.nbands,3 );
		for b = 1:mstruc.nbands
		    pdx( b,:) = b;
		end

		in1 = pdx( ppp(k) );

	  	TINV = datstruc.gauss( ddx,in1 );
	  	G(:,k) = pgauss( mstruc.roots.cnrt(in1), ...
				   mstruc.gwidth(in1), ...
				   mstruc.gstr(in1), ...
				   datstruc.wvrt(ddx), ...
				   ipart1 );

	  	G(:,k) = G(:,k) .* TINV;
	   end	% switch/case statement %
	end	% for loop %
%
%	calculate inv(covariance matrix) for model parameters
%
	cmminv = diag ( 1.0 ./ ( mstruc.cmm(ppp)/1.96 ).^2 ); % var=(error @95% 
							        % conf/1.96)^2		
	if any(datstruc.daterror~=1)
  	  cnnvarinv= 1./(datstruc.daterror(ddx)/mean(datstruc.daterror(ddx)));
	else
	  cnnvarinv=datstruc.daterror;
	end
	cnninv = cnnvarinv(:,ones(NPARUS,1));
	gtgmminv = inv(G'*(cnninv.*G) + cmminv );

%	calculate new model params gtgmminv * mtemp2

	MCHS = gtgmminv *((G' * (cnnvarinv.*datstruc.resid(ddx)))- ...
 		(cmminv*(OLDPAR(ppp) - mstruc.PARAM0(ppp))));
%
%	FORM NEW SOLUTIONS
%
% 	get current err
%
	rmsold = rmserr( datstruc.fit(ddx),datstruc.ratio(ddx) );   
%
%	IF PARAMETER IS UNLOCKED ADD ON CORRECTION
%
	mstruc.params(ppp) = OLDPAR(ppp) + MCHS;
%
%	NOW MOVE PARAMS BACK TO ORIGINAL ARRAYS
%
	mstruc = unshuffl( mstruc );
	[mstruc, datstruc] = fillup( mstruc, datstruc );     % recalulate curve

	rmsnew = rmserr(datstruc.fit(ddx),datstruc.ratio(ddx));  %get new error
%
%	see if calculation was an improvement
%
%       [mstruc,datstruc,keepgoing,ITR] = error_check(lun , ...
	[mstruc,datstruc,keepgoing,ITR] = error_check( mstruc, ...
					  	   datstruc, ...
				 	  	   rmsold, ...
				 	  	   rmsnew, ...
						   itimes,ITR,FACTI,OLDPAR,...
						   MCHS,ddx,ppp);
	end 	% while statement %
	mstruc = spit_it_out( mstruc, rmsnew, ppp, inparam, G );
%       fclose(lun);
	input(':')
return


%function [mstruc,datstruc,keepgoing,ITR] = error_check ( lun, ...
function [mstruc,datstruc,keepgoing,ITR] = error_check ( mstruc, ...
						datstruc, ...
						rmsold, ...
						rmsnew, ...
						itimes,ITR,FACTI,OLDPAR,...
						MCHS,ddx,ppp)

% 	CHECK TO SEE IF WE HAVE A WINNER

	failure = 1./(2.0^15);           % BACKOFF FAILURE POINT
	keepgoing = 1;
	itry=0;   			 % number of times backoff applied

	while (rmsnew >= rmsold)	 % worse off
%
%	    if new params are worse apply interpolation factor
%
	    itry = itry + 1;
	    s = sprintf( ' Applying Binary Backoff to Correction  %4i', itry );
	    disp( s )
 
	    FACTI = FACTI/2.0;    	 % compute interpolation factor

	    if (FACTI < failure)  	 % INTERPOLATION FAILS
%
%	    	RESTORE OLDPAR
%
	    	mstruc.params = OLDPAR;
	    	mstruc = unshuffl( mstruc );
	    	[mstruc, datstruc] = fillup( mstruc, datstruc );

	    	disp( '  Interpolation by Binary Backoff Fails !!' )
	    	keepgoing = 0;
		return
	    else 			% recalulate
	    	mstruc.params(ppp) = OLDPAR(ppp) + ( FACTI .* MCHS );  

	    	mstruc = unshuffl( mstruc );
	    	[mstruc, datstruc] = fillup( mstruc, datstruc );

	        rmsnew = rmserr( datstruc.fit(ddx), datstruc.ratio(ddx) );
	    end
	end	% while statement %

% 	fprintf( lun, '\n' );
%	fprintf( lun, '\n' );
	%fprintf( lun, '  %17.8e%17.8e%17.8e%17.8e\n', mstruc.cparam );
	%fprintf( lun, ' %2i\n', mstruc.nbands );

%	for k = 1:mstruc.nbands
	%    	fprintf( lun,  '  %17.8e%17.8e%17.8e\n', ...
		%	 mstruc.gcent(k), ...
			% mstruc.gfwhm(k), ...
			 %mstruc.gstr(k) );
%	end

	ITR = ITR+1;
	rmsimp = rmsold - rmsnew;
%	fprintf( lun,  ...
%		     '    Old RMS%14.6e   New RMS=%14.6e   Imp=%14.6e\n', ...
	%	     rmsold, ...
		%     rmsnew, ...
	%    rmsimp );

	s = sprintf( '%5i   Old RMS%14.6e   New RMS=%14.6e   Imp=%14.6e', ...
		     ITR, ...
		     rmsold, ...
		     rmsnew, ...
           	     rmsimp );
%	clc
%	disp( ' ' )
        disp( s )
%
%	    check for and invert negative widths
%
%	    sigma gets squared so keep positive
%
	pdx = reshape( [1:3*mstruc.nbands], mstruc.nbands, 3 );
	nnn = find( mstruc.params( pdx(:,1) ) < 0 );

	if ~isempty(nnn)
	   	for jj = 1:length(nnn)
		   s =sprintf( '  Band #%3i has a negative width !!!', nnn(jj) );
		   disp( s )
	   	end
	end

	mstruc.params( pdx(:,2) ) = abs( mstruc.params( pdx(:,2) ) );
%
%	    check for positive strengths
%
	nnn = find( mstruc.params( pdx(:,3) ) > 0 );

	if ~isempty(nnn)
	   for jj = 1:length(nnn)
		s =sprintf( '  Band #%3i has a positive strength !!!', nnn(jj) );
		disp( s )
	   end
	end

	if (rmsimp <= mstruc.rimplim)
		disp( '  Improvement in rms less than limit !!' )
	end
	if (rmsnew <= mstruc.rmslim)
		disp( '  Rms less than limit !!' )
	end
	if (itimes == 0) 
		keepgoing = 0;			% ONE TIME FIT ONLY
	end
	if (rmsimp <= mstruc.rimplim)
		keepgoing = 0;			% IMPROVEMENT LIMIT REACHED
	end
	if (rmsnew <= mstruc.rmslim)
		keepgoing = 0;              	% RMS LIMIT REACHED
	end
return


function mstruc = spit_it_out( mstruc, rmscur, ppp, inparam, G )

  finalfile = strrep( mstruc.FITfile, '.fit', '_fin.fit' );
  lun2 = fopen( finalfile, 'wt' );

  
  fprintf(lun2, '%s\n', mstruc.DATDir );
  fprintf(lun2, '%s\n', mstruc.DFile );
  fprintf(lun2, '%4i,%4i,%4i\n', mstruc.YRange(1)*1000/10, ...
  			mstruc.YRange(2)*100, mstruc.YRange(3)*100);
  fprintf(lun2, '%4i,%4i,%4i\n', mstruc.XRange(1)*1000, ...
  			mstruc.XRange(2)*1000, mstruc.XRange(3)*1000);
  fprintf(lun2, '%3.3f,%3.E\n', mstruc.rmslim, mstruc.rimplim );
  fprintf(lun2, '%s\n', mstruc.contyp );

	   gtginv = inv( G'*G );
	   mstruc.std(ppp) =1.96 * sqrt( diag(gtginv) * rmscur^2 );  
% 	   1.96*st dev (95% conf)
%
%	   baseline continuum list	
%	
	   if ( mstruc.contyp ~= 'N' )
	   	ndx = find( mstruc.cparam );
		ncpar = length( ndx );
		uncert = mstruc.std( inparam-ncpar+1:inparam );
		if ncpar < 4 
		   uncert = [uncert, zeros( 4-ncpar,1 )];
		end
		fprintf( lun2, '  %15.6E%15.6E%15.6e%15.6E\n', mstruc.cparam );
		fprintf( lun2, '  %8.3f    %15.2E%15.2e%15.2E\n', uncert );

	   end
        fprintf( lun2, '%2i\n', mstruc.nbands );

%	   now list bands...
%
	wconst= 2.354820;
	uncert = mstruc.std(1:mstruc.nbands);
	temp=ones(1,mstruc.nbands)';
	cntmax=temp./(temp./mstruc.gcent-uncert*1E-7);
	cntmin=temp./(temp./mstruc.gcent+uncert*1E-7);	
	uncert=cntmax-cntmin;
	for k=1:mstruc.nbands
		fprintf( lun2, ...
			 '   %15.6e%15.6e%15.6e\n', ...
			 mstruc.gcent(k), ...
			 mstruc.gfwhm(k), ...
			 mstruc.gstr(k) );
		fprintf( lun2, ...
			 '        %8.4f      %8.4f      %8.4f\n', ...
			 uncert(k), ...
			 mstruc.std( mstruc.nbands+k )*wconst, ...
			 mstruc.std( 2*mstruc.nbands+k ) );
	end
  	fclose( lun2 );
return
