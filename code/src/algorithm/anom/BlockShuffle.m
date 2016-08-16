function [randIdxs,blockMat]=BlockShuffle(Y, blockSz)
% N=# things to shuffle
N = max(Y);
if blockSz==1
    N = length(Y);
    randFrms = randperm(N);
    blockMat=1:N;
    randIdxs = randFrms;
else
    nBlocks=floor(N/blockSz);
    blockMat=reshape(1:blockSz*nBlocks,blockSz,nBlocks);
    if N~=(blockSz*nBlocks) % not evenly divisible
        leftoverBlock=(blockSz*nBlocks+1):N;
        nBlocks=nBlocks+1;
        blockMat(:,end+1)=NaN;
        blockMat(1:length(leftoverBlock),end)=leftoverBlock;
    end
    randBlocks = randperm(nBlocks);
    randFrms=reshape(blockMat(:,randBlocks),1,[]);
    randFrms(isnan(randFrms))=[];

    randIdxs = zeros(size(Y));
    j = 1;
    for i = 1:N
        Ys_that_equal_rndi = find(Y == randFrms(i));
        n_locs = length(Ys_that_equal_rndi);
        randIdxs(j:(j+n_locs-1)) = Ys_that_equal_rndi;
        j = j + n_locs;
    end
end


end
