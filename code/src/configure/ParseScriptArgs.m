function parsScript = ParseScriptArgs(varargin)

p = inputParser;

p.addOptional('LD_LIBRARY_PATH','');
p.addOptional('anomDetectRoot','../../');
p.addOptional('vlfeatPath', ...
    'code/src/externaltools/vlfeat/toolbox/vl_setup.m');
p.addOptional('pathToTrainPredict', ...
    'code/src/externaltools/liblinear-alliemodified/allie');
p.addOptional('dtPath', ...
    'code/src/externaltools/dense_trajectory_release_v1.2/');

p.KeepUnmatched = true;
parse(p,varargin{:});
parsScript = p.Results;

fnames = {'vlfeatPath','dtPath','pathToTrainPredict'};
for s = 1:length(fnames)
    fnm = fnames{s};
    parsScript.(fnm) = fullfile(parsScript.anomDetectRoot, parsScript.(fnm));
end

end
