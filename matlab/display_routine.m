function display_routine( mstruc, datstruc )

%	GRAPHICS set up...

	idate = date;

	whichdata = [1,2,0,4,5,0,7];

	XTitle = 'Wavelength (In Microns)';
	value = datstruc.wavel/1000.;

	xdir = 0;
	xtype = 0;
	XR= [mstruc.XRange(1:2),min(datstruc.waven/1000.), max(datstruc.waven/1000.)];
	YR= mstruc.YRange(1:2);
	plot_it( mstruc, ...
	         datstruc, ...
		 	 whichdata, ...
		 	 XTitle, ...
		 	 value, ...
			 xdir, ... 
			 xtype,...
			 XR, ...
			 YR);

	YesDisplay = 1;

	while YesDisplay == 1

%	   clc
	   yesps = 0;

	   fprintf('%s   =====  MGM-FIT  Display Routines =====\n', idate)
%
%	   write menu
%
	   disp( '   Select: 1-Display Graph in Wavelength Space' )
	   disp( '           2-Display Graph in Wavenumber Space' )
	   disp( '           3-Reset Display Ranges' )
	   disp( '           4-Reselect Curves' )
	   disp( '           5-Send to Encapsulated PostScript' )
	   disp( '           6-Send to TIFF' )
       disp( '           7-Send to SVG' )
	   disp( '           8-Exit Display      ' )

	   choice = input( ': ' );
	   if isempty( choice ) > 0
		choice = 8;
	   end

	   switch choice 
	   case 1
	   	value = datstruc.wavel/1000.;
	   	XTitle = ' Wavelength (In Microns)';
		xdir = 0;
		xtype = 0;
	   case 2
	   	value = datstruc.waven/1000.;
	   	XTitle = ' Wavenumber (cm-1/1000)';
		xdir = 1;
		xtype = 2;
	   case 3
	   	xmin = input( 'Enter Wavelength/Wavenumber MINIMUM: ' );
		if ~isempty( xmin )
			XR(1+xtype) = xmin;
		end
		xmax = input( 'Enter Wavelength/Wavenumber MAXIMUM: ' );
		if ~isempty( xmax )
			XR(2+xtype) = xmax;
		end
	   	ymin = input( 'Enter Log Reflectance MINIMUM: ' );
		if ~isempty( ymin )
			YR(1) = ymin;
		end
		ymax = input( 'Enter Log Reflectance MAXIMUM: ' );
		if ~isempty( ymax )
			YR(2) = ymax;
		end
	   case 4
%
%	      FIND OUT WHICH CURVES TO DISPLAY
%
	   	disp( ' Select Curves to be Displayed - ' )
	   	disp( '   S(pectra),B(ands),I(ndivid. Bands), R(Spec-Cont)')
	   	disp( '   F(it),C(ontinuum),E(Spec-Fit),A(All of them) ')

		answers = input(': ', 's' )
		if isempty( answers )
		    answers = 'A';
		else
		    answers = upper(answers);
		end
