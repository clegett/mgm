function pg = pgauss(x0, width, zintens, x, ipart)
%
%	subroutine to compute partial derivatives of gaussians
%
%	if ipart=1   derivative/center
%	   ipart=2   derivative/width
%	   ipart=3   derivative/intensity
%
%
xdif = x - x0;                			% supplied wave are x**-.2
xsq  = xdif .* xdif;
sigma= width;
sigsq= sigma .* sigma;

switch ipart
%
%	evaluate partial derivative with respect to center
%
case 1
	pg=(xdif./sigsq).*(-1.0*x0^2.0)/1.0E7;  	% change magnitude
%
%	evaluate partial derivative with respect to width
%
case 2
	pg=xsq./(sigsq.*sigma);
%
%	evaluate partial derivative with respect to strength
%
case 3
	pg=1.0/zintens;
otherwise
	error('No such partial derivative!')
end
return
