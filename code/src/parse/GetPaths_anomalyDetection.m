function [paths] = GetPaths_anomalyDetection(pars)

% In case we're running this for debugging
% if eval('pars.argsString')
%    pars.argsString = '';
%    warning('argsString not set; hopefully you''re not running fullRun.m and you''re just debugging.');
% end

% Some preliminary stuff (non-technical)
[pth,name,~] = fileparts(pars.pathToVideo);

% Get tags
tags = GetTags_anomalyDetection(pars);

% Stitch tags as pathnames
paths = StitchNames(tags, pars);
paths.tags = tags;

% Save some etc stuff
paths.files.pathToVideo = pars.pathToVideo;
paths.name = name;

% Overwrite with user paths if they input them
paths = ReplaceSpecifiedPaths(pars, paths);

% Convert to absolute paths
f = fieldnames(paths.files);
for fi = 1:length(f)
    paths.files.(f{fi}) = AbsolutePath(paths.files.(f{fi}));
end
f = fieldnames(paths.folders);
for fi = 1:length(f)
    paths.folders.(f{fi}) = AbsolutePath(paths.folders.(f{fi}));
end

end

function paths = ReplaceSpecifiedPaths(pars, paths)

fnames = fieldnames(paths.folders);
for i = 1:length(fnames)
    if isfield(pars,fnames{i}) && ~isempty(pars.(fnames{i}))
        paths.folders.(fnames{i}) = pars.(fnames{i});
    end
end

fnames = fieldnames(paths.files);
for i = 1:length(fnames)
    if isfield(pars,fnames{i}) && ~isempty(pars.(fnames{i}))
        paths.files.(fnames{i}) = pars.(fnames{i});
    end
end

end
