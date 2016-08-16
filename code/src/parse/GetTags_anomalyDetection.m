function tags = GetTags_anomalyDetection(pars)

% - system: 
tags.datestring = datestr(now,'yyyy_mm_dd');
tags.timestring = datestr(now,'HH_MM_SS');

% - inputs: video, groundtruth

% - features
[~,name,~] = fileparts(pars.pathToVideo); %output = [pathstr, name, ext]
if ~isinf(pars.endFrame)
    error('Filename doesn''t include endFrame.  Need to code some more before doing this.')
end

% -- raw features
% Check if we're combining across the frame

if strcmpi(pars.ScoreEach, 'interestpoint')
    if strcmpi(pars.BOVtype,'hard')
        warning('Changing BOVtype to ''none'' because ScoreEach = ''interestpoint''\n')
        pars.BOVtype = 'none';
    end
end
% --- DT
if strcmpi(pars.rawFeatType,'DT')
    if ischar(pars.W)
        tags.dtOutStr = '_DT';
    else
        tags.dtOutStr = sprintf('_DT_W_%d',pars.W);
    end
    if (pars.frameToBlocks); % 1: should divide each frame up into 'blocks';
        if length(pars.blockSize) ~= 3 || length(pars.blockStride) ~= 3
            display(blockSize)
            display(blockStride)
            error('blockSize and blockStride must each be a vector of size 3');
        end
        tags.rawfeats = sprintf('%s_frameToBlocks_sz_%.3g_%.3g_%.3g_stride_%.3g_%.3g_%.3g', ...
            tags.dtOutStr, pars.blockSize(1),pars.blockSize(2),pars.blockSize(3), ...
            pars.blockStride(1),pars.blockStride(2),pars.blockStride(3));
    else
        tags.rawfeats = sprintf('%s',tags.dtOutStr);
    end
% --- cuboid
elseif strcmpi(pars.rawFeatType,'cuboidBin')
    tags.rawfeats = sprintf( ...
        '_cuboidBin_fBlock_%d_sigma_%.3g_tau_%.3g_thresh_%.3g_maxn_%d_overlapr_%.3g.mat', ...
        pars.fBlock, pars.sigma, pars.tau, pars.thresh, pars.maxn, pars.overlap_r);

% --- cuboidDT
elseif strcmpi(pars.rawFeatType,'cuboidDT')
    if ischar(pars.W)
        dtOutStr = sprintf('');
    else
        dtOutStr = sprintf('_W_%d',pars.W);
    end
    tags.dtOutStr = dtOutStr;
    tags.rawfeats = sprintf('%s_cuboidDT_%s_maxn_%d_win_%.3g_%.3g_mult_%.3g_%.3g', ...
        name,dtOutStr,pars.maxn_Cub,pars.cuboidWindowSz(1),pars.cuboidWindowSz(3), ...
        pars.cuboidSlideMults(1),pars.cuboidSlideMults(3));

% --- freq
elseif strcmpi(pars.rawFeatType,'freq')
    tags.rawfeats = sprintf('_freq_downsampleSize_%.3gx%.3g_fftwindow_%.3g', ...
        pars.downsampleSize(1),pars.downsampleSize(2),pars.fft_window);
else
    error('Didn''t recognize the rawFeatType')
end

% -- post processed features
if strcmpi(pars.featType,'mine')
    % --- whitened
    if pars.whitenBeforeKmeans
        tags.whiteparsstring = sprintf('_%s_white_1','all');
    else
        tags.whiteparsstring = sprintf('_%s',pars.dictTrain);
    end

    % --- BOV
    if isempty(pars.normHist) || strcmpi(pars.normHist,'none')
        tags.normHist = sprintf('_histNorm_%s','none');
    else
        tags.normHist = sprintf('_histNorm_%s',pars.normHist);
    end
    if strcmpi(pars.BOVtype,'none') || isempty(pars.BOVtype)
        tags.BOVparsstring = sprintf('_BOV_none%s',tags.normHist);
        tags.kmeansparsstring = '';
    else
        tags.BOVparsstring = sprintf('_BOV_%s%s',pars.BOVtype,tags.normHist);
        if strcmpi(pars.dictTrain,'none')
            tags.dictTrain = '';
        else
            tags.dictTrain = sprintf('_%s',pars.dictTrain);
        end
        tags.kmeansparsstring = sprintf('_kmeans_%s_K_%d',pars.dictTrain,pars.K);
    end
end

if strcmpi(pars.featType,'liu')
    tags.liufeats = sprintf('_pW_%d_tprLen_%d_MTthr_%d_srs_%d_trs_%d_nEV_%d', ...
        pars.liu_patchWin, pars.liu_tprLen, pars.liu_MT_thr, pars.liu_srs,  ...
        pars.liu_trs,pars.liu_numEachVol);
    tags.liuPCA = sprintf('_PCAdim_%d', ...
        pars.liu_PCAdim);
end
if strcmpi(pars.methodType,'liusparse')
    tags.liusparsedictionary = sprintf('_dim_%d_thr_%.3g',pars.liusparse_dim,pars.liusparse_thr);
end
% - results
tags.argsString = pars.argsString;
resultsnm = sprintf('%s%s',name,tags.argsString);
tags.resultsnm = ShortenFilename(resultsnm);

end

function resultsnm = ShortenFilename(resultsnm)

replaceMes={'whitenAfterKmeans', 'normHist', 'dictTrain', 'finalFeatMATfile', 'whitenBeforeAnomalyDetect'};
replacements={'wAK',             'nH',       'dT'           ,   'ffMf', 'wBAD'};
i = 1;
[~, nm, ext]=fileparts(resultsnm);
resultsnm = [nm ext];
while length(resultsnm) > 250
    if i > length(replaceMes)
        [~, nm, ext]=fileparts(resultsnm);
        nm=nm(1:250); % Just give up and cut it off.
        resultsnm=[nm ext];
        warning('Had to shorten results name from %s to %s',resultsnm,[nm ext]);
        break;
    end
    resultsnm = strrep(resultsnm,replaceMes{i}, replacements{i});
    i = i + 1;
end

end
