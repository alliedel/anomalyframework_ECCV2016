function [as,M] = GetAnomScoreFromPrs(prs,ys,splitType)

S = size(ys,1);
n=size(ys,2);
if any(strcmpi({'slidingWindow','slidingWindowOnline'},splitType))
    as.as_1 = NaN(S,n);
    as.as_0 = NaN(S,n);
else
    as = NaN(S,n);
end

% TODO: Uncomment this error msg
% if ~all( (isnan(prs)) == isnan(ys) )
%     error('Broken here!  Probabilities should be defined for every y==1!!\n')
% end

[ind1]=find(ys==1);
[ind0]=find(ys==0);

if any(strcmpi({'slidingWindow','slidingWindowOnline'},splitType))
    as.as_1(ind1) = prs(ind1); % Anomalousness
    as.as_0(ind0) = prs(ind0); % Non-anomalousness %% MATLAB gets sad
%     because this is big.  It can't do this large of an assignment.
else
    M = nanmedian(prs,2);
    as = abs(bsxfun(@minus,prs,M));
end


if any(strcmpi({'slidingWindow','slidingWindowOnline'},splitType))
    M=[];
end

end
