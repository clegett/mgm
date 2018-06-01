function c = cgauss(x0, width, zintens, x)
% CGAUSS(X0, width, str, X) gives the gaussian distribution over the elements
% of X.
% X0 = gaussian center
% width = full-width half maximum
% zintens = strength or amplitude

xdif  = x - x0;                 		% ROOTS PRECALCULATED
xsq   = xdif .* xdif;
sigsq = width;
c = zintens .* exp(xsq./sigsq);

return
