function [mstruc,datstruc] = chpar( mstruc, datstruc )
%
%	subroutine to change cont,baseline, or band parameters
%
%	ipmin,ipmax,ivtic   for  display
%	ihmin,ihmax,ihtic   for display
%	baseline constant
%	type of continuum   g gauss  p polynomial   n none  s straight line
%       p0,p1,p2  for continuum
%	number of bands
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	etc
%
	DoAgain = 1;
	while DoAgain == 1

	   itime = date;

	   disp( ' ' )
	   disp( ' ' )
	   disp(sprintf('%s    =====  Change MGM-Fit Parameters  =====', itime))
%
%	   now write menu
%
	   disp( '  Select:  1 - Change Continuum Type' )
	   disp( '           2 - Change Continuum Parameters')
	   disp( '           3 - Change An Absorption')
	   disp( '           4 - Add An Absorption')
	   disp( '           5 - Delete An Absorption')
	   disp( '           6 - Display')
	   disp( '           7 - Main Menu   > ')

	   choice = input(':  ');
	   if isempty( choice ), choice = 7; end

	   switch choice
      case 1
         %	change continuum type
         validcont = ['N';'P';'Q';'G';'S';'T'];
         disp(' ')
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
            s = strcat( s, sprintf( '%7.1f\t%7.1f', ...
               mstruc.swav1, ...
               mstruc.swav2 ) );
            disp( s )
             fprintf( '\r\r\n') 

         case 'T'
            s = sprintf(' Straight line removed in Wavenumber ');
            s = strcat( s, sprintf( '%7.1f\t%7.1f', ...
               mstruc.swav1, ...
               mstruc.swav2 ) );
            disp( s )
             fprintf( '\r\r\n') 
		 otherwise
             fprintf( '\r\r\n') 
         end

         disp( ' ' )
         ans = input( ' Enter new continuum type (N,P,Q,G,S,T): ','s' );
         ans = strtok(upper(ans));

         if isempty( ans )
            disp( 'WARNING - Not a valid choice!' )
         else

            vdx = strmatch( ans,validcont );
            if isempty(vdx)
               disp( 'WARNING - Not a valid choice!' )
            else
               mstruc.contyp = ans;
            end
         end
      case 2

         % change continuum parameter

         s = sprintf(' P0= %15.8e  P1= %15.8e  P2= %15.8e  P3= %E15.8',...
            mstruc.cparam );

         switch mstruc.contyp
         case 'P'
            disp( s )
         case 'Q'
            disp( s )
         case 'S'
            s = sprintf(' Straight line removed in Wavelength ');
            s = strcat( s, sprintf( '%7.1f\t%7.1f', ...
               mstruc.swav1, ...
               mstruc.swav2 ) );
            disp( s )
             fprintf( '\r\r\n') 
         case 'T'
            s = sprintf(' Straight line removed in Wavenumber ');
            s = strcat( s, sprintf( '%7.1f\t%7.1f', ...
               mstruc.swav1, ...
               mstruc.swav2 ) );
            disp( s )
             fprintf( '\r\r\n') 
         otherwise
		end
		p = zeros(4,1);
		for k=1:4 
         p(k) = input( strcat('Enter continuum parameter P', ...
            num2str(k), sprintf(': ') ) );
		end
		if (mstruc.contyp == 'S') || (mstruc.contyp == 'T')

         % STRAIGHT LINE REASSIGN
			if p(1) ~= 0, mstruc.swav1 = p(1); end
			if p(2) ~= 0, mstruc.swav2 = p(2); end
		elseif (mstruc.contyp == 'P') || (mstruc.contyp == 'Q')

         % POLYNOMIAL REASSIGN
			if p(1) ~= 0, mstruc.cparam(1) = p(1); end
			if p(2) ~= 0, mstruc.cparam(2) = p(2); end
			if p(3) ~= 0, mstruc.cparam(3) = p(3); end
			if p(4) ~= 0, mstruc.cparam(4) = p(4); end
      end

      [mstruc, datstruc] = recalculate( mstruc, datstruc );

   case 3

      % change a band's parameters
      if mstruc.nbands > 1
         k = input( strcat(' Which Absorption Band (1 - ', ...
            strtok( num2str(mstruc.nbands) ), ...
            ') ? ') );
		else
         k = 1;
      end      

      if (k > 0) && (k <= mstruc.nbands)
         s1 = sprintf('  %2i  Center= %15.8e   ', k, mstruc.gcent(k));
         s2 = sprintf('FWHM= %15.8e   Str= %15.8e', ...
            mstruc.gfwhm(k), mstruc.gstr(k));

         disp( strcat(s1,s2) );
         names = ['Center  '; 'Width   '; 'Strength'];
         p = zeros(3,1);
         for kk=1:3
            p(kk) = input( strcat('Enter band parameter- ', ...
               names(kk,:), ': ') );
         end

           if p(1) ~= 0, mstruc.gcent(k) = p(1); end
		   if p(2) ~= 0, mstruc.gfwhm(k) = p(2); end
		   if p(3) ~= 0, mstruc.gstr(k) = p(3); end
         [mstruc,datstruc] = recalculate( mstruc, datstruc );
      end
   case 4

      % add an absorption

        p0(1) = input( ' Enter Center in NM: ' );
		p0(2) = input( ' Enter Center Uncertainty in NM: ' );
		p1(1) = input( ' Enter FWHM in NM: ' );
		p1(2) = input( ' Enter FWHM Uncertainty in NM: ' );
		p2(1) = input( ' Enter Strength: ' );
        p2(2) = input( ' Enter Strength Uncertainty: ' );

      %
	  %		move other params to temp arrays
      %

      mstruc = putin( mstruc, mstruc.nbands+1, p0, p1, p2 );
		
	  %
      %		need to re-define size of datstruc.gauss to compensate for
      %		additional band..

      datstruc.gauss = zeros(datstruc.npnts,mstruc.nbands);

      [mstruc,datstruc] = recalculate( mstruc, datstruc );

   case 5

      % delete an absorption
      if mstruc.nbands > 1
         k = input( strcat(' Which Absorption to delete (1 - ', ...
            strtok( num2str(mstruc.nbands) ), ...
            ') ? ') );
      else
         k = 1;
      end

      if (k > 0) && (k <= mstruc.nbands)
         s1 = sprintf('  %2i  Center= %15.8e   ', k, mstruc.gcent(k));
         s2 = sprintf('FWHM= %15.8e   Str= %15.8e', ...
            mstruc.gfwhm(k), mstruc.gstr(k));         
         disp( strcat(s1,s2) )
         ans = input( ' Delete This Absorption (y/n)? ','s' );
         if upper(ans) == 'Y'
            %	delete Absorption # k
            mstruc = takeout( mstruc, k )            
			%	need to re-define size of datstruc.gauss to
            %	compensate for additional band...
            datstruc.gauss = zeros(datstruc.npnts,mstruc.nbands);
            [mstruc, datstruc] = recalculate( mstruc, datstruc );
         end
      end

   case 6
      display_routine( mstruc, datstruc );
   case 7
      DoAgain = 0;
   end
   disp( ' ' )
   disp( ' ' )

