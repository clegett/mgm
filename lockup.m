function mstruc = lockup( mstruc )
%
%	subroutine to  lock/onlock parameters
%
%	ipmin,ipmax,ivtic   for  display
%	ihmin,ihmax,ihtic   for display
%	baseline constant
%	type of continuum   g gauss  p polynomial   n none  s straight line
%       p0,p1,p2  for continuum
%	number of absorptions 
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	etc
%
	TryAgain = 1
	while TryAgain == 1

%	   clc
	   itime = date;
	   disp( ' ' )
	   disp( ' ' )
	   disp(sprintf('%s  =====  Lock/Unlock MGM-Fit Parameters  =====',itime))
%
%	   now write menu
%
	   disp( '  Select:  1 - Lock All Bandcenters')
	   disp( '           2 - Unlock All Bandcenters')
	   disp( '           3 - Lock All Bandwidths')
	   disp( '           4 - Unlock All Bandwidths')
	   disp( '           5 - Lock All Strengths')
	   disp( '           6 - Unlock All Strengths')
	   disp( '           7 - Lock Polynomial Constants')
	   disp( '           8 - Unlock Non-Zero Polynomials')
	   disp( '           9 - Lock An Individual Parameter')
	   disp( '          10 - Unlock An Individual Parameter')
	   disp( '          11 - Lock An Individual Absorption')
	   disp( '          12 - Unlock An Individual Absorption')
	   disp( '          13 - Display Current Parameter Status')
	   disp( '          14 - Exit       > ')

	   choice = input(':  ');
	   if isempty( choice )
		choice = 14;
	   end
	
	   switch choice
	   case 1			% lock centers
	   	cdx = 1:mstruc.nbands;
	   	mstruc.ipstat(cdx,1) = 1;
	   case 2			% unlock centers
		cdx = 1:mstruc.nbands;
		mstruc.ipstat(cdx,1) = 0;
	   case 3			% lock widths
		cdx = [1:mstruc.nbands] + mstruc.nbands;
		mstruc.ipstat(cdx,1) = 1;
	   case 4			% unlock widths
		cdx = [1:mstruc.nbands] + mstruc.nbands;
		mstruc.ipstat(cdx,1) = 0;
	   case 5			% lock strengths
		cdx = [1:mstruc.nbands] + mstruc.nbands + mstruc.nbands;
		mstruc.ipstat(cdx,1) = 1;
	   case 6			% unlock strengths
		cdx = [1:mstruc.nbands] + mstruc.nbands + mstruc.nbands;
		mstruc.ipstat(cdx,1) = 0;
	   case 7			% lock polynomial parameters
		mstruc.ipstat(mstruc.nparam-3:mstruc.nparam,1) = 1;
	   case 8			% unlock nonzero polynomial parameters
		ndx = find( mstruc.cparam > 0 );
		index = [1:4] + mstruc.nparam - 4;
		mstruc.ipstat(index(ndx),1) = 0;
	   case 9			% lock an individual parameter
		reprompt  = 1;

		while reprompt == 1
		    nband = mstruc.nbands;
		     fprintf('  Centers are    1 - %2i\n', nband) 
		     fprintf('  Widths  are   %2i - %2i\n', ...
				  nband+1, 2*nband) 
		     fprintf('  Strengths are %2i - %2i\n', ...
				  2*nband+1,3*nband) 
		     fprintf('  CpN   is      %2i - %2i\n', ...
				  3*nband+1, mstruc.nparam)

		    ipar = input(' Enter Parameter ID: ')

		    if (ipar > mstruc.nparam)
			reprompt = 1;
		    else
			reprompt = 0;
		    end
		end   % while %
		if (ipar >= 1) && (ipar <= mstruc.nparam)
		    mstruc.ipstat(ipar,1) = 1;
		end
	  case 10			% unlock an individual parameter
		reprompt  = 1;

		while reprompt == 1
		    nband = mstruc.nbands;
		    disp( strcat('  Centers are    1 - ', num2str(nband)) )
		     fprintf('  Widths  are   %2i - %2i\n', ...
				  nband+1, 2*nband) 
		     fprintf('  Strengths are %2i - %2i\n', ...
				  2*nband+1,3*nband) 
		     fprintf('  CpN   is      %2i - %2i\n', ...
				  3*nband+1, mstruc.nparam)

		    ipar = input(' Enter Parameter ID: ');

		    if (ipar > mstruc.nparam)
			reprompt = 1;
		    else
			reprompt = 0;
		    end
		end   % while %
		if (ipar >= 1) && (ipar <= mstruc.nparam)
		    mstruc.ipstat(ipar,1) = 0;
		end
	  case 11			% lock an absorption
		reprompt = 1;

		while reprompt == 1
		    ipar = input(' Lock Absorption #? ')

		    if (ipar > mstruc.nbands)
			reprompt = 1;
		    else
			reprompt = 0;
		    end
		end
		if (ipar >= 1) && (ipar <= mstruc.nbands)
		    pdx = reshape( [1:3*mstruc.nbands], mstruc.nbands,3 );
		    mstruc.ipstat( pdx(ipar,:),1 ) = 1;
		end
	  case 12			% unlock an absorption
		reprompt = 1;

		while reprompt == 1
		    ipar = input(' Unlock Absorption #? ')

		    if (ipar > mstruc.nbands)
			reprompt = 1;
		    else
			reprompt = 0;
		    end
		end
		if (ipar >= 1) && (ipar <= mstruc.nbands)
		    pdx = reshape( [1:3*mstruc.nbands], mstruc.nbands,3 );
		    mstruc.ipstat( pdx(ipar,:),1 ) = 0;
		end
	  case 13
		liststat(mstruc);
	  case 14
		TryAgain = 0;
	  otherwise 
	  end  %switch/case statement%

	end % while statement %
return
