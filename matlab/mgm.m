%
%	MGM version 2.0 MATLAB main
%
%	roots contain par **-2.0  
%
%	[FitFile, dirpath] = uigetfile( '*.fit', 'Enter Startup File Name:' );

function mgm

FEXT='.fit';
start = input( ' Enter Startup File Name (*.fit): ', 's' );

FitFile = strcat ( start, FEXT );

if ~ischar( FitFile ), return, end

%if ~exist( fullfile( dirpath, FitFile ), 'file' )

if ~exist( FitFile , 'file' )
   error( ['File does not exist: ', FitFile] )
end

% FitFile  = fullfile( dirpath, FitFile );
warning off MATLAB:mir_warning_variable_used_as_function;
mstruc = get_model(FitFile); 
datstruc = get_data( mstruc.DATfile, mstruc.nbands );
[mstruc, datstruc] = fillup( mstruc, datstruc );    % FILL UP THE ARRAYS


%	SET INITIAL ERROR LIMITS
iresl = abs( datstruc.wavel(2) - datstruc.wavel(1) );
if iresl < 1, iresl = 1; end
ifitres  = iresl;
isampres = ifitres/iresl;   			     % CALCULATE FIT FREQUENCY
rmsold   = rmserr( datstruc.fit, datstruc.ratio );

fitflag  = 0;

DoAgain = 1;
while DoAgain

   IDATE = date;
   disp(' ')
   disp(' ')
   disp('          ======= MGM-FIT 2.0 MATLAB Main Menu ========')
   disp(' ')
   disp('   By Jessica Sunshine and Stephen Pratt -- Brown University')
   disp(strcat(IDATE,'                      		    and SAIC'))
   disp(' ')
   disp('   Select: 1-Display Current Parameters')
   disp('           2-Fit Once')
   disp('           3-Fit Until')
   disp('           4-Add/Del/Ch a Parameter')
   disp('           5-Lock/Unlock a Parameter')
   disp('           6-Display Routines')
   disp('           7-Storage Routines (Ref.)')
   disp('           8-Storage Routines (Log)')
   disp('           9-Display Parameter Status')
   disp('          10-Set Fit Resolution')
   disp('          11-Stop ')

   choice = input(':  ');
   if isempty( choice ), choice = 11; end

   switch choice

   case 1

      % List current parameters

      listpar(mstruc, datstruc);			

   case 2

      % CALL FITTING ONC

      [mstruc,datstruc] = stocfit( mstruc, datstruc, isampres, 0);

      fitflag = 1;

   case 3

      % CALL FITTING MULTI

      [mstruc,datstruc] = stocfit( mstruc, datstruc, isampres, 1);

      fitflag = 1;

   case 4

      % CHANGE/DEL/ADD A BAND

      [mstruc, datstruc] = chpar(mstruc, datstruc);

   case 5

      % LOCK/UNLOCK PARAMETERS

      mstruc = lockup(mstruc);			

   case 6

      % DISPLAY PLOT

      display_routine(mstruc, datstruc);		

   case 7

      % STORING PARAMETERS (Ref)

      storcurv1(mstruc, datstruc);			

   case 8

      % STORING PARAMETERS (Log)

      storcurv2(mstruc, datstruc);			

   case 9

      % LISTING PARAMETERS

      liststat(mstruc);				

   case 10						

      % SETTING FIT RESOLUTION

      iresl = abs( datstruc.wavel(2) - datstruc.wavel(1) );

      disp([' Spectrum Resolution ', num2str(iresl), ...
            ' Nm.  Fitting Resolution ', num2str(ifitres), ' Nm.']);

      ifitres = input( ' Enter Fitting Resolution in Nanometers: ' );

      if ifitres < 1, ifitres = iresl; end

      isampres = fix( ifitres/iresl ) ;  		% CALCULATE FIT FREQUENCY

      if isampres < 1, isampres = 1; end

   case 11						

      % Quit

      if fitflag, dumpar(mstruc, datstruc); end

      DoAgain = 0;
   end	%switch statement%

end  %while statement%
return