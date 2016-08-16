function [parsCell, argsCell, parsCombos] = Configure(opt,fn_libsvm, pathToVideo)
%% [parsCell, argsCell, parsCombos] = Configure(opt)
% opt: string identifier for a batch of experiments to run
% parsCell: cell array of structures, each is the 'pars' for one
%   experiment. length(parsCell) is the number of experiments.
% argsCell: cell array of cell arrays, each is the list of user-set
%   parameters for one experiment.  length(argsCell) is the number of
%   experiments.
% parsCombos: structure whose fields are the parameters set by the user for
% each experiment.  length(parsCombos.lambda) represents the number of
% permutations of lambda used in generating the set of experiments.

parsCombos = struct;

%% List of user-defined parameter combiniations
if strcmpi(opt,'default')
    parsCombos.methodType = 'mine';
    parsCombos.lambda = 10;
    parsCombos.windowSz = 10;
    parsCombos.windowStride = 10;
    parsCombos.anomDetectRoot = '../../';
    parsCombos.nShuffles = {10};
elseif strcmpi(opt,'2016_08_10_avenueredone')
    parsCombos.methodType = 'mine';
    parsCombos.lambda = 10;
    parsCombos.windowSz = 10;
    parsCombos.windowStride = 10;
    parsCombos.anomDetectRoot = '../../';
    parsCombos.nShuffles = {10};
else
    error('Didn''t recognize your configure option opt: %s',opt);
end

% handle videoname
parsCombos.pathToVideo = pathToVideo;
[pth,~,~] = fileparts(pathToVideo);
parsCombos.pathToTrainVideoDir = fullfile(pth,'train');

parsCombos.fn_libsvm = fn_libsvm;

argsCell = GetParameterPermutations(parsCombos);

%% Convert to correct format
parsCell = cell(size(argsCell));
for i = 1:length(argsCell)
    parsScript = ParseScriptArgs(argsCell{i}{:});
    AddToolPaths(parsScript);
    pars = parseArgs_anomalyDetection(argsCell{i}{:});
    pars.parsScript = parsScript;
    parsCell{i} = pars;
%     pause(1); % make sure the temp files are generated at different times
end

end
