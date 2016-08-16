function wrap_DetectAnomalies(pars)
% Features should already be computed.  Will error if false.
% Will call the correct method (ours or competitor's)
assert(exist(pars.paths.files.fn_libsvm,'file')~=0, 'fn_libsvm does not exist: %s', pars.paths.files.fn_libsvm);

%% Anomaly Detection
if ~exist(fullfile(pars.paths.folders.pathToResults,'an'),'file')
    if strcmpi(pars.methodType,'mine')
        anomalyDetect(pars);
    elseif strcmpi(pars.methodType,'liusparse')
        anomalyDetect_liu(pars);
    elseif strcmpi(pars.methodType,'oneclasssvm')
        anomalyDetect(pars);
    else
        error('methodtype %s not implemented',pars.methodType);
    end
    SaveFinalResults(pars);
else
    fprintf('Results file already exists in %s\n',pars.paths.files.resultsfile)
end

end

function SaveFinalResults(pars)
    if ~exist(pars.paths.folders.pathToResults,'dir')
        mkdir(pars.paths.folders.pathToResults)
    end
    cmd = sprintf('cp -r %s/* %s',pars.paths.folders.pathToTmp,pars.paths.folders.pathToResults);
    system(cmd);
    if ~exist(pars.paths.folders.pathToResults,'dir')
        error('the cp command did not work\n');
    else
%        system(sprintf('rm -r %s',pars.paths.folders.pathToTmp));
        if exist(sprintf('%s/1_output',pars.paths.folders.pathToResults),'dir')
%             system(sprintf('rm -r %s/*_output',pars.paths.folders.pathToResults));
        end
%        delete(filesToRemove{:});
        foldersToRemove = dir2cell(fullfile(pars.paths.folders.pathToResults,'*_output'));
        
%         for k = 1:length(foldersToRemove); rmdir(foldersToRemove{k},'s'); end
    end
    if strcmpi(pars.methodType,'oneclasssvm')
        an = dlmread(pars.paths.files.an_python);
    else
        load(fullfile(pars.paths.folders.pathToResults,'an.mat'))
    end
    if pars.frameToBlocks && isempty(findstr(pars.pathToVideo, 'UCSD'))
        system(sprintf('cp -r %s %s',fullfile(pars.paths.folders.pathToResults,'anGrid.mat'), ...
            fullfile(pars.paths.folders.pathToResults,'anGrid.mat')));
    end
    save(fullfile(pars.paths.folders.pathToResults,'pars.mat'),'pars');
end
