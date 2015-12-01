% function to break Argo data into discrete profiles

function [dataout] = findGliderProf(data,zgrid,varstr,data_header)

zcol = strcmpi('z',data_header);
sgcol = strcmpi('glidernum',data_header);
dvcol = strcmpi('divenum',data_header);
varcol = strcmpi(varstr,data_header);
% if sg number is not specified, just use dive number to id
if sum(sgcol) == 0
    diven = data(:,dvcol);
else
    diven = 1e4.*data(:,sgcol)+data(:,dvcol);
end
dives = unique(diven);

nz = length(find(diven == dives(1)));
ndv = length(diven)./nz;

vardata = reshape(data(:,varcol),nz,ndv);
dataout = interp1(data(1:nz,zcol),vardata,zgrid);



% bind = 1;
% tind = [];
% divev = NaN*zeros(size(data,1),1);
% diven = 1;
% 
% 
% nz = length(zgrid);
% 
% %dataout = NaN*zeros(diven*nz,size(data,2));
% 
% while 1
%     tind = find(isnan(data(bind:end,zcol)),1,'first')+bind-2;
%     divev(bind:tind) = diven;
%     if diven == 140
%         debug = 1;
%     end
%     dvout = interp1(data(bind:tind,zcol),data(bind:tind,varcol),zgrid);
%     dataout(:,diven) = dvout;
%     
%     % find start of next prof
%     bind = tind+2;
%     if bind > length(divev)
%         break
%     end
%     diven = diven + 1;
% end



    