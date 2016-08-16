function GenerateSplits_unshuffled(splitType, S, N, pars, outfile)


if strcmpi('slidingWindowOnline',splitType) %% **** pars.nShuffles, pars.shuffleSize
    stride = round(pars.windowStrideMult*pars.windowSz);
    if mod(pars.windowSz,stride)
        error('stride must be divisible by window sz.  Change windowStrideMult.\n');
    end
    if(stride==0)
        stride = 1;
    end
    intervalStartIdxs = (1:stride:(N-(2*pars.windowSz)+1)) + pars.windowSz;
    intervalEndIdxs=(intervalStartIdxs + pars.windowSz - 1);
    nIntervals = length(intervalStartIdxs);
    if nIntervals < 1
        error('Window size should be < %d == # of frames.\n',N);
    end
    S = nIntervals;
    ys = NaN(S,N); % S is now # splits per shuffle
    for i = 1:length(intervalStartIdxs)
        % Fill interval with half zeros, then half ones.
        ys(i,intervalStartIdxs(i):intervalEndIdxs(i)) = 1;
        ys(i,1:(intervalStartIdxs(i)-1)) = 0;
    end
    
else
    error('Split Type not found.\n');
end
ys = single(ys);
save(outfile, 'ys','-v7.3')

end
