function paths = StitchNames(tags, pars)

% - features
paths = StitchFeatureNames(tags, pars);

% - inputs: video, groundtruth
[pth,name,~] = fileparts(pars.pathToVideo); [~,collection,~] = fileparts(pth);
paths.name = name;
paths.folders.pathToGndTruth = fullfile(pars.anomDetectRoot,sprintf('data/input/groundTruth/%s/%s/',collection,name));

% - algorithm (intermediate files)
paths.folders.pathToTmp = fullfile(pars.anomDetectRoot,sprintf('data/tmp/%s/%s_%s_%s/',...
    tags.datestring,tags.timestring, name, pars.processId));

if strcmpi(pars.methodType,'mine')
    filesPerShuffle = {
        'shufflenames_libsvm', ...
        'shuffleidxs', ...
        'runinfo_fnames', ...
        'donefiles', ...
        'verboseFnames'};
    foldersPerShuffle = {
        'predictDirectories', ...
        };
    fileStrSprintfPerShuffle = {
        [paths.name, '_%03d.train'] ...
        'randIdxs_%d' ...
        '%d.runinfo' ...
        '%d_done' ...
        '%d_verbose'
        };
    folderStrSprintfPerShuffle = {
        '%d_output/' ...
        };
    S = (pars.nShuffles + 1);
    for fs = 1:length(filesPerShuffle)
        paths.files.(filesPerShuffle{fs}) = cell(1,S);
        for s = 1:S
            paths.files.(filesPerShuffle{fs}){s} = fullfile(paths.folders.pathToTmp, sprintf(fileStrSprintfPerShuffle{fs},s));
        end
    end
    for fs = 1:length(foldersPerShuffle)
        paths.folders.(foldersPerShuffle{fs}) = cell(1,S);
        for s = 1:S
            paths.folders.(foldersPerShuffle{fs}){s} = fullfile(paths.folders.pathToTmp, sprintf(folderStrSprintfPerShuffle{fs},s));
        end
    end
elseif strcmpi(pars.methodType,'oneclasssvm')
    paths.files.runfile = fullfile(paths.folders.pathToTmp,'oneclass.runinfo');
    paths.files.an_python = fullfile(paths.folders.pathToTmp,'a.txt');
elseif strcmpi(pars.methodType,'liusparse')
    paths.files.liusparsedictionary = fullfile(pars.pathToTrainVideoDir, ...
        sprintf('dictionary%s%s%s.mat', tags.liufeats, tags.liuPCA, ...
        tags.liusparsedictionary));
    
else
    error('I don''t recognize this methodType: %s\n',pars.methodType)
end

% - results
paths.folders.pathToResults = fullfile(pars.anomDetectRoot,['data/results/' tags.datestring '/' tags.timestring, '/'], tags.resultsnm);
% Handle case if two pars files are generated at the same second
tmp = paths.folders.pathToResults;
cnt = 2;
while exist(paths.folders.pathToTmp,'dir')
    paths.folders.pathToTmp = [tmp '_' num2str(cnt)];
    cnt = cnt + 1;
end
paths.files.an_file = fullfile(paths.folders.pathToTmp, ...
    'a_res.mat');

end

function paths = StitchFeatureNames(tags, pars)
% sets intermediates as well as:
%   folders.pathToFeats
%   files.rawFeatMATFile
%   files.finalFeatsFile
%   files.fn_libsvm

% - features
[pth,name,~] = fileparts(pars.pathToVideo);
[~,collection,~] = fileparts(pth);
paths.folders.pathToFeats = fullfile(pars.anomDetectRoot,['data/input/features/' collection '/' name '/']);

