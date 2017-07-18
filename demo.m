d=pwd();
try
  cd code/scripts
  tic;
  run runscript.m
  t=toc;
  fprintf('Demo success! Took %.3g seconds\n',t);
  parsfiles = dir2cell('parsCells/*');
  load(parsfiles{end});
  pars = parsCell{1};
  anfile = fullfile(pars.paths.folders.pathToResults,'an.mat');
  locsfile = strrep(pars.paths.files.fn_libsvm,'.train','.mat');
  an3 = an_1dTo3d(anfile, locsfile, pars);
  plot(an3(:)./(1-an3(:)));
  ylabel('Anomaly rating per spatial location (12x16x925)');
  cd(d)
catch ME
  cd(d);
  rethrow(ME);
end