end %while statement%
return

function [mstruc, datstruc] = recalculate( mstruc, datstruc )
%
%	recalculate everything
%
%	SET CLEAR POLYNOMIAL PARAMETERS
%
	switch mstruc.contyp
	case 'S'
		npnts = datstruc.npnts;
		swav1 = mstruc.swav1;
		swav2 = mstruc.swav2;
		wavel = datstruc.wavel;
		ratio = datstruc.ratio;
		
	    	[const,slope] = tremove( npnts, swav1, swav2, wavel, ratio, 0 );
		mstruc.cparam = [const, slope, 0., 0.];
	case 'T'
		npnts = datstruc.npnts;
		swav1 = mstruc.swav1;
		swav2 = mstruc.swav2;
		waven = datstruc.waven;
		ratio = datstruc.ratio;
		[const,slope] = tremove( npnts, swav1, swav2, wavel, ratio, 1 );
		mstruc.cparam = [const, slope, 0., 0.];
	otherwise
	end
	
	[mstruc, datstruc] = fillup( mstruc, datstruc );   % FILL UP THE ARRAYS
return



function mstruc = putin( mstruc, nbands, p0, p1, p2 )
      	%
      	% Adding an absorbtion feature to model struc
      	%
      	nparam = 3*nbands + 4;	
      	params = zeros( nparam,1 );
      	cmm    = zeros( nparam,1 );

      	oldbands  = mstruc.nbands;
      	oldnparam = mstruc.nparam;

      	% Fill in the values of the other parameters in the new arrays

      	pdx = reshape( [1:3*nbands], nbands, 3 )
      	odx = pdx(1:oldbands,:)

      	params( odx )         	= mstruc.params( 1:oldnparam-4 ); 
      	params( pdx(nbands,:) )	= [p0(1), p1(1), p2(1)];
      	params( nparam-3:nparam ) = mstruc.params( oldnparam-3:oldnparam )

      	cmm( odx )       	= mstruc.cmm( 1:oldnparam-4 ); 
      	cmm( pdx(nbands,:) )	= [p0(2), p1(2), p2(2)];
      	cmm( nparam-3:nparam )	= mstruc.cmm( oldnparam-3:oldnparam );

      	% Redefine model structure

      	newroot.cnrt = zeros(nbands,1);
	newroot.sgsq = zeros(nbands,1);

      	mstruc.gcent = [mstruc.gcent; p0(1)];
	mstruc.gfwhm = [mstruc.gfwhm; p1(1)];
	mstruc.gstr =  [mstruc.gstr; p2(1)];
	mstruc.scent = [mstruc.scent; p0(2)];
	mstruc.sfwhm = [mstruc.sfwhm; p1(2)];
	mstruc.sstr =  [mstruc.sstr; p2(2)];
	mstruc.gcentn = [mstruc.gcentn; 0.];
	mstruc.gwidth = [mstruc.gwidth; 0.];
	mstruc.params = params;
	mstruc.nparam = nparam;
	mstruc.nbands = nbands;
	mstruc.cmm = cmm;
	mstruc.ipstat = zeros(nparam,2);
	mstruc.roots = newroot;

      	ipstat = filstat(mstruc);
      	mstruc.ipstat = ipstat;
