function anomalyDetect_xingStyle(pars)

fprintf('Results file will be in: \n%s\n', pars.paths.files.resultsfile);

%% Load features
[dir,fname,ext] = fileparts(pars.paths.files.cuboidFeatsFile);
pars.paths.files.cuboidAssignmentsFile = fullfile(dir,[fname '_assign' ext]);
if ~exist(pars.paths.files.cuboidAssignmentsFile,'file')

fprintf('Processing cuboid feats: %s...',pars.paths.files.cuboidFeatsFile);
fprintf('Loading feats...\n');
load(pars.paths.files.cuboidFeatsFile,'feats','vidSz');
fprintf('Assigning locs and fn...\n');
locs = feats(:,[1 2 3]);
fn = feats(:,11:end);
if ~strcmpi(class(fn),'single')
    fn = single(fn);
end

[feats_winIdxs, rvals, cvals, tvals] = AssignFeatsToCuboids(vidSz, locs, ...
    pars.cuboidSlideMults, pars.cuboidWindowSz);
fprintf('saving...\n');
save(pars.paths.files.cuboidAssignmentsFile,'feats_winIdxs','rvals','cvals','tvals','fn','locs','-v7.3');
 else
   load(pars.paths.files.cuboidAssignmentsFile,'fn','feats_winIdxs','rvals','cvals','tvals','locs')
end
fprintf('Done.\n');

%% Generate splits
ys = GenerateSplits_slidingCuboids(feats_winIdxs, 'nShuffles', ...
    pars.nShuffles, 'grouping', pars.grouping, 'windowSz', pars.windowSz, ...
    'windowStrideMult',pars.windowStrideMult,'firstRandom', ...
    pars.firstRandom, 'shuffleSize',pars.shuffleSize);

%% Run anomaly detection

[as, ws, prs, w_scores, an, M] = CalculateAnomalyRatings(ys, fn, pars);


%% Save stuff
if(pars.cuboidFeats)
  varsToSave = {'locs','rvals','cvals','tvals'};
 else
varsToSave = {};
end

moreVars = {'pars','an','prs','ws','M','fn','ys','w_scores','as'}; %'feats','feats_winIdxs'
  varsToSave(end:(end + length(moreVars) - 1)) = moreVars;
save(pars.paths.files.resultsfile,varsToSave{:},'-v7.3');


end
