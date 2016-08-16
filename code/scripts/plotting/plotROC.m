
function plotROC(pars, plotPars)

    upsize_to_gt = 0;
    
    gt_file = load(pars.paths.files.pathToGroundTruth,'volLabel'); %;
    y_file = load(fullfile(pars.paths.folders.pathToResults,'an'));
    fnLoc_file = load(pars.paths.files.finalFeatMATfile);
    volFile = GenerateVolname(pars.paths.files.pathToVideo);
    load(volFile,'vol')
    [M,N,T] = size(vol);
    BKH = M/pars.liu_patchWin;
    BKW = N/pars.liu_patchWin;
    an = y_file.an;
    volLabel = gt_file.volLabel;
    LocV3 = fnLoc_file.LocV3;
%     an = an-median(an);
%     an = an./(1-an);
    an3 = An1dTo3d(an, LocV3, BKH, BKW,T);
    [y,gt] = ConvertGtAnToSameForm(an3, volLabel, upsize_to_gt, plotPars.gttype);
    [y,gt] = ClipSignals(y,gt,0.1);
    [FPx, TPy, threshvals] = getROCcurve(y, gt, plotPars.ROCspacing);

%     subplot(2,1,1);
%     plot(gt);
%     subplot(2,1,2);
%     plot(y);
%     
    plot(FPx,TPy);
    AUC = trapz(FPx,TPy);
    ylabel(sprintf('AUC=%.3g',AUC));
end
