function an = anomalyDetect_write(pars)

% 1. Prepare Features: Convert to LibSVM, Shuffle, and Save
GenerateAndSaveShufflesVersions(pars);

% 2. Run anomaly detection (get scores an for each frame)
an = CalculateAnomalyRatings_write(pars);

end


function GenerateAndSaveShufflesVersions(pars)

% Get first (non-)shuffle
fn_libsvm = pars.paths.files.fn_libsvm;
N = GetNFromLibSVM(fn_libsvm);
i = 1;
system(sprintf('cp %s %s',fn_libsvm, pars.paths.files.shufflenames_libsvm{i}));
randIdxs = 1:N;
save(pars.paths.files.shuffleidxs{i},'randIdxs');

% Get rest of shuffles
fprintf('Generating shuffles\n')
[Y,X] = libsvmread(fn_libsvm);
N = max(Y);
for i = 1 + (1:pars.nShuffles)
    randIdxs = BlockShuffle(Y,pars.shuffleSize); % Shuffle the frames.  Then grab the intervals:
%     randIdxs = BlockShuffle(N,pars.shuffleSize); % Shuffle the frames.  Then grab the intervals:
    fprintf('\rShuffling file lines %d/%d',i-1,(pars.nShuffles))
    libsvmwrite(pars.paths.files.shufflenames_libsvm{i}, Y(randIdxs), sparse(X(randIdxs,:)));
    save(pars.paths.files.shuffleidxs{i},'randIdxs');
end

end

function N = GetNFromLibSVM(fn_libsvm) % Hacky quick system way to do it
    [res,stat] = system(sprintf('awk ''END {print NR}'' %s',fn_libsvm),'-echo');
    [A, count] = sscanf(stat, '%d');
    if isempty(A)
        As = regexp(stat, '[\f\n\r]', 'split');
        if isempty(As{end})
            As(end) = [];
        end
        [A, count] = sscanf(As{end},'%d');
    end
    stat = A(end);
    if isempty(stat)
        error('Got an empty line from fn_libsvm!\n')
    end
    if ischar(stat)
        N = str2double(stat);
    else
        N = stat;
    end
    if isnan(N)
        error('Couldn''t get N from the file!\n');
    end
end
