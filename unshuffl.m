function mstruc = unshuffl(mstruc)
%
%	subroutine to put param array back to individual
%	gaussian arrays
%
	wconst = mstruc.wconst;
%
%	unshuffl the params
%
	for k=1:mstruc.nbands
	    mstruc.gcentn(k) = mstruc.params(k);
	    mstruc.gwidth(k) = mstruc.params(mstruc.nbands+k);
	    mstruc.gfwhm(k)  = mstruc.gwidth(k) * wconst;
	    mstruc.gstr(k)   = mstruc.params(mstruc.nbands+mstruc.nbands+k);

	    mstruc.gcent(k) = wntowl( mstruc.gcentn(k) );
	end
%
%	UNSTORE THE CONT/BASELINE PARAMS
%
	mstruc.cparam = mstruc.params( mstruc.nparam-3:mstruc.nparam );
return