if strcmpi(pars.featType,'mine')
    % -- raw features
    paths.files.rawFeatMATfile = fullfile(paths.folders.pathToFeats,sprintf('%s%s.mat',name,tags.rawfeats));

    % --- DT
    if strcmpi(pars.rawFeatType,'DT')
        paths.files.dt_Txtfile = fullfile(paths.folders.pathToFeats,sprintf('%s%s.txt',name,tags.dtOutStr));
        paths.files.dt_MATfile = fullfile(paths.folders.pathToFeats,sprintf('%s%s.mat',name,tags.dtOutStr));
        paths.files.rawFeatMATfile = fullfile(paths.folders.pathToFeats,sprintf('%s%s.mat',name,tags.rawfeats));

    % --- cuboidDT
    elseif strcmpi(pars.rawFeatType, 'cuboidDT')
        paths.files.rawFeatGzfile = fullfile(paths.folders.pathToFeats,sprintf('%s%s.gz',name,tags.rawfeats));
        paths.files.rawFeatTxtfile = fullfile(paths.folders.pathToFeats,sprintf('%s%s.txt',name,tags.rawfeats));
        paths.files.rawFeatMATfile = fullfile(paths.folders.pathToFeats,sprintf('%s%s.mat',name,tags.rawfeats));
        cuboidDTFeatsFile = fullfile(paths.folders.pathToFeats, ...
            [tags.rawfeats '.mat']);
        paths.files.rawFeatMATFile = cuboidDTFeatsFile;

    % --- cuboid
    elseif strcmpi(pars.rawFeatType, 'cuboidBin')
        cuboidRaw = fullfile(paths.folders.pathToFeats, ...
            sprintf('%s%s.mat',name,tags.rawfeats));
        paths.files.rawFeatMATfile = cuboidRaw;
    end
    % -- post processed features
    % --- whitened
    paths.files.whiteningParsfile = fullfile(paths.folders.pathToFeats, ...
        sprintf('%s%s%s_pars.mat',name,tags.rawfeats,tags.whiteparsstring));
    paths.files.rawFeatWhiteMATfile_test = fullfile(paths.folders.pathToFeats, ...
        sprintf('%s%s_whitened_%s%s%s.mat',name,tags.rawfeats,name,tags.rawfeats,tags.whiteparsstring));
    % --- BOV
    paths.files.dictionaryMATfile = fullfile(paths.folders.pathToFeats, ...
        sprintf('%s%s%s%s.mat',name,tags.rawfeats,tags.whiteparsstring,tags.kmeansparsstring));
    paths.files.BOVMATfile = fullfile(paths.folders.pathToFeats, ...
        sprintf('%s%s%s%s%s.mat',name,tags.rawfeats,tags.whiteparsstring,tags.kmeansparsstring,tags.BOVparsstring));

    % -- final features ([fn] or [fn,locs])
    if strcmpi(pars.ScoreEach, 'interestpoint')
        paths.files.finalFeatMATfile = fullfile(paths.folders.pathToFeats, ...
            sprintf('%s%s%s%s%s_fn.mat',name,tags.rawfeats,tags.whiteparsstring,tags.normHist,'STIPs'));
    else
        paths.files.finalFeatMATfile = fullfile(paths.folders.pathToFeats, ...
            sprintf('%s%s%s%s%s_fn.mat',name,tags.rawfeats,tags.whiteparsstring,tags.kmeansparsstring,tags.BOVparsstring));
    end
elseif strcmpi(pars.featType,'liu')
    % -- Training features
    paths.folders.pathToTrainVideoDir = pars.pathToTrainVideoDir;
    paths.files.liu_trainFeats = fullfile(pars.pathToTrainVideoDir, ...
        sprintf('train%s.mat', tags.liufeats));
    paths.files.liu_trainFeatsPCA = fullfile(pars.pathToTrainVideoDir, ...
        sprintf('train%s%s.mat', tags.liufeats, tags.liuPCA));
    
    % -- PCA mat file : saved with training features
    paths.files.liu_Tw = fullfile(paths.folders.pathToTrainVideoDir, ...
        sprintf('Tw%s%s.mat', tags.liufeats, tags.liuPCA));

    % -- Test features
    paths.files.liu_testFeats = fullfile(paths.folders.pathToFeats, ...
        sprintf('%s%s.mat',name,tags.liufeats));
    paths.files.liu_testFeatsPCA = fullfile(paths.folders.pathToFeats, ...
        sprintf('%s%s%s.mat',name,tags.liufeats,tags.liuPCA));
    
    % -- final features ([fn] or [fn,locs])
    paths.files.finalFeatMATfile = paths.files.liu_testFeatsPCA;
    
else
    error('featType not recognized: %s',pars.featType);
end

[pth,nm,~] = fileparts(paths.files.finalFeatMATfile);
paths.files.fn_libsvm = fullfile(pth,[nm '.train']);

end
