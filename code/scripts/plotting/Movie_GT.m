
function Movie_GT(pars, plotPars)
    
    gt_file = load(pars.paths.files.pathToGroundTruth,'volLabel'); %;
    
    for i = 1:length(gt_file.volLabel)
        imshow(gt_file.volLabel{i});
        title(sprintf('%03d/%03d',i,length(gt_file.volLabel)));
        drawnow;
    end

end
