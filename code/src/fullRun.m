function pars = fullRun( args, scriptArgs)
%FULLRUN Detect anomalies on video
%   Calculates dense trajectory features and uses a variant of density
%   ratio estimation to rate the anomalousness of each frame.

%% Parse inputs and add paths
parsScript = ParseScriptArgs(scriptArgs{:});
AddToolPaths(parsScript);
pars = parseArgs_anomalyDetection(args{:});
pars.parsScript = parsScript; clear parsScript;

%% Get features
if (~exist(pars.paths.files.fn_libsvm,'file') && strcmpi(pars.methodType,'mine')) || ~exist(pars.paths.files.finalFeatMATfile,'file')
    Wrapper_CreateFinalFeatMATFile(pars);
end

if pars.rawFeatsOnly || pars.finalFeatsOnly
   return;
end

%% Anomaly Detection
if ~exist(fullfile(pars.paths.folders.pathToResults,'an'),'file')
    anomalyDetect(pars);
    SaveFinalResults(pars);
else
    fprintf('Results file already exists in %s\n',pars.paths.files.resultsfile)
end

end

function SaveFinalResults(pars)
    cmd = sprintf('cp -r %s/* %s',pars.paths.folders.pathToTmp,pars.paths.folders.pathToResults);
    system(cmd);
    if ~exist(pars.paths.folders.pathToResults,'dir')
        error('the mv command did not work\n');
    else
        system(sprintf('rm -r %s',pars.paths.folders.pathToTmp));
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
