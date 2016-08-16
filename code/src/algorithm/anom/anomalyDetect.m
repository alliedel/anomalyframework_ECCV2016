function anomalyDetect(pars)
% anomalyDetect(pars)
% Wrapper; handles the framesToGrid case and the various method types
% INPUTS
%   pars : 
%       methodType = {'mine','oneclasssvm'}
%   

if strcmpi(pars.methodType,'mine')
    an = anomalyDetect_write(pars);
elseif ~strcmpi(pars.ScoreEach,'frame')
    error('I can only handle scoreeach frame with methods that aren''t mine\n');
elseif strcmpi(pars.methodType, 'oneclasssvm')
    an = anomalyDetect_oneclass(pars);
else
    error('I don''t recognize your method type');
end

if pars.frameToBlocks && isempty(findstr(pars.pathToVideo,'UCSD'))% 
    % accompany anGrid with the r,c,t locations in the image
    anGrid = an; clear an;
    if isempty(pars.videoSize)
        [M,N,T] = GetVideoSize(pars.pathToVideo);
        videoSize = [M,N,T];
    else
        videoSize = pars.videoSize;
    end
    center = 0;
    [rct, ~] = GridToFrames(1:length(anGrid), pars.blockSize, ...
        pars.blockStride, videoSize, center);
    [rstart,cstart,tstart, sz] = ComputeGridStartLocsAndSz(pars.blockSize, pars.blockStride, videoSize); %#ok<ASGLU>
    save(fullfile(pars.paths.folders.pathToTmp,'anGrid.mat'),'rct', 'rstart','cstart','tstart','sz','anGrid');
    
    an_max = anGridToAn(anGrid,rct,tstart,sz(3),videoSize(3),@max);
    an_mean = anGridToAn(anGrid,rct,tstart,sz(3),videoSize(3),@mean);
    an = an_mean;
    save(fullfile(pars.paths.folders.pathToTmp,'an.mat'),'an','an_max','an_mean');
else
    save(fullfile(pars.paths.folders.pathToTmp,'an.mat'),'an');
end

end
