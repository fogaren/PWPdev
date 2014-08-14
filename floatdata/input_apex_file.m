% function input_apex_file
% -------------------------------------------------------------------------
% Description: parses a MBARI floatviz ascii file and saves data in a
% matlab .MAT file.
% 
% Inputs:
% froot         File root (do not include '.txt')
% ndata_cols    number of data columns - does not include first 7 columns 
%               or the 'quality flag columns. e.g. ndata_cols = 7 when
%               there are a total of 21 columns (7 info, 7 variables, 7 qf)

function [] = input_apex_file(froot,ndata_cols,nHeaderLines)


ninfo_cols = 7;


T = readtable([froot '.txt'],'HeaderLines',nHeaderLines,'ReadVariableNames',false,'Delimiter','\t');
T(~strncmp(T.Var1,froot,4),:) = [];
T(strcmpi(T.Var4,''),:) = [];
T.Var8 = [];

% calculate matlab date number and decimal date
sp = {' '};
dstr = strcat(T{:,4},sp,T{:,5});

dn = datenum(dstr);
dv = datevec(dn);
dec_yr = dec_year(dn);


% create data matrix and replace 1st columns w/ date info
ncols = ninfo_cols+2.*ndata_cols;
data = zeros(length(dn),ncols);
data(:,1) = dec_yr;
data(:,2) = dv(:,2);
data(:,3) = dv(:,3);
data(:,4) = dv(:,1);
data(:,5) = rem(dn,1);

load('data_header.mat');
%data_header(1,1:5) = {'year date','month','day','year','decimal day'};

data(:,6:ncols) = table2array(T(:,6:ncols));

save([froot '.mat'],'data_header','data');