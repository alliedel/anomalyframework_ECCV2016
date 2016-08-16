function GenerateSplit_write(splitType, S, N, pars, outfile)

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
    S=nIntervals*(pars.nShuffles + 1);
    ys = NaN(S,N); % S is now # splits per shuffle
%     fprintf('First loop\n');
    for i = 1:length(intervalStartIdxs)
%         startidx1 = startidx0 + ;
        % Fill interval with half zeros, then half ones.
        ys(i,intervalStartIdxs(i):intervalEndIdxs(i)) = 1;
        ys(i,1:(intervalStartIdxs(i)-1)) = 0;
    end
    
    % Shuffle frames and reassign labels
    for j = 1:pars.nShuffles
        
        if isnumeric(pars.shuffleSize)
            if pars.shuffleSize==0
                error('please specify a nonzero integer for the shuffleSize parameter');
            end
           randIdxs = BlockShuffle(N,pars.shuffleSize); % Shuffle the frames.  Then grab the intervals:
                for i = 1:(nIntervals)
                    splitIdx = j*nIntervals + i;
            %         startidx1 = startidx0 + ;
                    % Fill interval with half zeros, then half ones.
                    ys(splitIdx,randIdxs( intervalStartIdxs(i):intervalEndIdxs(i))) = 1;
                    ys(splitIdx,randIdxs( 1:(intervalStartIdxs(i)-1) ) ) = 0;
                end
        else
            error('shuffleSize not recognized\n');
        end
        
    end
    
else
    error('Split Type not found.\n');
end

save(outfile,'ys','-v7.3');

end
