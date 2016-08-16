function ys = GenerateSplits_slidingCuboids(feats_winIdxs, varargin)

p = inputParser;
p.addOptional('nShuffles', 0);
p.addOptional('grouping', '');
p.addOptional('windowSz',1);
p.addOptional('windowStrideMult',0.5);
p.addOptional('firstRandom',0);
p.addOptional('shuffleSize',1);

p.parse(varargin{:});
pars = p.Results;

N = size(feats_winIdxs,1);

stride = round(pars.windowStrideMult*pars.windowSz);
if mod(pars.windowSz,stride)
    error('stride must be divisible by window sz.  Change windowStrideMult.\n');
end
if(stride==0)
    stride = 1;
end



if any(strcmpi(pars.grouping, {'', 'none'}))

    intervalStartIdxs = (1:stride:(N-(2*pars.windowSz)+1)) + pars.windowSz;
    nIntervals = length(intervalStartIdxs);
    if nIntervals < 1
        error('Window size should be < %d == # of cuboids.\n',N);
    end
    
    if(~pars.firstRandom)
        S=nIntervals*(pars.nShuffles + 1);
        ys = NaN(S,N);
        for i = 1:length(intervalStartIdxs)
            ys(i,1:(intervalStartIdxs(i)-1)) = 0;
            ys(i,intervalStartIdxs(i) + (0:(pars.windowSz - 1))) = 1;
        end
    else
        S = nIntervals*(pars.nShuffles);
        ys = NaN(S,N);
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

                % Fill interval with half zeros, then half ones.
                ys(splitIdx,randIdxs( 1:(intervalStartIdxs(i)-1) ))  = 0;
                ys(splitIdx,randIdxs( intervalStartIdxs(i) + (0:(pars.windowSz - 1)))) = 1;
            end
        else
            error('shuffleSize not recognized\n');
        end
        
    end

    
elseif strcmpi(pars.grouping, 'byFrame') 
    
    uniqueTs = unique(feats_winIdxs(:,3));
    uniqueTs(uniqueTs == 0) = [];
    T = length(uniqueTs);
    
    intervalStartIdxs = (1:stride:(T-(2*pars.windowSz)+1)) + pars.windowSz;
    nIntervals = length(intervalStartIdxs);
    if nIntervals < 1
        error('Window size should be < %d == # of frames (as defined by cuboids).\n',T);
    end
    
    if(~pars.firstRandom)
        S = nIntervals*(pars.nShuffles + 1);
        ys = NaN(S,N);
        for i = 1:length(intervalStartIdxs)
            ys(i, ismember(feats_winIdxs(:,3), uniqueTs(1:(intervalStartIdxs(i)-1)))) = 0;
            ys(i, ismember(feats_winIdxs(:,3), uniqueTs(intervalStartIdxs(i) + (0:(pars.windowSz - 1))))) = 1;
        end
    else
        S = nIntervals*(pars.nShuffles);
        ys = NaN(S,N);
    end
    
    % Shuffle frames and reassign labels
    for j = 1:pars.nShuffles
        
        if isnumeric(pars.shuffleSize)
            if pars.shuffleSize==0
                error('please specify a nonzero integer for the shuffleSize parameter');
            end
            if pars.shuffleSize ~= 1
                error('I haven''t correctly implemented non-1 shuffle sizes');
            end
            randIdxs = BlockShuffle(T, pars.shuffleSize); % Shuffle the frames.  Then grab the intervals:
            for i = 1:(nIntervals)
                splitIdx = j*nIntervals + i;

                % Fill interval with half zeros, then half ones.
                ys(splitIdx,ismember(feats_winIdxs(:,3), randIdxs( uniqueTs(1:(intervalStartIdxs(i)-1) )) ) ) = 0;
                ys(splitIdx,ismember(feats_winIdxs(:,3), randIdxs( uniqueTs(intervalStartIdxs(i) + (0:(pars.windowSz - 1)))))) = 1;
            end
        else
            error('shuffleSize not recognized\n');
        end
        
    end
    
else
    error('grouping method %s not understood',grouping);
    
end


end
