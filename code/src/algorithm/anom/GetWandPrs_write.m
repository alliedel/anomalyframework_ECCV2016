function GetWandPrs_write(pars) % We assume each row is a feature.

% == Parameters
% small c : Regularize more
c=1/pars.lambda;
solverNum = 0; %7; % 0
fn_shuffle_filenames = pars.paths.files.shufflenames_libsvm;
S = length(fn_shuffle_filenames);

%myCluster = parcluster();
%matlabpool('open',min(S,myCluster.NumWorkers))

fprintf('\n');
for s = 1:S
	fprintf('Evaluating shuffle %d/%d\r',s,S);
    WriteExecutionFile_allieTrainPredict(pars.paths.files.runinfo_fnames{s}, ...
        fn_shuffle_filenames{s}, pars.paths.folders.predictDirectories{s}, ...
					 solverNum, c, pars.windowSz, pars.windowStride, pars.numThreads)
    mkdir(pars.paths.folders.predictDirectories{s});
    
    cmd=sprintf('rm -f %s; ./%s %s >> %s; echo Done! >> %s &', ...
        pars.paths.files.donefiles{s}, ...
        pars.parsScript.pathToTrainPredict, ...
        pars.paths.files.runinfo_fnames{s}, ...
        pars.paths.files.verboseFnames{s}, ...
        pars.paths.files.donefiles{s});
    [stat,res] = system(cmd,'-echo');
end

%matlabpool('close')

for s = 1:S
    donefile = pars.paths.files.donefiles{s};
    while(~exist(donefile,'file'))
        pause(1)
    end
    fprintf('Shuffle %d done.\n',s);
end

sanitycheck = fullfile(pars.paths.folders.pathToTmp,'1_output/summary.txt');
if ~exist(sanitycheck,'file'); 
    fprintf('example command line: %s\n',cmd);
    error(['The C code didn''t work.  It''s possible you didn''t compile the code in %s.' ...
        'Check %s for details or try running the above command from terminal.'], ...
        pars.parsScript.pathToTrainPredict,fullfile(pars.paths.folders.pathToTmp,'1_verbose'));
end


end
