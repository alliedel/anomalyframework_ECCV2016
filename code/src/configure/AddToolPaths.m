function AddToolPaths(parsScript)
%% Add OpenCV Library Path and VLfeat and MATLAB gentools
srcloc = fullfile(parsScript.anomDetectRoot,'code','src');
wrappersloc = fullfile(parsScript.anomDetectRoot,'code','scripts','wrappers');
assert(exist(srcloc,'dir')~=0,'anomDetectRoot is incorrect: %s should exist',srcloc);
addpath(genpath(srcloc));
addpath(genpath(wrappersloc));
assert(exist(parsScript.pathToTrainPredict,'file')~=0,'parsScript.pathToTrainPredict does not exist: %s', parsScript.pathToTrainPredict);
system(sprintf('export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:%s',parsScript.LD_LIBRARY_PATH),'-echo');

end
