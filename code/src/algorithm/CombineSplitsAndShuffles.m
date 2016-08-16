function [an, as, Ms] = CombineSplitsAndShuffles(shufflenames_libsvm, pars)


if strcmpi(pars.rawFeatType,'DT')


    S = pars.nShuffles;

    s = 1;
    predictDirectory = fullfile(pars.paths.folders.pathToTmp, sprintf('%d_output',s));
    [~,nm,ext] = fileparts(shufflenames_libsvm{s});
    fnamewildcard = fullfile(predictDirectory,[sprintf('%s*.predict',[nm ext])]);
    fprintf('shuffle %d/%d\r',1,S + 1)
    fnames = dir2cell(fnamewildcard);
    if length(fnames) == 0
      error('Change fnamewildcard.  Yielding no results: %s\n',fnamewildcard)
    end
    % Guess at how big N is based on filenames
    lastfnm = fnames{end};
    lastfnm2 = fnames{end-1};
    loc = strfind(fnamewildcard,'.predict');
    if isempty(loc)
    error('reformat fnamewildcard to hold ''.predict''')
    end

    numstr = lastfnm(loc + (1:8));
    lastnum = sscanf(numstr,'%08d');
    numstr2 = lastfnm2(loc + (1:8));
    lastnum2 = sscanf(numstr2,'%08d');
    N = lastnum + (lastnum2-lastnum);

    [a, M] = combinesplits(fnamewildcard, N);
    as = zeros(S,N);
    as(1,:) = a;
    Ms = zeros(S,length(M));
    Ms(1,:) = M;

    for s = 1 + (1:S)
        fprintf('shuffle %d/%d\r',s,S + 1)
        predictDirectory = fullfile(pars.paths.folders.pathToTmp, sprintf('%d_output',s));
        [~,nm,ext] = fileparts(shufflenames_libsvm{s});
        fnamewildcard = fullfile(predictDirectory,[sprintf('%s*.predict',[nm ext])]);
        fprintf('fnamewildcard: %s\n',fnamewildcard)
        [a, M] = combinesplits(fnamewildcard, N);
        as(s,:) = a;
        Ms(s,:) = M;
    end


    an = nanmean(as,1);

elseif strcmpi(pars.rawFeatType,'cuboidBin')
    S = pars.nShuffles;

    s = 1;
    predictDirectory = fullfile(pars.paths.folders.pathToTmp, sprintf('%d_output',s));
    [~,nm,ext] = fileparts(shufflenames_libsvm{s});
    fnamewildcard = fullfile(predictDirectory,[sprintf('%s*.predict',[nm ext])]);
    fprintf('shuffle %d/%d\r',1,S + 1)
    fnames = dir2cell(fnamewildcard);
    if length(fnames) == 0
      error('Change fnamewildcard.  Yielding no results: %s\n',fnamewildcard)
    end
    % Guess at how big N is based on filenames
    lastfnm = fnames{end};
    lastfnm2 = fnames{end-1};
    loc = strfind(fnamewildcard,'.predict');
    if isempty(loc)
    error('reformat fnamewildcard to hold ''.predict''')
    end

    numstr = lastfnm(loc + (1:8));
    lastnum = sscanf(numstr,'%08d');
    numstr2 = lastfnm2(loc + (1:8));
    lastnum2 = sscanf(numstr2,'%08d');
    N = lastnum + (lastnum2-lastnum);

    [a, M] = combinesplits(fnamewildcard, N);
    as = zeros(S,N);
    as(1,:) = a;
    Ms = zeros(S,length(M));
    Ms(1,:) = M;

    for s = 1 + (1:S)
        fprintf('shuffle %d/%d\r',s,S + 1)
        predictDirectory = fullfile(pars.paths.folders.pathToTmp, sprintf('%d_output',s));
        [~,nm,ext] = fileparts(shufflenames_libsvm{s});
        fnamewildcard = fullfile(predictDirectory,[sprintf('%s*.predict',[nm ext])]);
        fprintf('fnamewildcard: %s\n',fnamewildcard)
        [a, M] = combinesplits(fnamewildcard, N);
        as(s,:) = a;
    end


    an = [];
    Ms = [];
else
    error('I can''t handle the rawFeatType you specified: %s',pars.rawFeatType)
end




end
