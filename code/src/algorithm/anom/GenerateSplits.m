function GenerateSplits(splitType, S, N, pars, outfile)

%% Yuichi splits
if strcmpi('yuichi',splitType)
    if  N/(2^(S/2)) < 1 % Chunk length must be >= 1
        % 2^S = N
        S = 2*floor(log2(N));
    end
    ys = NaN(S,N);
    for i = 1:S/2
        chunkLength = N/(2^i);
        chunk = [ones(1,chunkLength) zeros(1,chunkLength)];
        vec = repmat(chunk,[1,ceil(N/length(chunk))]);
        vec = vec(1:N);
        ys(2*i-1,:) = vec(1:N);
        ys(2*i,:) = 1-ys(2*i-1,:);
    end
    
elseif strcmpi('partRandom',splitType)
    randIdxs = randperm(N);
    ys = NaN(S,N);
    for i = 1:S/2
        chunkLength = N/(2^i);
        chunk = [ones(1,chunkLength) zeros(1,chunkLength)];
        ys(1,randIdxs(1:N/2)) = 1; % 1st half
        vec = repmat(chunk,[1,ceil(N/(2*chunkLength))]);
        vec = vec(1:N) > 0;
        ys(2*i-1,:) = zeros(N,1);
        ys(2*i-1,randIdxs(vec)) = 1;
        ys(2*i,:) = 1-ys(2*i-1,:);
    end
%     ys{3}(randIdxs((1:N <= N/4) | (1:N > N/2 & 1:N <= 3*N/4))) = 1; % 1st and 3rd quarters

elseif strcmpi('random',splitType)
    ys = NaN(S,N);
    for i = 1:2:S
        ys(i,:) = zeros(N,1);
        randIdxs = randperm(N);
        ys(i,randIdxs(1:N/2)) = 1; % 1st half
        ys(i+1,:) = 1-ys(i,:); % 2nd half
    end
elseif strcmpi('slidingWindow',splitType) %% **** pars.S is unused here.  S is chosen to cover entire video with a given stride.
    stride = round(pars.windowStrideMult*pars.windowSz);
    winStartIdxs = 1:stride:(N-pars.windowSz);
    pars.S = length(winStartIdxs);
    if pars.S < 1
        error('Window size should be < %d == N.\n',N);
    end
    ys = NaN(S,N);
    for i = 1:(pars.S)
        startidx = winStartIdxs(i);
        ys(i,:) = zeros(N,1);
        ys(i,startidx:(startidx+pars.windowSz-1)) = 1;
    end
elseif strcmpi('slidingWindowOnlineOld',splitType) %% **** pars.nShuffles, pars.shuffleSize
    stride = round(pars.windowStrideMult*pars.windowSz);
    intervalLabels = [zeros(pars.windowSz,1); ones(pars.windowSz,1)];
    intervalStartIdxs = 1:stride:(N-length(intervalLabels)+1);
    nIntervals = length(intervalStartIdxs);
    if nIntervals < 1
        error('Window size should be < %d == N.\n',N);
    end
    ys = NaN(nIntervals*(pars.nShuffles),N); % S is now # splits per shuffle
    ys_unshuffled = NaN(S,N);
    for i = 1:(nIntervals)
%         startidx1 = startidx0 + ;
        ys_unshuffled(i,:) = NaN*ones(N,1); % Initialize to NaNs
        % Fill interval with half zeros, then half ones.
        ys_unshuffled(i,intervalStartIdxs(i):(intervalStartIdxs(i) + length(intervalLabels)-1)) = intervalLabels;
    end
    ys(1:length(ys_unshuffled)) = ys_unshuffled;
    
    % Shuffle frames and reassign labels
    for j = 1:pars.nShuffles
        
        if isnumeric(pars.shuffleSize)
            [randIdxs,~]=BlockShuffle(N, pars.shuffleSize); % Shuffle the frames.  Then grab the intervals:
            for i = 1:(nIntervals)
                splitIdx = j*nIntervals + i;
        %         startidx1 = startidx0 + ;
                ys(splitIdx,:) = NaN*ones(N,1); % Initialize to NaNs
                % Fill interval with half zeros, then half ones.
                ys(splitIdx,randIdxs( intervalStartIdxs(i):(intervalStartIdxs(i) + length(intervalLabels)-1))) = intervalLabels;
            end
            
        elseif strcmpi(pars.shuffleSize, 'interval')
%             shuffleSize = length(intervalLabels);
        elseif strcmpi(pars.shuffleSize, 'window')
%             shuffleSize = pars.windowSz;
              
                error('shuffle method not yet implemented\n');
        else
            error('shuffleSize not recognized\n');
        end
    end

elseif strcmpi('slidingWindowOnline',splitType) %% **** pars.nShuffles, pars.shuffleSize
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
ys = single(ys);
save(outfile, 'ys','-v7.3')

end
