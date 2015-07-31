function [T] = parseFloatViz( fname )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
float_header;
fid = fopen(fname);
line = '//';
while strncmpi(line,'//',2)
    line = fgetl(fid);
end

headerLine = strsplit(line,'\t');
nCols = length(headerLine);
lineSpec = [];
varName = cell(1,nCols);
for ii = 1:nCols
    varName{ii} = head2var(headerLine{ii});
    lineSpec = [lineSpec head2form(headerLine{ii})];
end
%varName = matlab.lang.makeUniqueStrings(varName);
d = strcmpi(varName,'QF');
varName(d) = strcat(varName(d), varName([d(end) d(1:end-1)]));
%lineSpec = [repmat('%s',[1,5]) repmat('%f',[1,nCols-5])];
cellData = textscan(fid,lineSpec,'Delimiter','\t');
fclose(fid);

T = table;
for ii = 1:nCols
    T.(varName{ii}) = cellData{ii};
    Tunits{ii} = head2units(headerLine{ii});
end
T.Properties.VariableUnits = Tunits;
T.dtm = datetime(strcat(T.mmddyy, T.hhmm),'InputFormat','MM/dd/yyyyHH:mm');
T.daten = datenum(T.dtm);





