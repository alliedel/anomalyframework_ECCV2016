function [FPx, TPy] = getROCcurve(an, gndTruth, skipevery)

if ~exist('skipevery','var')
    skipevery = 1;
end

%% Check inputs
if size(an,2) ~= 1
    if size(an,1) == 1
        an = an';
    else
        error('an must be a vector');
    end
end

if size(gndTruth,2) ~= 1
    if size(gndTruth,1) == 1
        gndTruth = gndTruth';
    else
        error('an must be a vector');
    end
end

if length(an) ~= length(gndTruth)
    error('length(an) must equal length(gndTruth)');
end

%% Get ROC curve
% Make ground truth binary
gndTruth(gndTruth > 0) = 1;

% Sort an by value; keep idxs.
[Y,I] = sort(an,'descend');

totTrue = sum(gndTruth~=0);
totFalse = sum(gndTruth==0);

i = 0;
thresh = NaN;
for jj=1:skipevery:length(Y)
    if thresh==Y(jj)
        continue;
    end
    i=i+1;
    thresh = Y(jj);
    myLbls = an >= thresh;
    TP = sum((myLbls) & (gndTruth));
    FP = sum((myLbls) & (~gndTruth));
    TPy(i) = TP/totTrue;
    FPx(i) = FP/totFalse;
end


end
