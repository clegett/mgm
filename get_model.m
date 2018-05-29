function mstruc = get_model(FitFile)
%
%	subroutine to get initial data for gfit
%
%	routine reads in initial file and parameters from a startup file
%	with extension .fit
%
wconst= 2.354820;
%
%	OPEN UP THE STARTUP FILE AND READ IN THE MODEL INFO
%
warning off MATLAB:mir_warning_variable_used_as_function;
mstruc = read_fitfile( FitFile ); 
nbands = mstruc.nbands;
nparam = mstruc.nparam;				% 3 params/gaussian + 4 for continuum

% 	INITIALIZE PARAMETERS
%
%	create cmm diagonals from est. model stnd dev.

cmm = zeros( nparam,1 );

mstruc.scent = wltown( mstruc.gcent - mstruc.scent ) - ...
	       wltown( mstruc.gcent + mstruc.scent );
mstruc.sfwhm = mstruc.sfwhm / wconst;

%	FILL THE PARAM ARRAY
%	    1-NBANDS           ARE CENTERS
%	    NBANDS+1 - 2NBANDS ARE WIDTHS
%	    2NBANDS+1 - 3BANDS ARE STRENGTHS

for k = 1:nbands	
    cmm(k) 	         = mstruc.scent(k);
    cmm(nbands+k)	 = mstruc.sfwhm(k);
    cmm(nbands+nbands+k) = mstruc.sstr(k);
end

cmm( nparam-3:nparam ) = mstruc.sparam;
mstruc.cmm = cmm;

ipstat = filstat( mstruc );              	% fill in the types of partials
ipstat(:,1) = 0;       			  	% unlock all parameters
mstruc.ipstat = ipstat;
return
