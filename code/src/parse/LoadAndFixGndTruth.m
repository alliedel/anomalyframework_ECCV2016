function gt = LoadAndFixGndTruth(fname, pathToGndTruth, nFeats)
% nFeats = size(feats,1);
    [~,fnm,~] = fileparts(fname);
    gt = LoadGndTruth(pathToGndTruth,fnm);
    % Fix ground truth length
    difLength = length(gt) - nFeats;
    if difLength > 0
        gt(1:difLength) = [];
    elseif difLength < 0
        zrs = zeros(1,difLength);
        gt = [zrs(:); gt(:)];
    end
end
