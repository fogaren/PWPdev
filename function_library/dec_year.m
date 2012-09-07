% function to return decimal year 
%
% INPUT ------------------------------------------------------------------- 
% daten:    matlab datenum
% OUTPUT ------------------------------------------------------------------
% decyr:    decimal year
% doy:      day of year
%
% USAGE -------------------------------------------------------------------
% dn = datenum(2012,8,25)
% [decyr, doy] = dec_year(dn)
% decyr = 2.012647540983607e+03 
% doy = 238
%
% Author: David Nicholson dnicholson@whoi.edu 25-Aug-2012



function [decyr, doy] =  dec_year(daten)

% matlab date vector from datenumber
dv = datevec(daten);
% year
yr = dv(:,1);
%datenum for start of each year
yr_dn = datenum(yr,1,1);
% datenum for start of next year
nxt_yr_dn = datenum(yr+1,1,1);

% year fract is fraction of year
yr_fract = (daten-yr_dn)./(nxt_yr_dn - yr_dn);

decyr = yr+yr_fract;

if nargout == 2
    doy = daten - yr_dn + 1;
end