%
%	   	CLEAR DISPLAY FLAGS
%
	   	whichdata = zeros(7,1);

		cmtch = findstr( answers, 'S' );
		if isempty(cmtch) == 0 
		     whichdata(1) = 1;
		end
		cmtch = findstr( answers, 'F' );
		if isempty(cmtch) == 0 
		     whichdata(2) = 2;
		end
		cmtch = findstr( answers, 'B' );
		if isempty(cmtch) == 0 
		     whichdata(3) = 3;
		end
		cmtch = findstr( answers, 'I' );
		if isempty(cmtch) == 0 
		     whichdata(4) = 4;
		end
		cmtch = findstr( answers, 'C' );
		if isempty(cmtch) == 0 
		     whichdata(5) = 5;
		end
		cmtch = findstr( answers, 'R' );
		if isempty(cmtch) == 0 
		     whichdata(6) = 6;
		end
		cmtch = findstr( answers, 'E' );
		if isempty(cmtch) == 0 
		     whichdata(7) = 7;
		end
		cmtch = findstr( answers, 'A' );
		if isempty(cmtch) == 0 
		     whichdata = 1:7;
		end
	   case 5
	   	yesps = 1;
	   	postfile = strrep( mstruc.DATfile, 'asc', 'EPS' );
		orient portrait
	   	print( '-deps2c', '-tiff', postfile )
	   case 6
	   	yesps = 1;
	   	postfile = strrep( mstruc.DATfile, 'asc', 'TIF' );
		orient portrait
	   	print( '-dtiff', postfile )
       case 7
        yesps = 1;
        postfile = strrep( mstruc.DATfile, 'asc', 'SVG' );
        orient portrait
        print( '-dsvg', postfile )
	   case 8
		YesDisplay = 0;
	   otherwise
	   end  % switch statement %

	   if YesDisplay == 1 
		plot_it( mstruc, ...
		    datstruc, ...
		    whichdata, ...
		    XTitle, ...
		    value, ...
		    xdir, ...
			xtype, ...
			XR, ...
			YR);
	   end
	end  % while statement %
return

function plot_it(mstruc, ...
	     	datstruc, ...
	     	whichdata, ...
	     	XTitle, ...
	     	value, ...
     		xdir, ...
			xtype, ...
			XR, ...
			YR)

	idate = datestr( now );

   	plot( 0,0 )
	plottitle = strcat( idate, ' -', mstruc.DATfile );
	axis( [XR(1+xtype), XR(2+xtype), YR(1), YR(2)] )
	xlabel( XTitle )
	ylabel( 'Natural Log Reflectance' )
	title( plottitle )

	ndx = find( whichdata );
	nspec = length( ndx );

	hold on
	whitebg('w');
	for k = 1:nspec 
	    switch whichdata( ndx(k) )
	    case 1
		y = datstruc.ratio;
		if any(datstruc.daterror~=1)
                  errorbar( value, y(:,1),datstruc.daterror,'+k')
                  h=findobj('type','line');
                  set(h(2),'color',[1 .5 0]);  
            	end
%		klabel(k) = 'Spectra';
		cstyle = [1 .5 0];
		lwidth = 2;
		lstyle = 'none';
		marker = '+';
	    case 2
	        y = datstruc.fit;
%		klabel(k) = 'Fit';
		cstyle = 'black';
		lwidth = 2;
		lstyle = '-';
		marker = 'none';
	    case 3
		y = datstruc.gline;
%		klabel(k) = 'Cmb. Bnds';
		cstyle = 'g';
		lwidth = 2;
		lstyle = '-';
		marker = 'none';
	    case 4
		y = datstruc.gauss;
%		klabel(k) = 'Ind. Bnds';
		cstyle = 'b';
		lwidth = 2;
		lstyle = '-';
		marker = 'none';
	    case 5
		y = datstruc.cont;
%		klabel(k) = 'Cont.';
		cstyle = 'r';
		lwidth = 2;
		lstyle = '-';
		marker = 'none';
	    case 6
		y = datstruc.rcont;
%		klabel(k) = 'Spectra-Cont';
		cstyle = 'c';
		lwidth = 2;
		lstyle = '-.';
		marker = 'none';
	    case 7
		y = datstruc.resid+0.10;
%		klabel(k) = 'Spectra-Fit';
		cstyle = 'm';
		lwidth = 2;
		lstyle = '-';
		marker ='none';
	    otherwise
	    end

	    sz = size( y );
	    if sz(2) > 1
		b = sz(2);
	    else 
		b = 1;
	    end

	    for kk = 1:b
		plot( value, y(:,kk), ...
		      'linestyle', lstyle, ...
		      'color', cstyle, ...
		      'linewidth', lwidth, ...
			  'marker', marker)
	    end
	    if xdir == 1
	       set( gca, 'Xdir', 'reverse');
	    end

	end % for statement %
%	legend( klabel, -1 )
	hold off
return
