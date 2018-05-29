function [mstruc,datstruc] = fillup( mstruc, datstruc )
%
%	subroutine to FILL ALL THE GFIT ARRAYS
%
	wconst = mstruc.wconst;

	[params, mstruc, datstruc] = shuffl( mstruc, datstruc );
%
%	THEN BUILD THE INDIVIDUAL BANDS
%
	gauss = zeros( datstruc.npnts, mstruc.nbands );

	for K=1:mstruc.nbands
	    gauss(:,K) = cgauss( mstruc.roots.cnrt(K), ...
			         mstruc.roots.sgsq(K), ...
				 mstruc.gstr(K), ...
				 datstruc.wvrt );
	end
%
%	CALCULATE SUM OF THE BANDS
%
	gline = sum( gauss, 2 );
%
%	SET CLEAR CONTINUUM POLYNOMIAL PARAMETERS
%
	switch mstruc.contyp
	case 'P'			% polynomial in wavelength space
		w = datstruc.wavel;
		ws = w .* w;
		wc = w .* ws;
		cont = mstruc.cparam(1) + ...
		       ( mstruc.cparam(2)*w ) + ...
		       ( mstruc.cparam(3)*ws) + ...
		       ( mstruc.cparam(4)*wc); 
		cont = log( cont );
	case 'Q'			% polynomial in wavenumber space
		w = datstruc.waven;
		ws = w .* w;
		wc = w .* ws;
		cont = mstruc.cparam(1) + ...
		       ( mstruc.cparam(2)*w ) + ...
		       ( mstruc.cparam(3)*ws) + ...
		       ( mstruc.cparam(4)*wc); 
		cont = log( cont );
	case 'S'			% STRAIGHT LINE REMOVAL IN WAVEL SPACE
		w = datstruc.wavel;
		ws = w .* w;
		wc = w .* ws;
		cont = mstruc.cparam(1) + ...
		       ( mstruc.cparam(2)*w ) + ...
		       ( mstruc.cparam(3)*ws) + ...
		       ( mstruc.cparam(4)*wc); 
		cont = log( cont );
	case 'T'			% STRAIGHT LINE IN WAVEN SPACE
		w = datstruc.waven;
		ws = w .* w;
		wc = w .* ws;
		cont = mstruc.cparam(1) + ...
		       ( mstruc.cparam(2)*w ) + ...
		       ( mstruc.cparam(3)*ws) + ...
		       ( mstruc.cparam(4)*wc); 
		cont = log( cont );
	otherwise
		cont = zeros( datstruc.npnts,1 );	% No Continuum
	end	% switch statement %
%
%	CALCULATE FIT LINE
%
	fit = cont + gline;
%
%	CALCULATE RESIDUAL AND REMAIN
%
	resid = datstruc.ratio - fit;
	rcont = datstruc.ratio - cont;

	datstruc.gline  = gline;
	datstruc.cont   = cont;
	datstruc.gauss  = gauss;
	datstruc.fit    = fit;
	datstruc.resid  = resid;
	datstruc.rcont  = rcont;
	mstruc.params   = params;
return


function [params,mstruc,datstruc] = shuffl( mstruc, datstruc )
%
%	subroutine to fill the param array
%

	wconst=mstruc.wconst;
%
%	FIRST CONVERT WAVEL TO WAVEN AND FWHM TO WIDTH
%
	ndx = find( datstruc.waven );
	datstruc.wvrt(ndx) = (1.0 ./ datstruc.waven(ndx)) * 1e7;

	mstruc.gcentn = wltown( mstruc.gcent );		% convert to wavenumber
	mstruc.gwidth = mstruc.gfwhm/wconst;

	ndx = find( mstruc.gcentn );
	mstruc.roots.cnrt(ndx) = (1.0 ./ mstruc.gcentn(ndx)) * 1e7;

 	SGRT = mstruc.gwidth;              		% to be determined
	mstruc.roots.sgsq = (SGRT .* SGRT) * (-2.0);    % -2.0 * SIGMA SQUARED
%
%	FILL THE PARAM ARRAY
%	1-nbands ARE CENTERS
%	nbands+1 - 2nbands ARE WIDTHS
%	2nbands+1 - 3bands ARE STRENGTHS
%
	nbands = mstruc.nbands;
	nparam = 3*nbands + 4;
	params = zeros( nparam,1 );

	for K=1:nbands
	    params(K)       	   = mstruc.gcentn(K);
	    params(nbands+K)	   = mstruc.gwidth(K);
	    params(nbands+nbands+K)= mstruc.gstr(K);
	end
%
%	STORE THE CONT/BASELINE PARAMS
%
	params( nparam-3:nparam ) = mstruc.cparam; 

	mstruc.PARAM0 = params; 	   % store the original parameters 
return


