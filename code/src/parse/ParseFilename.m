function [names,vals]=ParseFilename(filename,fname_vid)
% Return all parameters after the filename
[pth,filename,ext]=fileparts(filename); % Get rid of folder name, extension
fnameIdxs=findstr(filename,fname_vid);
rem=filename;
rem(fnameIdxs(1):length(fname_vid))=[];

tokens={};
while(~isempty(rem))
    [token,rem]=strtok(rem,'_');
    tokens{end+1}=token;
end

names=tokens(1:2:end)';
vals=tokens(2:2:end)';

end
