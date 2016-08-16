function MkdirPaths_anomalyDetection(paths)

    dirsToMake = {paths.folders.pathToTmp};
    
    for i = 1:length(dirsToMake)
        if ~exist(dirsToMake{i},'dir')
            if mkdir(dirsToMake{i})
               % fprintf('Made directory %s\n',dirsToMake{i});
            else
                error('mkdir broke.\n')
            end
        end
    end
end
