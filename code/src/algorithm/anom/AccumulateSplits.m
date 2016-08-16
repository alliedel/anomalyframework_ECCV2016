function an = AccumulateSplits(avgOverSplits,as)

% if strcmpi('slidingWindow',pars.splitType)
if isstruct(as)
    if strcmpi('mean',avgOverSplits)
        an = nanmean(as.as_1,1);
    elseif strcmpi('median',avgOverSplits)
        an = nanmedian(as.as_1,1);
    else
        error('Invalid averaging argument');
    end
else
    if strcmpi('mean',avgOverSplits)
        an = nanmean(as,1);
    elseif strcmpi('median',avgOverSplits)
        an = nanmedian(as,1);
    else
        error('Invalid averaging argument');
    end
end

end
