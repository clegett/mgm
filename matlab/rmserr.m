function r = rmserr(arr1, arr2)
%
%	calculate the root mean square error between two arrays
%
dif   = arr1 - arr2;
sqr   = dif .* dif;
tot   = sum( sqr )/length(arr1);
r     = sqrt( tot );
return
