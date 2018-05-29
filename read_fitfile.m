function mstruc = read_fitfile(FitFile)

% This routine reads a FIT file with the following formatted data:
%
%	directory
%	file
%	ipmin,ipmax,ivtic   for  display
%	ihmin,ihmax,ihtic   for display
%	baseline constant
%	type of continuum   g gauss  p polynomial   n none
%       p1,p2,p3  for continuum
%	number of bands
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	center in nm   fwhm in inverse cm    intensity
%	etc
%
% INPUTS:
%     FitFile:	String defining FIT file to read
%
% OUTPUTS:
%     GStruc: 	MATLAB structure containing initial parameters for fit.
%

lun = fopen( FitFile, 'rt' );

ext  = '.asc';

% read in directory path
direct = fgetl( lun );
direct = strtok(direct);	%gets rid of leading and trailing blanks

% read in file name
filename = fgetl( lun );
filename = strtok(filename);

%new test to avoid 'direct' variable containing a ':'
if(direct == ':') 
    direct = '';
end

datafile = strcat( direct,filename,ext );

if ~exist( datafile, 'file' )

   disp( ['Data file does not exist: ', datafile] )

end

% read in y-axis range
yr = fgetl( lun );
YRange = str2num( yr );

% read in x-axis range
xr = fgetl( lun );
XRange = str2num( xr );

XRange = XRange/1000.;
YRange = YRange/100.;

% read in error limits
error = fgetl( lun );
disp(['error: ' error])
rms = str2num( error );
disp(['rms: ' rms])
rmslim = rms(1);
rimplim = rms(2);

% read in continuum type
contyp = fgetl( lun );
contyp = strtok( upper(contyp) );

% read in initial 'c' parameters
cp = fgetl( lun );
cp = str2num( cp );

% read in initial 's' parameters
sp = fgetl( lun );
sp = str2num( sp );

% read in initial gaussian paramters (3 per gaussian dist.)
ngauss = fgetl( lun );
ngauss = str2num( ngauss );		% the number of gaussians in fit

gcent = zeros(ngauss,1);
gfwhm = zeros(ngauss,1);
gstr  = zeros(ngauss,1);
scent = zeros(ngauss,1);
sfwhm = zeros(ngauss,1);
sstr  = zeros(ngauss,1);

for k = 1:ngauss
	gpar = fgetl(lun);
	gpar = str2num( gpar );
	gcent(k) = gpar(1);
	gfwhm(k) = gpar(2);
	gstr(k)  = gpar(3);

	gpar = fgetl(lun);
	gpar = str2num( gpar );
	scent(k) = gpar(1);
	sfwhm(k) = gpar(2);
	sstr(k)  = gpar(3);
end
fclose( lun );

if contyp == 'S' || contyp == 'T'
   sWav1 = cp(1);
   sWav2 = cp(2);
else
   sWav1 = 0.;
   sWav2 = 0.;
end

nparam = 3*ngauss + 4;

roots.cnrt = zeros(ngauss,1);
roots.sgsq = zeros(ngauss,1);

mstruc.FITfile = FitFile;
mstruc.DATDir  = direct;
mstruc.DFile = filename;
mstruc.DATfile = datafile;
mstruc.filename = filename;
mstruc.wconst  = 2.354820;
mstruc.contyp  = contyp;
mstruc.cparam  = cp;
mstruc.sparam  = sp;
mstruc.swav1   = sWav1;
mstruc.swav2   = sWav2;
mstruc.rmslim  = rmslim;
mstruc.rimplim = rimplim;
mstruc.gcent   = gcent;
mstruc.gfwhm   = gfwhm;
mstruc.gstr    = gstr;
mstruc.scent   = scent;
mstruc.sfwhm   = sfwhm;
mstruc.sstr    = sstr;
mstruc.gcentn  = zeros(ngauss,1);
mstruc.gwidth  = zeros(ngauss,1);
mstruc.params  = zeros(nparam,1);
mstruc.nparam  = nparam;
mstruc.nbands  = ngauss;
mstruc.cmm     = zeros(nparam,1);
mstruc.ipstat  = zeros(nparam,2);
mstruc.roots   = roots;
mstruc.XRange  = XRange;
mstruc.YRange  = YRange;
mstruc.PARAM0  = zeros(nparam,1);
mstruc.std     = zeros(nparam,1);	
return
