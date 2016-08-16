function wrap_MakeFigure(pars, plotPars, h)
% You can tell this which figure you want to generate and it'll call the correct function.
figure(h);
switch plotPars.plotType
    case 'vs'
        plotVs(pars, plotPars);
    case 'ROC'
        plotROC(pars, plotPars);
    case 'Movie_GT'
        Movie_GT(pars, plotPars);
    otherwise
        error('plotPars.plotType not implemented')
end

end
