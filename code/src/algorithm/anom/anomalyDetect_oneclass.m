function an = anomalyDetect_oneclass(pars)

%% 1. Prepare Features:
% features in pars.paths.files.finalFeatMATfile

%% 2. Run anomaly detection (get scores an for each frame)
% oneclass wrapper here
[~,hostname] = system('hostname');
display(hostname)

runfile = pars.paths.files.runfile;
[pth,nm,ext] = fileparts(pars.paths.files.finalFeatMATfile);
featTxtVsn = fullfile(pth, [nm '.txt']);
if ~exist(featTxtVsn,'file')
    load(pars.paths.files.finalFeatMATfile,'fn');
    csvwrite(featTxtVsn,fn);
end

if any(strcmpi({hostname,hostname(1:end-1),strtrim(hostname)},'speedy3'))
    [pth,nm,ext] = fileparts(pars.paths.files.finalFeatMATfile);
    featTxtVsn = fullfile(pth, [nm '.txt']);
    if ~exist(featTxtVsn,'file')
        load(pars.paths.files.finalFeatMATfile,'fn');
        csvwrite(featTxtVsn,fn);
    end
    featfile = featTxtVsn;
    cmd = sprintf('/usr/bin/python ../src/algorithm/anom/wrapper_online_one_class_svm_nohd5.py %s', ...
        runfile);
elseif any(strcmpi({hostname,hostname(1:end-1),strtrim(hostname)},'del-Precision-M4800'))
    cmd = sprintf('/usr/bin/python ../src/algorithm/anom/wrapper_online_one_class_svm_nohd5.py %s', ...
        runfile);
%     featfile = pars.paths.files.finalFeatMATfile;
    featfile = featTxtVsn;
else
    cmd = sprintf('/home/allie/programFiles/anaconda/bin/python ../src/algorithm/anom/wrapper_online_one_class_svm_nohd5.py %s', ...
        runfile);
%     featfile = pars.paths.files.finalFeatMATfile;
    featfile = featTxtVsn;
end

WriteExecutionFile_oneclass( runfile, ...
    featfile, pars.paths.files.an_python, ...
    pars.nu, pars.lam, pars.eta, pars.t, pars.tau, pars.rho, pars.beta, ...
    pars.alpha, pars.kernel_type, pars.c, pars.d, pars.sigma_ocn, ...
    pars.stopmodelframe);
fprintf('Running command: %s\n',cmd)
system(cmd);
sanitycheck = pars.paths.files.an_python;
if ~exist(sanitycheck, 'file')
    error('the python code didn''t work :( %s not generated\n.',sanitycheck);
end

an = load(pars.paths.files.an_python);

end
