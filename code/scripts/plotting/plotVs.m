function plotVs(pars, plotPars, an, volLabel, LocV3)

    upsize_to_gt = 0;
    
    if ~exist('volLabel','var')
        gt_file = load(pars.paths.files.pathToGroundTruth,'volLabel'); %;
        volLabel = gt_file.volLabel;
    end
    if ~exist('an','var')
        y_file = load(fullfile(pars.paths.folders.pathToResults,'an'));
        an = y_file.an;
    end
    if ~exist('LocV3','var')
        fnLoc_file = load(pars.paths.files.finalFeatMATfile);
        LocV3 = fnLoc_file.LocV3;
    end
    volFile = GenerateVolname(pars.paths.files.pathToVideo);
    if ~exist(volFile,'file')
        outdir = extractFrames(pars.paths.files.pathToVideo);
        vol = Frames2Vol(outdir, pars.liu_imresize);
        save(volFile,'vol','-v7.3');
    else
        fprintf('Found test file %s\n',volFile);
    end
    load(volFile,'vol')
    [M,N,~] = size(vol);
    BKH = M/pars.liu_patchWin;
    BKW = N/pars.liu_patchWin;
    an = an-median(an);
    an = an./(1-an);
    T = max(LocV3(3,:));
    an3 = An1dTo3d(an, LocV3, BKH, BKW,T);
    [y,gt] = ConvertGtAnToSameForm(an3, volLabel, upsize_to_gt, plotPars.gttype);
    
    [y,gt] = ClipSignals(y,gt,0.1);

    subplot(2,1,1);
    plot(gt);
    subplot(2,1,2);
    plot(y);

end

