function [ gndtruth ] = LoadGndTruth( pathToGndTruth, fname )
DENSETRAJ_DELAY=14;

if ~exist(pathToGndTruth,'dir')
    warning('Ground truth file doesn''t exist\n');
    gndtruth = [];
    return;
end

outfile=fullfile(pathToGndTruth, [fname '_gt.txt']);

if existAndNotEmpty(outfile)
%     of = fopen(outfile,'r'); %'rb'
%     gndtruth = fread(of);
%     fclose(of);
    gndtruth=dlmread(outfile);
    if exist('gndtruth','var')
        return;
    end
end

fprintf('Compiling ground truth from users...\n')

fn=fullfile(pathToGndTruth,[fname '.avi']);
for i=1:15
    number=num2str(i);
    wp=strcat('_p',number);wp=strcat(wp,'.txt');
    fnn=strcat(fn,wp);a=load(fnn);
    if i==1
        ave=a;
    else
        g=a+ave;
    end
end
gndtruth = g((1+DENSETRAJ_DELAY):end);

%of = fopen(outfile,'wb'); % 'wb'
% fwrite(of,gndtruth);
% fclose(of);
dlmwrite(outfile,gndtruth);
end

