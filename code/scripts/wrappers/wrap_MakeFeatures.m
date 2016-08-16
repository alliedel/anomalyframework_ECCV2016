function featfile = wrap_MakeFeatures(pars)
%% featfile = wrap_MakeFeatures(pars)
% Will make features so that wrap_DetectAnomalies can run on them.
% pars: structure created by Configure()

%% Get features
if (~exist(pars.paths.files.fn_libsvm,'file') && strcmpi(pars.methodType,'mine')) || ~exist(pars.paths.files.finalFeatMATfile,'file')
    if strcmpi(pars.featType,'mine')
        Wrapper_CreateFinalFeatMATFile(pars);
    elseif strcmpi(pars.featType,'liu')
        Wrapper_CreateFinalFeatMATFile_liu(pars);
    end
end

end
