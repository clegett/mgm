function ipstat = filstat(mstruc)
%
%	subroutine to fill ipstat with derivative types
%
%	FILL THE TYPE PARTIAL DERIVATIVE ARRAY
%
%	1-nbands ARE CENTERS
%	nbands+1 - 2nbands ARE WIDTHS
%	2nbands+1 - 3bands ARE STRENGTHS
%
	nbands = mstruc.nbands;
	nparam = 3*nbands + 4;
	ipstat = zeros( nparam,2 );

	for K=1:nbands
	    ipstat( K,2 ) = 1;
	    ipstat( nbands+K,2 ) = 2;
	    ipstat( nbands+nbands+K,2 ) = 3;
	end

	ipstat( nparam-3:nparam,2 ) = [4,5,6,7]';    % CONSTANT, X, X*X, X*X*X
return
