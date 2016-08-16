function an = CalculateAnomalyRatings_write(pars)

% Train and predict across all splits and shuffles
GetWandPrs_write(pars);

% Accumulate over splits
dr = pars.paths.folders.pathToTmp;
an = CombineSummaryFiles_indir(dr, pars);
%[an, as, Ms] = CombineSplitsAndShuffles(pars.paths.files.shufflenames_libsvm, pars);

end