return

function mstruc = takeout( mstruc, nbands )				        
      %
      % Taking out an absorbtion feature to model struc
      %
      new_nbands = mstruc.nbands - 1;
      pdx = reshape( [1:3*mstruc.nbands], mstruc.nbands, 3 );
      ngauss = 1:mstruc.nbands;
      gdx = find( ngauss ~= nbands );

      index = pdx( gdx,: );

      params = zeros( 3*new_nbands+4, 1 );
      params(1:3*new_nbands)     = mstruc.params(index);
      params(3*new_nbands+1:end) = mstruc.params(mstruc.nparam-3:mstruc.nparam);

      cmm = zeros( 3*new_nbands+4,1 );
      cmm(1:3*new_nbands)      = mstruc.cmm(index);
      cmm(3*new_nbands+1:end) = mstruc.cmm(mstruc.nparam-3:mstruc.nparam);

      	% Redefine model structure

      	newroot.cnrt = zeros(new_nbands,1);
	newroot.sgsq = zeros(new_nbands,1);

      	mstruc.gcent = mstruc.gcent(gdx);
	mstruc.gfwhm = mstruc.gfwhm(gdx);
	mstruc.gstr =  mstruc.gstr(gdx);
	mstruc.scent = mstruc.scent(gdx);
	mstruc.sfwhm = mstruc.sfwhm(gdx);
	mstruc.sstr =  mstruc.sstr(gdx);
	mstruc.gcentn = mstruc.gcentn(gdx);
	mstruc.gwidth = mstruc.gwidth(gdx);
	mstruc.params = params;
	mstruc.nparam = length( params );
	mstruc.nbands = new_nbands;
	mstruc.cmm = cmm;
	mstruc.ipstat = zeros(mstruc.nparam,2);
	mstruc.roots = newroot;

      	ipstat = filstat(mstruc);
      	mstruc.ipstat = ipstat;
return