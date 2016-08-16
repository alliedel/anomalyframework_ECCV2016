function [as, ws, prs, w_scores, an, M, weights] = CalculateAnomalyRatings(bin_ys,m_fn,pars)


% Calculated parameters
% S = whos(m_ys,'ys').size(1);
S = countLines(bin_ys);

% Get classifier and scores
% fn(isnan(fn)) = 0;
% weights = GenerateRegressionWeights(ys,pars);
[ws, prs, w_scores] = GetWandPrs(m_ys,m_fn,pars);
ws = single(ws);
prs = single(prs);
w_scores = single(w_scores);
% Get anomaly score per split
[as,M] = GetAnomScoreFromPrs(prs,ys,pars.splitType);

% Accumulate over splits
an = AccumulateSplits(pars.avgOverSplits,as);

if(0) % Debug figure
    i = 3; figure(2); subplot(2,1,1); area(an(:)); subplot(2,1,2); area(ys{i});
end

end
