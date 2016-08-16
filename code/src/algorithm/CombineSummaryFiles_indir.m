function a = CombineSummaryFiles_indir(timefoldername, pars)
if ~exist('pars','var')
load(fullfile(timefoldername,'pars.mat'));
end
S = 1 + pars.nShuffles;
for i = 1:S
	  load(fullfile(timefoldername,sprintf('%d_output',i),'summary.txt'));
if i == 1
  a = zeros(max(summary(:,1)),1);
  a(summary(:,1),:) = 1/S * summary(:,5);
 else
   a(summary(:,1)) = a(summary(:,1)) + 1/S * summary(:,5);
end

end
